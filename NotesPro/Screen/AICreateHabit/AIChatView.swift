//
//  AIChatBubbleView.swift
//  NotesPro
//
//  Created by Arya Adyatma on 16/07/24.
//
import SwiftUI
import Combine

struct Message: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUser: Bool
    var displayedText: String
    
    init(text: String, isUser: Bool) {
        self.text = text
        self.isUser = isUser
        self.displayedText = isUser ? text : ""
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
}


struct AIChatView: View {
    @State private var messageText = ""
    @State private var chatMessages: [Message] = []
    @State private var currentQuestionIndex = 0
    @State private var isLoading: Bool = false
    @State private var aiResponse: String = ""
    @State private var isInputEnabled: Bool = true
    @State private var recommendations: [Recommendation] = []
    @State private var lastItemId: UUID?
    
    @ObservedObject var aiService: AIService = AIService(
        identifier: FakeAPIKey.GPT4o.rawValue, useStreaming: false, isConversation: false)
    
    let questions = [
        "What specific habit do you want to build?",
        "When do you prefer to do your habit?",
        "Where do you want to do it?",
        "What do you want to achieve from building your habit?",
        "What have you done before related to your new habit?",
        "What small activity or things you like to do or get as a reward?"
    ]
    
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack{
                                Spacer()
                            }
                            ForEach($chatMessages) { $message in
                                if message.isUser {
                                    UserBubble(text: message.text)
                                        .id(message.id)
                                } else {
                                    BotBubble(message: $message)
                                        .id(message.id)
                                }
                            }
                            
                            if !recommendations.isEmpty {
                                ForEach(recommendations) { recommendation in
                                    RecommendationCard(recommendation: recommendation)
                                        .padding(.top, 5)
                                }
                                
                                Button(action: resetChat) {
                                    Text("Reset")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.accentColor)
                                        .cornerRadius(10)
                                }
                                .padding(.top)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: chatMessages) { _ in
                        if let lastMessage = chatMessages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    TextField("Type a message...", text: $messageText)
                        .padding(10)
                        .background(Color(UIColor.tertiarySystemBackground))
                        .cornerRadius(20)
                        .disabled(!isInputEnabled)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(isInputEnabled ? .accentColor : .gray)
                    }
                    .disabled(!isInputEnabled)
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            addInitialMessages()
        }
    }
    

    
    func addInitialMessages() {
        let welcomeMessage = Message(text: "Hi! How can I help you?", isUser: false)
        let firstQuestion = Message(text: questions[0], isUser: false)
        
        chatMessages.append(welcomeMessage)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            chatMessages.append(firstQuestion)
            currentQuestionIndex += 1
        }
    }
    
    func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        // Add user message
        let userMessage = Message(text: messageText, isUser: true)
        chatMessages.append(userMessage)
        
        // Add bot response
        if currentQuestionIndex < questions.count {
            let botResponse = Message(text: questions[currentQuestionIndex], isUser: false)
            chatMessages.append(botResponse)
            currentQuestionIndex += 1
        } else if currentQuestionIndex == questions.count {
            let finalResponse = Message(text: "Okay, I will generate a few recommendations for you. Please wait...", isUser: false)
            chatMessages.append(finalResponse)
            currentQuestionIndex += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                askAI()
            }
            
            isInputEnabled = false
        }
        
        // Clear the text field
        messageText = ""
    }
    
    func getInterviewQuestionAndAnswers() -> String {
        var result = ""
        var currentQuestion: String?
        
        for message in chatMessages {
            if !message.isUser {
                if let question = currentQuestion {
                    result += "Q: \(question)\nA: No answer provided\n\n"
                }
                currentQuestion = message.text
            } else {
                if let question = currentQuestion {
                    result += "Q: \(question)\nA: \(message.text)\n\n"
                    currentQuestion = nil
                }
            }
        }
        
        if let question = currentQuestion {
            result += "Q: \(question)\nA: No answer provided\n\n"
        }
        
        return result
    }
    
    func askAI() {
        let prompt = """
        Based on the Atomic Habits framework by James Clear, provide recommendations for building the habit described below. Format the response as a JSON array of objects.
        
        Consider the following principles from Atomic Habits:
        1. Make it obvious
        2. Make it attractive
        3. Make it easy
        4. Make it satisfying
        
        Provide 3 task recommendations that align with these principles and help establish the desired habit.
        Each recommendation should only have 2-3 tasks.
        Each task max 5 words.
        The title should be recommendation 1 to 3.
        
        Example response format:
        {
            "recommendations": [
                {
                    "title": "Recommendation 1",
                    "tasks": [
                        "Search for new book",
                        "Read book for 5 minutes",
                        "Write a summary"
                    ]
                },
                {
                    "title": "Recommendation 2",
                    "tasks": [
                        "Search for new articles",
                        "Read articles for 10 minutes"
                    ]
                },
                {
                    "title": "Recommendation 3",
                    "tasks": [
                        "Buy new book",
                        "Read book for 15 minutes",
                        "Discuss with a friend",
                        "Write a review"
                    ]
                }
            ]
        }
        
        Don't wrap your response with backticks.
        
        Now generate habits based on this interview with user:
        \(getInterviewQuestionAndAnswers())
        """
        
        print("[ASKING]\n\(prompt)")
        
        isLoading = true
        
        aiService.sendMessage(query: prompt, uiImage: nil)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    isLoading = false
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    isLoading = false
                }
            } receiveValue: { response in
                print("[AI RESPONSE]\n\(response)")
                aiResponse = response
                parseRecommendations(from: response)
            }
            .store(in: &aiService.cancellables)
    }
    
    func parseRecommendations(from response: String) {
        guard let data = response.data(using: .utf8) else {
            print("Failed to convert response to data")
            return
        }
        
        do {
            let json = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
            recommendations = json.recommendations.map { Recommendation(title: $0.title, items: $0.tasks) }
        } catch {
            print("Failed to parse JSON: \(error)")
        }
    }
    
    func resetChat() {
        chatMessages.removeAll()
        currentQuestionIndex = 0
        isInputEnabled = true
        recommendations.removeAll()
        addInitialMessages()
    }
}

struct RecommendationsResponse: Codable {
    let recommendations: [RecommendationResponse]
}

struct RecommendationResponse: Codable {
    let title: String
    let tasks: [String]
}

struct BotBubble: View {
    @Binding var message: Message
    
    var body: some View {
        HStack {
            TypewriterText(message.text)
                .padding()
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(15)
                .frame(maxWidth: 280, alignment: .leading)
            Spacer()
        }
    }
}

struct UserBubble: View {
    let text: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(Color(.systemBackground))
                .cornerRadius(15)
                .frame(maxWidth: 280, alignment: .trailing)
        }
    }
}

struct Recommendation: Identifiable {
    let id = UUID()
    let title: String
    let items: [String]
}

struct RecommendationCard: View {
    let recommendation: Recommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(recommendation.title)
                    .font(.headline)
                    .padding(.vertical, 10)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.accentColor)
            }
            .padding(.horizontal)
            
            ForEach(recommendation.items, id: \.self) { item in
                Text(item)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                Divider()
                    .padding(.leading)
            }
        }
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(10)
    }
}


struct TypewriterText: View {
    let text: String
    let interval: TimeInterval
    let onComplete: (() -> Void)?
    
    @State private var displayedText: String = ""
    @State private var isAnimationComplete = false
    @State private var animationCancellable: AnyCancellable?
    @State private var isPaused = false
    
    init(_ text: String, interval: TimeInterval = 0.05, onComplete: (() -> Void)? = nil) {
        self.text = text
        self.interval = interval
        self.onComplete = onComplete
    }
    
    var body: some View {
        Text(displayedText)
            .onAppear(perform: startAnimation)
            .onDisappear(perform: cancelAnimation)
            .onChange(of: text) { _ in
                resetAnimation()
            }
    }
    
    private func startAnimation() {
        guard !isAnimationComplete else { return }
        
        let characters = Array(text)
        var currentIndex = 0
        
        animationCancellable = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                guard !isPaused && currentIndex < characters.count else {
                    if currentIndex >= characters.count {
                        isAnimationComplete = true
                        animationCancellable?.cancel()
                        onComplete?()
                    }
                    return
                }
                
                displayedText.append(characters[currentIndex])
                currentIndex += 1
            }
    }
    
    private func cancelAnimation() {
        animationCancellable?.cancel()
    }
    
    private func resetAnimation() {
        cancelAnimation()
        displayedText = ""
        isAnimationComplete = false
        startAnimation()
    }
    
    func pause() {
        isPaused = true
    }
    
    func resume() {
        isPaused = false
    }
}



#Preview {
    AIChatView()
}

struct TypewriterText_Previews: PreviewProvider {
    @State static var displayedText = ""
    
    static var previews: some View {
        TypewriterText("Hello, World!")
    }
}

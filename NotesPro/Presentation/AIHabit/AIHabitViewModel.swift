//
//  AIHabitViewModel.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 31/07/24.
//

import Foundation

final class AIHabitViewModel: ObservableObject {
//    @Published var isShowAIOnboarding: Bool = false
    @Published var isShowAIChatSheet: Bool = false
    @Published var chatMessages: [Message] = []
    @Published var recommendations: [Recommendation] = []
    
    @Published var habitName: String = ""
    @Published var definedTasks: [TaskModel] = []
    
    @Published var lastItemId: UUID?
    @Published var aiResponse: String = ""
    @Published var messageText = ""
    @Published var currentQuestionIndex = 0
    @Published var keyboardHeight: CGFloat = 0
    @Published var isLoading: Bool = false
    @Published var isInputEnabled: Bool = true
    
    @Published var aiService: AIService
    
    init(aiService: AIService) {
        self.aiService = aiService
    }
    
    let questions = [
        "What specific habit do you want to build?",
        "When do you prefer to do your habit?",
        "Where do you want to do it?",
        "What do you want to achieve from building your habit?",
        "What have you done before related to your new habit?",
        "What small activity or things you like to do or get as a reward?"
    ]
    
    func populateFromRecommendation(_ recommendation: Recommendation) {
        habitName = recommendation.title
        definedTasks = recommendation.items.map { TaskModel(taskName: $0) }
    }
    
    func showAIChatSheet() {
        isShowAIChatSheet = true
    }
    
    func dismissAIChatSheet() {
        isShowAIChatSheet = false
    }
    
    func resetChat() {
        chatMessages.removeAll()
        recommendations.removeAll()
        currentQuestionIndex = 0
        isInputEnabled = true
        isLoading = false
        aiResponse = ""
        messageText = ""
        lastItemId = nil

        aiService.cancel()
//        addInitialMessages()
    }
    
    func addInitialMessages() {
        let welcomeMessage = Message(text: "Hi! How can I help you?", isUser: false)
        let firstQuestion = Message(text: questions[0], isUser: false)
        
        chatMessages.append(welcomeMessage)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.chatMessages.append(firstQuestion)
            self.currentQuestionIndex += 1
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
                self.askAI()
            }
            
            isInputEnabled = false
        }
        
        // Clear the text field
        messageText = ""
    }

    func askAI() {
        let prompt = """
        Based on James Clear's Atomic Habits framework, provide practical and specific recommendations for building the habit described in the user interview. Format the response as a JSON array of objects.

        Consider these principles from Atomic Habits, focusing on making the habit:
        1. Obvious: Use clear cues in the environment
        2. Attractive: Link it to something enjoyable
        3. Easy: Start with a very small action
        4. Satisfying: Create immediate rewards

        Provide 3 habit recommendations that align with these principles and help establish the desired habit.
        - Each recommendation should have 3-5 concrete, actionable tasks.
        - Each task should be max 4-7 words and very specific, concrete, and actionable task.
        - The title is the habit title that should be a concise, action-oriented habit name.

        Example response format:
        {
            "recommendations": [
                {
                    "title": "10-Minute Daily Meditation",
                    "tasks": [
                        "Set phone reminder at 7AM",
                        "Sit on cushion for 10 minutes",
                        "Log session in habit app",
                        "Reward yourself with lemon drink",
                    ]
                },
                {
                    "title": "Five Pushups Per Day",
                    "tasks": [
                        "Place yoga mat by bed",
                        "Do 5 pushups after waking up",
                        "Reward yourself with cold bath"
                    ]
                },
                {
                    "title": "Nightly Gratitude Journal",
                    "tasks": [
                        "Put journal on pillow",
                        "Write 3 grateful things",
                        "Reward with favorite lotion"
                    ]
                }
            ]
        }

        Key points for recommendations:
        - Make tasks extremely specific and actionable
        - Start with tiny, easy-to-do actions
        - Include clear environmental cues
        - Add immediate rewards or tracking

        Important notes:
        - Do not include triple backticks in your JSON response.
        - Give recommendations in the same language as the user interview (English or Indonesian or the language based in user interview).
        - Base your recommendations on the following user interview, ensuring they are tailored to the user's specific situation and goals:

        Now make recommendations based on the interview below.
        \(getInterviewQuestionAndAnswers())
        """
        
        print("[ASKING]\n\(prompt)")
        
        isLoading = true
        
        aiService.sendMessage(query: prompt, uiImage: nil)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.isLoading = false
                    
                    let botResponse = Message(text: "Error: Can't connect to AI backend (Rate limited). Please try again.", isUser: false)
                    self.chatMessages.append(botResponse)
                    
                }
            } receiveValue: { response in
                print("[AI RESPONSE]\n\(response)")
                self.aiResponse = response
                self.parseRecommendations(from: response)
            }
            .store(in: &aiService.cancellables)
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

    func parseRecommendations(from response: String) {
        guard let data = response.data(using: .utf8) else {
            print("Failed to convert response to data")
            return
        }
        
        do {
            let json = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
            recommendations = json.recommendations.map { Recommendation(title: $0.title, items: $0.tasks) }
            if let lastRecommendation = recommendations.last {
                lastItemId = lastRecommendation.id
            }
        } catch {
            let botResponse = Message(text: "Error: Can't connect to AI backend (Rate limited). Please try again.", isUser: false)
            chatMessages.append(botResponse)
            print("Failed to parse JSON: \(error)")
        }
    }
}

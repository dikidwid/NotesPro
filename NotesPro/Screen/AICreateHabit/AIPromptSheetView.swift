//
//  AISheetView.swift
//  NotesPro
//
//  Created by Arya Adyatma on 12/07/24.
//
import SwiftUI

struct HabitFormView: View {
    @State private var habit = "build muscle"
    @State private var frequency = "5 pm"
    @State private var location = "gym"
    @State private var goal = "have sixpack body"
    @State private var currentActivity = "work from 9 am to 4 pm"
    @State private var reward = "lollipop"
    
    @State private var aiResponse: String = ""
    @State private var isLoading: Bool = false
    
    @ObservedObject var aiService: AIService = AIService(
        identifier: AICreds.freeAICreds.rawValue, useStreaming: false, isConversation: false)
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 0) {
                        Text("I want to ")
                            .font(.title2)
                            .fontWeight(.bold)
                        TextField("habit you want to build", text: $habit)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(8)
                        Text(",")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    HStack(spacing: 0) {
                        Text("I'll do it every ")
                            .font(.title2)
                            .fontWeight(.bold)
                        TextField("when you want to do it", text: $frequency)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                    
                    HStack(spacing: 0) {
                        Text("at ")
                            .font(.title2)
                            .fontWeight(.bold)
                        TextField("where you want to do it", text: $location)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(8)
                        Text(" so that I can")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    HStack(spacing: 0) {
                        TextField("somethings that you want", text: $goal)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(8)
                        
                        Text(".")
                            .font(.title2)
                            .fontWeight(.bold)
                    }

                    
                    HStack(spacing: 0) {
                        Text("Currently, I")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.top)
                    
                    HStack(spacing: 0) {
                        TextField("something that you do repeatedly", text: $currentActivity)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(8)
                        Text(", and I")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    TextField("small reward I wanted after done my habits", text: $reward)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                    
                    Text("as my reward.")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Button(action: askAI) {
                        HStack {
                            Text("Generate AI Recommendations")
                                .foregroundStyle(.black)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                    }
                    .disabled(isLoading)
                    .padding(.top)
                    
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    if !aiResponse.isEmpty {
                        Text("AI Recommendations:")
                            .font(.headline)
                            .padding(.top)
                        
                        HStack {
                            Text(aiResponse)
                                .padding()
                            Spacer()
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                }
                .padding()
                .padding(.top)
            }
        }
    }
    
    func askAI() {
        isLoading = true
        aiResponse = ""
        
        let prompt = """
        Based on the Atomic Habits framework by James Clear, provide recommendations for building the habit described below. Format the response as a JSON array of objects.
        
        Consider the following principles from Atomic Habits:
        1. Make it obvious
        2. Make it attractive
        3. Make it easy
        4. Make it satisfying
        
        Provide 1-5 task recommendations that align with these principles and help establish the desired habit.
        
        Schema (Swift):
        ```
        class DailyTaskDefinition {
        var taskName: String
        var reminder: DailyTaskReminder?
        }
        
        class DailyTaskReminder {
        var isEnabled: Bool
        var clock: Date
        var repeatDays: DailyTaskReminderRepeatDays
        }
        
        class DailyTaskReminderRepeatDays {
        var sunday: Bool = false
        var monday: Bool = false
        var tuesday: Bool = false
        var wednesday: Bool = false
        var thursday: Bool = false
        var friday: Bool = false
        var saturday: Bool = false
        }
        ```
        
        Example response format:
        [
            "taskName": "Morning Exercise",
            "reminder": {
                "isEnabled": true,
                "clock": "13:25",
                "repeatDays": {
                    "sunday": false,
                    "monday": true,
                    "tuesday": true,
                    "wednesday": true,
                    "thursday": true,
                    "friday": true,
                    "saturday": false
                    }
                }
            }
        ]
        
        Don't wrap your response with backticks.
        
        ---
        
        "I want to \(habit). I will do it every \(frequency) at \(location) so that I can \(goal).
        Currently, I \(currentActivity), and I reward myself with \(reward)"
        """
        
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
                aiResponse = response
            }
            .store(in: &aiService.cancellables)
    }
    
}

#Preview {
    HabitFormView()
}




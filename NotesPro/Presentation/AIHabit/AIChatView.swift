//
//  AIChatBubbleView.swift
//  NotesPro
//
//  Created by Arya Adyatma on 16/07/24.
//
import SwiftUI
import Combine

struct AIChatView: View {
    @ObservedObject var aiHabitViewModel: AIHabitViewModel
    @FocusState private var isFocused: Bool
    var onDismiss: ((Recommendation) -> Void?)

    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.all)
                
                VStack {
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack{
                                    Spacer()
                                }
                                ForEach($aiHabitViewModel.chatMessages) { $message in
                                    if message.isUser {
                                        UserBubble(text: message.text)
                                            .id(message.id)
                                    } else {
                                        BotBubble(message: $message)
                                            .id(message.id)
                                    }
                                }
                                
                                if !aiHabitViewModel.recommendations.isEmpty {
                                    ForEach(aiHabitViewModel.recommendations) { recommendation in
                                        RecommendationCard(recommendation: recommendation)
                                            .padding(.top, 5)
                                            .onTapGesture {
                                                onDismiss(recommendation)
                                                aiHabitViewModel.dismissAIChatSheet()
                                            }
                                    }
                                    
                                    Button {
                                        aiHabitViewModel.resetChat()
                                    } label: {
                                        Label("Reset", systemImage: "gobackward")
                                            .foregroundStyle(.black)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(Color.accentColor)
                                    .padding(.top)
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .padding()
                        }
                        .onChange(of: aiHabitViewModel.chatMessages) {
                            if let lastMessage = aiHabitViewModel.chatMessages.last {
                                withAnimation {
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                        .onChange(of: aiHabitViewModel.lastItemId) { _, id in
                            if let id = id {
                                withAnimation {
                                    proxy.scrollTo(id, anchor: .bottom)
                                }
                            }
                        }
                        .onChange(of: aiHabitViewModel.keyboardHeight) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                if let lastMessage = aiHabitViewModel.chatMessages.last {
                                    withAnimation {
                                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        TextField("Type a message...", text: $aiHabitViewModel.messageText, axis: .vertical)
                            .focused($isFocused)
                            .padding(10)
                            .padding(.horizontal, 10)
                            .background(Color(UIColor.tertiarySystemBackground))
                            .cornerRadius(20)
                            .disabled(!aiHabitViewModel.isInputEnabled)
                        
                        Button {
                            aiHabitViewModel.sendMessage()
                            isFocused = false
                        } label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(aiHabitViewModel.isInputEnabled ? .accentColor : .gray)
                        } 
                        .disabled(!aiHabitViewModel.isInputEnabled)

                    }
                    .padding(.horizontal)
                    .padding(.bottom, 2)
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitle("AI Habit Generator", displayMode: .inline)
            .onAppear {
                aiHabitViewModel.addInitialMessages()
//                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
//                    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//                        let keyboardRectangle = keyboardFrame.cgRectValue
//                        aiHabitViewModel.keyboardHeight = keyboardRectangle.height
//                    }
//                }
//                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
//                    aiHabitViewModel.keyboardHeight = 0
//                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        aiHabitViewModel.resetChat()
                        aiHabitViewModel.dismissAIChatSheet()
                    }
                }
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            isFocused = false
                        }
                    }
                }
            }
        }
    }
}

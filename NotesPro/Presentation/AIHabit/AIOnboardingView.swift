//
//  AIOnboardingView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 16/07/24.
//

import SwiftUI

struct AIOnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var appCoordinator: AppCoordinatorImpl
    @StateObject private var aiHabitViewModel: AIHabitViewModel
    
    init(aiHabitViewModel: AIHabitViewModel) {
        self._aiHabitViewModel = StateObject(wrappedValue: aiHabitViewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(colorScheme == .dark ? .black : Color(.systemGroupedBackground))
                    .ignoresSafeArea(edges: .top)
                
                Image(.aiOnboardingBG)
                    .resizable()
                    .padding(.top, 75)
                
                VStack(alignment: .leading) {
                    Spacer()
                    
                    Text("Hey,\nI'm ready to\nhelp you here!")
                        .font(.system(.largeTitle, weight: .bold))
                        .padding(.bottom, 35)
                        .padding(.top, 100)
                    
                    Text("AI will help you generated a few\ntasks from your prompt")
                        .font(.system(.body))
                    
                    Spacer()
                    
                    Button {
//                        addHabitViewModel.showAIChatSheet()
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .overlay {
                                Text("I'm Ready")
                                    .font(.system(.headline))
                                    .foregroundStyle(.black)
                            }
                            .frame(height: 44)
                    }
                    .padding(.bottom, 7)
                    
                    Text("AI will only give you some suggestions. The decision is still yours to make!")
                        .font(.system(.caption))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .navigationBarTitle("AI Habit Generator", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
            .navigationDestination(isPresented: $aiHabitViewModel.isShowAIChatSheet) {
                AIChatView()
            }
        }
    }
}

#Preview {
    AIOnboardingView(aiHabitViewModel: AIHabitViewModel())
}

final class AIHabitViewModel: ObservableObject {
    @Published var isShowAIChatSheet: Bool = false
    @Published var chatMessages: [Message] = []
    @Published var recommendations: [Recommendation] = []
}

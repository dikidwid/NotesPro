//
//  GoalsView.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import SwiftUI
import SwiftData

struct GoalsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = GoalsViewModel()
    @Query private var goals: [Goal]
    @State private var selectedGoal: Goal? = nil
    @State var goToNextPage = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(goals) { goal in
                        Text(goal.title)
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
//                            let newGoal = viewModel.addGoal(modelContext: modelContext)
//                            viewModel.newGoalId = newGoal.id
//                            selectedGoal = newGoal
                            goToNextPage.toggle()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                                .padding()
                        }
                    }
                }
            }
            .navigationTitle("Goals")
        }
        .sheet(isPresented: $goToNextPage, content: {
            AddGoalView()
                .presentationDragIndicator(.visible)
                .environment(\.modelContext, modelContext)
        })
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Goal.self, configurations: config)

        return GoalsView()
            .environmentObject(GoalsViewModel())
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

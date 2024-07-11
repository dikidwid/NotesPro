//
//  GoalsViewModel.swift
//  NotesPro
//
//  Created by Jason Susanto on 10/07/24.
//

import Foundation
import SwiftData

class GoalsViewModel: ObservableObject {
    @Published var goal: Goal = Goal(title: "", description: "", deadlineDate: Date())
    @Published var newGoalId: UUID?
    
    func addGoal(modelContext: ModelContext) -> Goal {
        let newGoal = Goal(title: goal.title, description: goal.desc, deadlineDate: goal.deadlineDate)
        modelContext.insert(newGoal)
        try? modelContext.save()
        newGoalId = newGoal.id
        return newGoal
    }
    
    func saveGoal(modelContext: ModelContext) {
        try? modelContext.save()
    }
    
    func deleteGoal(at offsets: IndexSet, goal:[Goal], modelContext: ModelContext) {
        for index in offsets {
            modelContext.delete(goal[index])
        }
    }
}

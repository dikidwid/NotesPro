//
//  HabitsViewModel.swift
//  NotesPro
//
//  Created by Jason Susanto on 11/07/24.
//

import Foundation
import SwiftData

class HabitsViewModel: ObservableObject {
    @Published var habit: Habit = Habit(title: "", description: "Habits desc")
    
    func addHabit(modelContext: ModelContext) -> Habit {
        let newHabit = Habit(title: habit.title, description: habit.desc)
        modelContext.insert(newHabit)
        try? modelContext.save()
        return newHabit
    }
    
    func saveHabit(modelContext: ModelContext) {
        try? modelContext.save()
    }
    
    func addTask(to habit: Habit, taskName: String, modelContext: ModelContext) -> DailyTaskDefinition {
        let newTask = DailyTaskDefinition(taskName: taskName)
        habit.tasks.append(newTask)
        modelContext.insert(newTask)
        try? modelContext.save()
        return newTask
    }
}

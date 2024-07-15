//
//  AddHabitViewModel.swift
//  NotesPro
//
//  Created by Arya Adyatma on 15/07/24.
//

import SwiftUI
import SwiftData

class AddHabitViewModel: ObservableObject {
    @Published var habitName: String = ""
    @Published var habitDescription: String = ""
    @Published var definedTasks: [DailyTaskDefinition] = []
    @Published var reward: Reward?
    
    private var habit: Habit
    private var modelContext: ModelContext
    
    init(habit: Habit, modelContext: ModelContext) {
        self.habit = habit
        self.modelContext = modelContext
        self.habitName = habit.title
        self.habitDescription = habit.desc
        self.definedTasks = habit.definedTasks.sorted(by: { $0.createdDate < $1.createdDate })
        self.reward = habit.reward
    }
    
    func saveHabit() {
        habit.title = habitName
        habit.desc = habitDescription
        try? modelContext.save()
    }
    
    func addTask() -> DailyTaskDefinition {
        let newTask = DailyTaskDefinition(taskName: "")
        habit.definedTasks.append(newTask)
        definedTasks.append(newTask)
        try? modelContext.save()
        return newTask
    }
    
    func deleteTask(_ task: DailyTaskDefinition) {
        if let index = habit.definedTasks.firstIndex(where: { $0.id == task.id }) {
            habit.definedTasks.remove(at: index)
            definedTasks.removeAll(where: { $0.id == task.id })
            modelContext.delete(task)
            try? modelContext.save()
        }
    }
    
    func deleteEmptyTasks() {
        habit.definedTasks.removeAll(where: { $0.taskName.isEmpty })
        definedTasks.removeAll(where: { $0.taskName.isEmpty })
        try? modelContext.save()
    }
    
    func addReward() {
        let newReward = Reward(rewardName: "New Reward")
        habit.reward = newReward
        reward = newReward
        try? modelContext.save()
    }
    
    func deleteReward() {
        if let reward = habit.reward {
            modelContext.delete(reward)
            habit.reward = nil
            self.reward = nil
            try? modelContext.save()
        }
    }
}

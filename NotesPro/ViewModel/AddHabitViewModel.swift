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
    @Published var isValidHabit: Bool = false
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func updateModelContext(_ newContext: ModelContext) {
        self.modelContext = newContext
    }
    
    func saveHabit(habit: Habit) {
        habit.title = habitName.trimmingCharacters(in: .whitespacesAndNewlines)
        habit.desc = habitDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving habit: \(error.localizedDescription)")
        }
    }
    
    @discardableResult
    func addTask(to habit: Habit) -> DailyTaskDefinition {
        let newTask = DailyTaskDefinition(taskName: "")
        habit.definedTasks.append(newTask)
        updateValidHabitStatus(habit)
        return newTask
    }
    
    func deleteTask(_ task: DailyTaskDefinition, from habit: Habit) {
        habit.definedTasks.removeAll(where: { $0.id == task.id })
        modelContext.delete(task)
        updateValidHabitStatus(habit)
    }
    
    func deleteEmptyTasks(from habit: Habit) {
        let emptyTasks = habit.definedTasks.filter { $0.taskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        for task in emptyTasks {
            modelContext.delete(task)
        }
        habit.definedTasks.removeAll(where: { $0.taskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty })
        updateValidHabitStatus(habit)
    }
    
    func addReward(to habit: Habit) {
        if habit.reward == nil {
            let newReward = Reward(rewardName: "")
            habit.reward = newReward
        }
    }
    
    func deleteReward(from habit: Habit) {
        if let reward = habit.reward {
            modelContext.delete(reward)
            habit.reward = nil
        }
    }
    
    func updateHabitName(_ name: String) {
        habitName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updateValidHabitStatus()
    }
    
    private func updateValidHabitStatus(_ habit: Habit? = nil) {
        if let habit = habit {
            isValidHabit = !habitName.isEmpty && !habit.definedTasks.isEmpty
        } else {
            isValidHabit = !habitName.isEmpty
        }
    }
}

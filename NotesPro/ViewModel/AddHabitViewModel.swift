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
    @Published var definedTasks: [DailyTaskDefinition] = []
    @Published var isAIChatSheetPresented = false

    func updateHabitName(_ name: String) {
        habitName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updateValidHabitStatus()
    }
    
    func updateHabitDescription(_ description: String) {
        habitDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func saveHabit(modelContext: ModelContext, existingHabit: Habit?) {
        if let habit = existingHabit {
            updateHabit(habit, modelContext: modelContext)
        } else {
            saveNewHabit(modelContext: modelContext)
        }
    }
    
    private func saveNewHabit(modelContext: ModelContext) {
        let newHabit = Habit(title: habitName, description: habitDescription)
        newHabit.definedTasks = definedTasks
        modelContext.insert(newHabit)
        saveChanges(modelContext: modelContext)
    }
    
    private func updateHabit(_ habit: Habit, modelContext: ModelContext) {
        habit.title = habitName
        habit.desc = habitDescription
        habit.definedTasks = definedTasks
        saveChanges(modelContext: modelContext)
    }
    
    private func saveChanges(modelContext: ModelContext) {
        do {
            try modelContext.save()
        } catch {
            print("Error saving habit: \(error.localizedDescription)")
        }
    }
    
    @discardableResult
    func addTask() -> DailyTaskDefinition {
        let newTask = DailyTaskDefinition(taskName: "")
        definedTasks.append(newTask)
        updateValidHabitStatus()
        return newTask
    }
    
    func deleteTask(_ task: DailyTaskDefinition) {
        definedTasks.removeAll(where: { $0.id == task.id })
        updateValidHabitStatus()
    }
    
    func deleteEmptyTasks() {
        definedTasks.removeAll(where: { $0.taskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty })
        updateValidHabitStatus()
    }
    
    private func updateValidHabitStatus() {
        isValidHabit = !habitName.isEmpty && !definedTasks.isEmpty
    }
    
    func populateToEmpty() {
        habitName = ""
        definedTasks = []
    }
    
    func populateFromRecommendation(_ recommendation: Recommendation) {
        habitName = recommendation.title
        definedTasks = recommendation.items.map { DailyTaskDefinition(taskName: $0) }
        updateValidHabitStatus()
    }
    
    func populateFromHabit(_ habit: Habit?) {
        if let habit = habit {
            habitName = habit.title
            habitDescription = habit.desc
            definedTasks = habit.definedTasks
        } else {
            habitName = ""
            habitDescription = ""
            definedTasks = []
        }
        updateValidHabitStatus()
    }
    
    func showAIChatSheet() {
        isAIChatSheetPresented = true
    }
    
    func hideAIChatSheet() {
        isAIChatSheetPresented = false
    }
}

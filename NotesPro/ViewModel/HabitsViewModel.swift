//
//  HabitsViewModel.swift
//  NotesPro
//
//  Created by Jason Susanto on 12/07/24.
//

import Foundation
import SwiftData

class HabitsViewModel: ObservableObject{
    @Published var newHabitId: UUID?
    
    func addHabit(modelContext: ModelContext) -> Habit {
        let newHabit = Habit(title: "Hai", description: "")
        modelContext.insert(newHabit)
        try? modelContext.save()
        newHabitId = newHabit.id
        return newHabit
    }
    
    func deleteHabit(at indexSet: IndexSet,  habits: [Habit], modelContext: ModelContext){
        for index in indexSet {
            modelContext.delete(habits[index])
        }
    }
    
    func saveHabit(modelContext: ModelContext){
        try? modelContext.save()
    }
    
    func addTask(to habitId: UUID, taskName: String, modelContext: ModelContext) {
        let descriptor = FetchDescriptor<Habit>(predicate: #Predicate { $0.id == habitId })
        
        do {
            if let habit = try modelContext.fetch(descriptor).first {
                let newTask = DailyTaskDefinition(taskName: taskName)
                habit.tasks.append(newTask)
                try modelContext.save()
            } else {
                print("Habit with ID \(habitId) not found.")
            }
        } catch {
            print("Error fetching habit: \(error.localizedDescription)")
        }
    }
    
    func deleteTask(task: DailyTaskDefinition, from habit: Habit, modelContext: ModelContext) {
        if let index = habit.tasks.firstIndex(where: { $0.id == task.id }) {
            habit.tasks.remove(at: index)
            modelContext.delete(task)
            
            do {
                try modelContext.save()
            } catch {
                print("Error saving context after deleting task: \(error.localizedDescription)")
            }
        } else {
            print("Task not found in habit.")
        }
    }
}

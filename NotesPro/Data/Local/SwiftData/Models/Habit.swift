//
//  Habit.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import Foundation
import SwiftData

@Model
final class Habit: Identifiable {
    var id: UUID
    var habitName: String
    
    var currentStreak: Int
    var bestStreak: Int
    var lastCompletedDate: Date?
    
    @Relationship(deleteRule: .cascade, inverse: \DailyTaskDefinition.habit)
    var definedTasks: [DailyTaskDefinition] = []
    
    @Relationship(deleteRule: .cascade, inverse: \DailyHabitEntry.habit)
    var dailyHabitEntries: [DailyHabitEntry] = []
    
    init(id: UUID = UUID(),
         habitName: String,
         currentStreak: Int = 0,
         bestStreak: Int = 0,
         lastCompletedDate: Date? = nil,
         definedTasks: [DailyTaskDefinition] = [],
         dailyHabitEntries: [DailyHabitEntry] = []
    ) {
        self.id = id
        self.habitName = habitName
        self.currentStreak = currentStreak
        self.bestStreak = bestStreak
        self.lastCompletedDate = lastCompletedDate
        self.definedTasks = definedTasks
        self.dailyHabitEntries = dailyHabitEntries
    }
}
        

extension Habit {
    func hasEntry(for date: Date) -> DailyHabitEntry? {
        self.dailyHabitEntries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    func tasks(for date: Date) -> [DailyTask] {
        hasEntry(for: date)?.tasks.sorted(by: { $0.taskName < $1.taskName }) ?? []
    }
    
    func isAllTaskDone(for date: Date) -> Bool {
        hasEntry(for: date)?.tasks.filter { $0.isChecked == false }.count == 0
    }
    
    func isTaskEmpty(for date: Date) -> Bool {
        tasks(for: date).isEmpty
    }

    func totalUndoneTask(for date: Date) -> Int {
        tasks(for: date).filter { !$0.isChecked }.count
    }
}

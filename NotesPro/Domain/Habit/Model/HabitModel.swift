//
//  HabitModel.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 19/07/24.
//

import Foundation

struct HabitModel: Identifiable, Hashable {
    let id: UUID
    var habitName: String
    
    var currentStreak: Int
    var bestStreak: Int
    var lastCompletedDate: Date?
    
    var definedTasks: [TaskModel]
    var dailyHabitEntries: [DailyHabitEntryModel]
    var syncToCalendar: Bool
        
    init (
        id: UUID = UUID(),
        habitName: String, 
        currentStreak: Int = 0,
        bestStreak: Int = 0,
        lastCompletedDate: Date? = nil,
        definedTasks: [TaskModel] = [],
        dailyHabitEntries: [DailyHabitEntryModel] = [],
        syncToCalendar: Bool = false
    ) {
        self.id = id
        self.habitName = habitName
        self.currentStreak = currentStreak
        self.bestStreak = bestStreak
        self.lastCompletedDate = lastCompletedDate
        self.definedTasks = definedTasks
        self.dailyHabitEntries = dailyHabitEntries
        self.syncToCalendar = syncToCalendar
    }
}

extension HabitModel {
    func hasEntry(for date: Date) -> DailyHabitEntryModel {
        self.dailyHabitEntries.first { Calendar.current.isDate($0.date, inSameDayAs: date) } ?? DailyHabitEntryModel(date: date, note: "", habit: self, tasks: self.definedTasks)
    }

    func tasks(for date: Date) -> [TaskModel] {
        hasEntry(for: date).tasks.sorted(by: { $0.taskName < $1.taskName })
    }
    
    func isAllTaskDone(for date: Date) -> Bool {
        hasEntry(for: date).tasks.filter { $0.isChecked == false }.count == 0
    }
    
    func isDefinedTaskEmpty(for date: Date) -> Bool {
        tasks(for: date).isEmpty
    }

    func totalUndoneTask(for date: Date) -> Int {
        tasks(for: date).filter { !$0.isChecked }.count
    }
}

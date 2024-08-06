//
//  MapperToData.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 06/08/24.
//

import Foundation

extension HabitModel {
    func toHabit() -> Habit {
        return Habit(id: self.id,
                     habitName: self.habitName,
                     currentStreak: self.currentStreak,
                     bestStreak: self.bestStreak,
                     definedTasks: self.definedTasks.map ({ $0.toDailyTaskDefinition() })
        )
    }
    
    func toDailyTasks() -> [DailyTask] {
        self.definedTasks.map { $0.toDailyTask() }
    }
    
    func toTasksDefinitions() -> [DailyTaskDefinition] {
        self.definedTasks.map { $0.toDailyTaskDefinition() }
    }
    
    func toDailyHabitEntries() -> [DailyHabitEntry] {
        self.dailyHabitEntries.map { $0.toDailyHabitEntry() }
    }
}

extension TaskModel {
    func toDailyTask() -> DailyTask {
        DailyTask(id: self.id, taskName: self.taskName, isChecked: self.isChecked)
    }
    
    func toDailyTaskDefinition() -> DailyTaskDefinition {
        DailyTaskDefinition(id: self.id, taskName: self.taskName)
    }
}

extension HabitEntryModel {
    func toDailyHabitEntry() -> DailyHabitEntry {
        DailyHabitEntry(id: self.id, date: self.date, note: self.note, tasks: self.tasks.map{ $0.toDailyTask() })
    }
}

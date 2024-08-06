//
//  MapperToDomain.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 06/08/24.
//

import Foundation

extension Habit {
    func toHabitModel() -> HabitModel {
        HabitModel(
            id: self.id,
            habitName: self.habitName,
            currentStreak: self.currentStreak,
            bestStreak: self.bestStreak,
            lastCompletedDate: self.lastCompletedDate,
            definedTasks: self.toTaskModels(dailyTaskDefinitions: self.definedTasks),
            dailyHabitEntries: self.toDailyHabitEntries(dailyHabitEntries: self.dailyHabitEntries)
        )
    }
    
    func toTaskModels(dailyTaskDefinitions: [DailyTaskDefinition] ) -> [TaskModel] {
        dailyTaskDefinitions.map { $0.toTaskModel() }
    }
    
    func toDailyHabitEntries(dailyHabitEntries: [DailyHabitEntry]) -> [HabitEntryModel] {
        dailyHabitEntries.map { $0.toDailyHabitEntryModel() }
    }
}

extension DailyTask {
    func toTaskModel() -> TaskModel {
        TaskModel(id: self.id, taskName: self.taskName, isChecked: self.isChecked)
    }
}

extension DailyTaskDefinition {
    func toTaskModel() -> TaskModel {
        TaskModel(id: self.id, taskName: self.taskName)
    }
}

extension DailyHabitEntry {
    func toDailyHabitEntryModel() -> HabitEntryModel {
        HabitEntryModel(id: self.id, date: self.date, note: self.note, tasks: self.tasks.map({ $0.toTaskModel() }))
    }
}

//
//  (HabitResponse).swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 20/07/24.
//

import Foundation

extension Habit {
    func toHabitModel() -> HabitModel {
        HabitModel(
            id: self.id,
            habitName: self.title,
            currentStreak: self.currentStreak,
            bestStreak: self.bestStreak,
            lastCompletedDate: self.lastCompletedDate,
            definedTasks: self.toTaskDefinitionModels(dailyTaskDefinitions: self.definedTasks),
            dailyHabitEntries: self.toDailyHabitEntries(dailyHabitEntry: self.dailyHabitEntries)
        )
    }
    
    func toTaskDefinitionModels(dailyTaskDefinitions: [DailyTaskDefinition]) -> [TaskDefinitionModel] {
        dailyTaskDefinitions.map { $0.toTaskDefinitionModel() }
    }
    
    func toDailyHabitEntries(dailyHabitEntry: [DailyHabitEntry]) -> [DailyHabitEntryModel] {
        dailyHabitEntry.map { $0.toDailyHabitEntryModel() }
    }
}

extension DailyTaskDefinition {
    func toTaskDefinitionModel() -> TaskDefinitionModel {
        TaskDefinitionModel(taskName: self.taskName)
    }
}

extension DailyHabitEntry {
    func toDailyHabitEntryModel() -> DailyHabitEntryModel {
        DailyHabitEntryModel(date: self.day, note: self.userDescription)
    }
}

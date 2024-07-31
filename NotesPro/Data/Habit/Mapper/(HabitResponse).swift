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
            definedTasks: self.toTaskModels(dailyTaskDefinitions: self.definedTasks),
            dailyHabitEntries: self.toDailyHabitEntries(dailyHabitEntries: self.dailyHabitEntries)
        )
    }
    
    func toTaskModels(dailyTaskDefinitions: [DailyTaskDefinition] ) -> [TaskModel] {
        dailyTaskDefinitions.map { $0.toTaskModel() }
    }
    
    func toDailyHabitEntries(dailyHabitEntries: [DailyHabitEntry]) -> [DailyHabitEntryModel] {
        dailyHabitEntries.map { $0.toDailyHabitEntryModel() }
    }
}

extension DailyTaskDefinition {
    func toTaskModel() -> TaskModel {
        TaskModel(taskName: self.taskName)
    }
}

extension DailyHabitEntry {
    func toDailyHabitEntryModel() -> DailyHabitEntryModel {
        DailyHabitEntryModel(date: self.day, note: self.userDescription, habit: self.habit!.toHabitModel())
    }
}

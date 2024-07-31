//
//  Habit+Dummy.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 16/07/24.
//

import Foundation

struct DummyData {
    static var tasksDummy: [TaskModel] {
        [
            TaskModel(taskName: "Task 1"),
            TaskModel(taskName: "Task 2", isReminderEnabled: true),
            TaskModel(taskName: "Task 3")
        ]
    }
    
    private static func generateDummyEntries(for totalPastDays: Int, in habit: HabitModel) -> [DailyHabitEntryModel] {
        var entries: [DailyHabitEntryModel] = []
        var tasks: [TaskModel] = tasksDummy
        let calendar = Calendar.current
        let currentDate = Date()
        
        for totalPastDays in 0..<totalPastDays {
            if let date = calendar.date(byAdding: .day, value: -totalPastDays, to: currentDate) {
                var entry = DailyHabitEntryModel(
                    date: date,
                    note: "Entry for \(calendar.component(.day, from: date))",
                    habit: habit
                )
                
                for taskIndex in tasks.indices {
                    tasks[taskIndex].habitEntry = entry
                }
                
                entry.tasks = tasks
                entries.append(entry)
            }
        }
        
        return entries
    }
    
    static var habitsDummy: [HabitModel] {
        
        // MARK: Seeder for Today Reading Habit Entry
        var readingHabit = HabitModel(id: UUID(),
                                      habitName: "Reading Habit",
                                      currentStreak: 4,
                                      bestStreak: 10,
                                      lastCompletedDate: .now,
                                      definedTasks: tasksDummy)
        
        readingHabit.dailyHabitEntries = generateDummyEntries(for: 100, in: readingHabit)
        
        // MARK: Seeder for Today Writing Habit Entry
        var writingHabit = HabitModel(id: UUID(),
                                      habitName: "Writing Habit",
                                      currentStreak: 7,
                                      bestStreak: 23,
                                      lastCompletedDate: .now,
                                      definedTasks: tasksDummy)
        
        
        writingHabit.dailyHabitEntries = generateDummyEntries(for: 100, in: writingHabit)
                
        
        return [readingHabit, writingHabit]
    }
}

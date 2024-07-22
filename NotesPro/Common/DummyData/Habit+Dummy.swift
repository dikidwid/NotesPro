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
    static var habitsDummy: [HabitModel] {
        let todayReadingHabitEntry = DailyHabitEntryModel(date: .now,
                                                          note: "ini adalah note dari seorang sigma",
                                                          tasks: tasksDummy)
        
        let readingHabit = HabitModel(id: UUID(),
                                      habitName: "Reading Habit",
                                      currentStreak: 4,
                                      bestStreak: 10,
                                      lastCompletedDate: .now,
                                      definedTasks: [],
                                      dailyHabitEntries: [todayReadingHabitEntry])
        
        let writingHabit = HabitModel(id: UUID(),
                                      habitName: "Writing Habit",
                                      currentStreak: 7,
                                      bestStreak: 23,
                                      lastCompletedDate: .now,
                                      definedTasks: [],
                                      dailyHabitEntries: [])
        
        let today = Date()
        
        // MARK: Seeder for Today Reading Habit Entry
//        let readingTask1 = DailyTaskDefinition(taskName: "Read the book for 5 minutes")
//        let readingTask2 = DailyTaskDefinition(taskName: "Enjoy a cup of tea after reading")
        
//        let todayReadingHabitEntry = DailyHabitEntry(day: today)
//        todayReadingHabitEntry.habit = readingHabit
        
//        let firstReadingEntry = DailyTask(taskName: readingTask1.taskName)
//        let secondReadingEntry = DailyTask(taskName: readingTask2.taskName)
//        
//        firstReadingEntry.isChecked = true
//        secondReadingEntry.isChecked = true
//        
//        todayReadingHabitEntry.tasks = [
//            firstReadingEntry,
//            secondReadingEntry,
//        ]
//        
//        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
//
//        let yesterdayReadingHabitEntry = DailyHabitEntry(day: yesterday)
//        yesterdayReadingHabitEntry.habit = readingHabit
//        
//        yesterdayReadingHabitEntry.tasks = [
//            firstReadingEntry,
//            secondReadingEntry
//        ]
                
        // MARK: Seeder for Today Writing Habit Entry
//        let writingTask1 = DailyTaskDefinition(taskName: "Writing your experience today in a page")
//        let writingTask2 = DailyTaskDefinition(taskName: "Read on your own reflection")
        
//        let todayWritingHabitEntry = DailyHabitEntry(day: today)
//        todayWritingHabitEntry.habit = writingHabit
//        
//        let firstWritingEntry = DailyTask(taskName: writingTask1.taskName)
//        let secondWritingEntry = DailyTask(taskName: writingTask2.taskName)
//        
//        firstWritingEntry.isChecked = false
//        secondWritingEntry.isChecked = false
//        
//        todayWritingHabitEntry.tasks = [
//            firstWritingEntry,
//            secondWritingEntry,
//        ]
//
        
//        readingHabit.definedTasks.append(contentsOf: [readingTask1, readingTask2])
//        writingHabit.definedTasks.append(contentsOf: [writingTask1, writingTask2])
        
        return [readingHabit, writingHabit]
    }
}

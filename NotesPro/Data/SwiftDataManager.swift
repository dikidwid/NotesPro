//
//  SwiftDataManager.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 17/07/24.
//

import SwiftData
import SwiftUI

class SwiftDataManager: HabitDataSource {
    let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = SwiftDataManager()
    
    @MainActor
    private init() {
        // Change isStoredInMemoryOnly to false if you would like to see the data persistance after kill/exit the app
        let config = ModelConfiguration(isStoredInMemoryOnly: false)
        let container = try! ModelContainer(for: Habit.self,
                                            configurations: config)
        
        let habits: [Habit] = DummyData.habitsDummy
        
        for habit in habits {
            container.mainContext.insert(habit)
        }

        self.modelContainer = container
        self.modelContext = modelContainer.mainContext
    }
    
    func fetchHabits() async -> Result<[Habit], ResponseError> {
        do {
            let habits = try modelContext.fetch(FetchDescriptor<Habit>(sortBy: [SortDescriptor(\Habit.title)]))
            return .success(habits)
        } catch {
            return .failure(.localStorageError(cause: "Error fetching habits on SwiftDataManager"))
        }
    }
    
    func fetchDailyHabitEntries(from date: Date) async -> Result<[DailyHabitEntry], ResponseError> {
        do {
            let dailyHabitEntries = try modelContext.fetch(FetchDescriptor<DailyHabitEntry>(predicate: #Predicate<DailyHabitEntry> { $0.day == date }, sortBy: [SortDescriptor(\.day)]))
            return .success(dailyHabitEntries)
        } catch {
            return .failure(.localStorageError(cause: "Error fetching daily habit entries on SwiftDataManager"))
        }
    }
    
    func getOrCreateEntry(for habit: Habit, on date: Date) -> DailyHabitEntry {
        if let existingEntry = habit.hasEntry(for: date) {
            return existingEntry
        } else {
            let newEntry = addNewEntry(habit: habit, date: date)
            return newEntry
        }
    }
    
    @MainActor
    func checkAndCreateEntriesForDate(_ date: Date, habits: [Habit]) async {
        for habit in habits {
            if habit.hasEntry(for: date) == nil {
                _ = addNewEntry(habit: habit, date: date)
            }
        }
    }
    
    @discardableResult
    func addNewEntry(habit: Habit, date: Date) -> DailyHabitEntry {
        let dailyHabitEntry = DailyHabitEntry(day: date)
        dailyHabitEntry.habit = habit
        
        var tasks: [DailyTask] = []
        
        for definedTask in habit.definedTasks {
            tasks.append(DailyTask(taskName: definedTask.taskName))
        }
        
        dailyHabitEntry.tasks = tasks
        
        modelContext.insert(dailyHabitEntry)
        try? modelContext.save()
        
        return dailyHabitEntry
    }
    
    func updateDailyHabitEntry(for habit: Habit, on date: Date) {
        if let existingEntry = habit.hasEntry(for: date) {
            // Update existing entry
            existingEntry.tasks = habit.definedTasks.map { DailyTask(taskName: $0.taskName) }
        } else {
            // Create new entry if it doesn't exist
            let newEntry = addNewEntry(habit: habit, date: date)
            newEntry.tasks = habit.definedTasks.map { DailyTask(taskName: $0.taskName) }
        }
        try? modelContext.save()
    }
    
    func updateAllDailyHabitEntries(for habit: Habit) {
        for entry in habit.dailyHabitEntries {
            entry.tasks = habit.definedTasks.map { DailyTask(taskName: $0.taskName) }
        }
        try? modelContext.save()
    }
    
    func syncDefinedTasks(for habit: Habit) {
        for entry in habit.dailyHabitEntries {
            let existingTasks = entry.tasks
            let updatedTasks = habit.definedTasks.map { definition -> DailyTask in
                if let existingTask = existingTasks.first(where: { $0.taskName == definition.taskName }) {
                    existingTask.taskName = definition.taskName
                    return existingTask
                } else {
                    return DailyTask(taskName: definition.taskName)
                }
            }
            entry.tasks = updatedTasks
        }
        try? modelContext.save()
    }
    
    func updateStreaks(for date: Date) {
        let habits = try? modelContext.fetch(FetchDescriptor<Habit>())
        guard let habits = habits else { return }
        
        for habit in habits {
            updateStreakForHabit(habit, onDate: date)
        }
        
        try? modelContext.save()
    }
    
    private func updateStreakForHabit(_ habit: Habit, onDate date: Date) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: date)
        
        // Find the last consecutive completed date
        var currentDate = today
        var consecutiveCompletedDays = 0
        
        while true {
            let entry = getOrCreateEntry(for: habit, on: currentDate)
            let isCompleted = !entry.tasks.contains { !$0.isChecked }
            
            if isCompleted {
                consecutiveCompletedDays += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }
        
        // Update the streak
        habit.currentStreak = consecutiveCompletedDays
        habit.bestStreak = max(habit.bestStreak, habit.currentStreak)
        
        // Update last completed date if the habit was completed today
        let todayEntry = getOrCreateEntry(for: habit, on: today)
        if !todayEntry.tasks.contains(where: { !$0.isChecked }) {
            habit.lastCompletedDate = today
        }
    }
    
    private func daysBetween(_ date1: Date, and date2: Date) -> Int {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: date1)
        let date2 = calendar.startOfDay(for: date2)
        return calendar.dateComponents([.day], from: date1, to: date2).day ?? 0
    }
    

}

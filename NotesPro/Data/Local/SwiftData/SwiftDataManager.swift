//
//  SwiftDataManager.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 17/07/24.
//

import SwiftData
import SwiftUI

class SwiftDataManager: HabitDataSource, HabitEntryDataSource, TaskDataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
//    @MainActor
//    static let shared = SwiftDataManager()
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.modelContext = ModelContext(modelContainer)
    }
    
    //MARK: - Habit
    func createHabit(_ habit: Habit) {
        modelContext.insert(habit)
        
        let todayEntry = createHabitEntry(habit: habit, date: .now)
        todayEntry.tasks = habit.definedTasks.map { DailyTask(taskName: $0.taskName) }
        
        try? modelContext.save()
    }
    
    func fetchHabits() async -> Result<[Habit], ResponseError> {
        do {
            let habits = try modelContext.fetch(FetchDescriptor<Habit>(sortBy: [SortDescriptor(\Habit.habitName)]))
            await checkAndCreateEntriesForDate(.now, habits: habits)
            
            return .success(habits)
        } catch {
            return .failure(.localStorageError(cause: "Error fetching habits on SwiftDataManager"))
        }
    }
    
    func updateHabit(_ updatedHabitModel: HabitModel) {
        do {
            let habits = try modelContext.fetch(FetchDescriptor<Habit>())
            
            if let habit = habits.first(where: { $0.id == updatedHabitModel.id }) {
                habit.habitName = updatedHabitModel.habitName
                habit.definedTasks = updatedHabitModel.toTasksDefinitions()
                syncDefinedTasks(for: habit)
            }
            
            try? modelContext.save()
        } catch {
            fatalError("Error updating habit \(updatedHabitModel) on SwiftDataManager")
        }
    }
    
    func deleteHabit(with id: UUID) {
        do {
            let habits = try modelContext.fetch(FetchDescriptor<Habit>())
            if let habitt = habits.first(where: { $0.id ==  id} ) {
                modelContext.delete(habitt)
                try modelContext.save()
            }
        } catch {
            fatalError("Error deleting habit on SwiftDataManager")
        }
    }
    
    //MARK: - HabitEntry
    func createHabitEntry(habit: Habit, date: Date) -> DailyHabitEntry {
        do {
            let descriptor = FetchDescriptor<Habit>()
            let habits = try modelContext.fetch(descriptor)
            
            if let habit = habits.first(where: { $0.id == habit.id }) {
                let dailyHabitEntry = DailyHabitEntry(date: date)
                dailyHabitEntry.habit = habit
                dailyHabitEntry.tasks = habit.definedTasks.map({ DailyTask(taskName: $0.taskName) })
                try? modelContext.save()
                
                return dailyHabitEntry
            } else {
                fatalError("Error adding new entry on SwiftDataManager")
            }
        } catch {
            fatalError("Error adding new entry on SwiftDataManager")
        }
    }
    
    func updateHabitEntry(_ updatedHabitEntryID: UUID, with newNote: String) {
        do {
            let habitEntries = try modelContext.fetch(FetchDescriptor<DailyHabitEntry>())
            if let habitEntry = habitEntries.first(where: { $0.id == updatedHabitEntryID }) {
                habitEntry.note = newNote
                try modelContext.save()
            }
        } catch {
            fatalError("Error updateing habit entry on SwiftDataManager")
        }
    }
    
    #warning("CHECKED")
    func updateTask(_ updatedTask: TaskModel, on habitID: UUID, with entryDate: Date) {
        do {
            let habits = try modelContext.fetch(FetchDescriptor<Habit>())
            if let habit = habits.first(where: { $0.id == habitID }) {
                if let habitEntry = habit.dailyHabitEntries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: entryDate) }) {
                    if let task = habitEntry.tasks.first(where: { $0.id == updatedTask.id }) {
                        task.isChecked = updatedTask.isChecked
                        try modelContext.save()
                    }
                }
            }
        } catch {
            fatalError("Error updating task on SwiftDataManager")
        }
    }
    
    func updateHabitEntry(_ updatedHabitEntry: DailyHabitEntry) {
        do {
            let habitEntries = try modelContext.fetch(FetchDescriptor<DailyHabitEntry>())
            if let habitEntry = habitEntries.first(where: { $0.id == updatedHabitEntry.id }) {
                
                habitEntry.tasks = updatedHabitEntry.tasks
                habitEntry.note = updatedHabitEntry.note
            }
        } catch {
            fatalError("Error updateing habit entry on SwiftDataManager")
        }
    }
    
//    func fetchDailyHabitEntries(from date: Date) async -> Result<[DailyHabitEntry], ResponseError> {
//        await MainActor.run {
//            do {
//                let entries = try modelContext.fetch(FetchDescriptor<DailyHabitEntry>(predicate: #Predicate<DailyHabitEntry> { $0.day == date }, 
//                                                                                      sortBy: [SortDescriptor(\.day)]))
//                return .success(entries)
//            } catch {
//                print("Error fetching daily habit entries: \(error.localizedDescription)")
//                return .failure(.localStorageError(cause: "Error fetching daily habit entries: \(error.localizedDescription)"))
//            }
//        }
//    }
    
    @MainActor func fetchHabitEntries(for habit: Habit) -> [DailyHabitEntry] {
        do {
            return try modelContext.container.mainContext.fetch(FetchDescriptor<DailyHabitEntry>(sortBy: [SortDescriptor(\DailyHabitEntry.date)]))
        } catch {
            print("Error fetching habits on SwiftDataManager with error: \(error)")
            return []
        }
    }
    
    #warning("CHECKED")
    func fetchHabitEntry(_ habit: Habit, on date: Date) -> DailyHabitEntry {
        do {
            let habitID = habit.id
            let descriptor = FetchDescriptor<DailyHabitEntry>(predicate: #Predicate { $0.habit?.id == habitID })
            let dailyHabitEntries = try modelContext.fetch(descriptor)
            
            if let existingEntry = dailyHabitEntries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                return existingEntry
            } else {
                let newEntry = createHabitEntry(habit: habit, date: date)
                return newEntry
            }
        } catch {
            fatalError("Error fetching habit entry")
        }
    }
    
    func getOrCreateEntry(for habit: Habit, on date: Date) -> DailyHabitEntry {
        if let existingEntry = habit.hasEntry(for: date) {
            return existingEntry
        } else {
            let newEntry = createHabitEntry(habit: habit, date: date)
            return newEntry
        }
    }
    
    @MainActor
    func checkAndCreateEntriesForDate(_ date: Date, habits: [Habit]) async {
        for habit in habits {
            if habit.hasEntry(for: date) == nil {
                _ = createHabitEntry(habit: habit, date: date)
            }
        }
    }
    
    func updateDailyHabitEntry(for habit: Habit, on date: Date) {
        if let existingEntry = habit.hasEntry(for: date) {
            // Update existing entry
            existingEntry.tasks = habit.definedTasks.map { DailyTask(taskName: $0.taskName) }
        } else {
            // Create new entry if it doesn't exist
            let newEntry = createHabitEntry(habit: habit, date: date)
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
    
    internal func checkTodayHabitEntry() {
        do {
            let habits = try modelContext.fetch(FetchDescriptor<Habit>())
            for habit in habits {
                if habit.hasEntry(for: .now) == nil {
                    let todayEntry = createHabitEntry(habit: habit, date: .now)
                    print(habit.dailyHabitEntries.count)
                }
            }
        } catch {
            fatalError("Error checking today habit entry on SwiftDataManager \(error)")
        }
    }
}

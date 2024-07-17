//
//  HabitViewModel.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 15/07/24.
//

import SwiftUI
import SwiftData

@MainActor
final class HabitViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var selectedHabit: Habit?
    @Published var isAddHabitSheetPresented = false
    @Published var newHabitId: UUID?
    @Published var dailyHabitEntries: [DailyHabitEntry] = []
    @Published var responseError: ResponseError?
    
    let habitDataSource: HabitDataSource
    
    init(habitDataSource: HabitDataSource) {
        self.habitDataSource = habitDataSource
    }
    
    func updateStreaks(for date: Date) {
        if let swiftDataManager = habitDataSource as? SwiftDataManager {
            swiftDataManager.updateStreaks(for: date)
            Task {
                await refreshHabits()
            }
        }
    }
    
    func getOrCreateEntry(for habit: Habit, on date: Date) -> DailyHabitEntry {
        if let swiftDataManager = habitDataSource as? SwiftDataManager {
            return swiftDataManager.getOrCreateEntry(for: habit, on: date)
        } else {
            // Fallback for other data sources, if necessary
            return DailyHabitEntry(day: date)
        }
    }
    
    func checkAndCreateEntriesForDate(_ date: Date) async {
        if let swiftDataManager = habitDataSource as? SwiftDataManager {
            await swiftDataManager.checkAndCreateEntriesForDate(date, habits: self.habits)
            await getHabits()
            await getDailyHabitEntries(from: date)
        }
    }
    
    func getHabits() async {
        let habitsResult = await habitDataSource.fetchHabits()
        switch habitsResult {
        case .success(let habits):
            self.habits = habits
        case .failure(let responseError):
            self.responseError = responseError
        }
    }
    
    func getDailyHabitEntries(from date: Date) async {
        let dailyHabitEntryResult = await habitDataSource.fetchDailyHabitEntries(from: date)
        switch dailyHabitEntryResult {
        case .success(let dailyHabitEntries):
            self.dailyHabitEntries = dailyHabitEntries
        case .failure(let responseError):
            self.responseError = responseError
        }
    }
    
    func addHabit(modelContext: ModelContext) -> Habit {
        let newHabit = Habit(title: "", description: "")
        modelContext.insert(newHabit)
        try? SwiftDataManager.shared.modelContainer.mainContext.save()
        newHabitId = newHabit.id
        return newHabit
    }
    
    func deleteHabit(_ habit: Habit, modelContext: ModelContext) {
        SwiftDataManager.shared.modelContainer.mainContext.delete(habit)
        saveHabit(modelContext: modelContext)
        if selectedHabit?.id == habit.id {
            selectedHabit = nil
        }
        Task {
            await refreshHabits()
        }
    }
    
    func saveHabit(modelContext: ModelContext) {
        try? SwiftDataManager.shared.modelContainer.mainContext.save()
    }
    
    func refreshHabits() async {
        await getHabits()
    }
    
    func updateDailyHabitEntry(for habit: Habit, on date: Date) {
        if let swiftDataManager = habitDataSource as? SwiftDataManager {
            swiftDataManager.updateDailyHabitEntry(for: habit, on: date)
        }
    }
    
    func updateAllDailyHabitEntries(for habit: Habit) {
        if let swiftDataManager = habitDataSource as? SwiftDataManager {
            swiftDataManager.updateAllDailyHabitEntries(for: habit)
        }
    }
    
    func updateHabit(_ habit: Habit, modelContext: ModelContext) {
        do {
            try modelContext.save()
            // Sync defined tasks after updating the habit
            if let swiftDataManager = habitDataSource as? SwiftDataManager {
                swiftDataManager.syncDefinedTasks(for: habit)
            }
        } catch {
            print("Error updating habit: \(error.localizedDescription)")
        }
    }
}

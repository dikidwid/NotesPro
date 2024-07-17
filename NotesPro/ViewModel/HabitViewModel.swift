//
//  HabitViewModel.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 15/07/24.
//

import SwiftUI
import SwiftData

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
    
    func getOrCreateEntry(for habit: Habit, on date: Date) -> DailyHabitEntry {
        if let swiftDataManager = habitDataSource as? SwiftDataManager {
            return swiftDataManager.getOrCreateEntry(for: habit, on: date)
        } else {
            // Fallback for other data sources, if necessary
            return DailyHabitEntry(day: date)
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
        try? modelContext.save()
        newHabitId = newHabit.id
        return newHabit
    }
    
    func deleteHabit(_ habit: Habit, modelContext: ModelContext) {
        modelContext.delete(habit)
        saveHabit(modelContext: modelContext)
    }
    
    func saveHabit(modelContext: ModelContext){
        try? modelContext.save()
    }
}

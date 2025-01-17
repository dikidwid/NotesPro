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
        
    @Published var completedDays: Set<Date> = []
    @Published var allHabitsCompletedDays: Set<Date> = []
    @Published var individualHabitCompletedDays: Set<Date> = []
    @Published var lastUpdateTimestamp: Date = Date()

    let habitDataSource: HabitDataSource
    
    private var updateTimer: Timer?
    
    init(habitDataSource: HabitDataSource) {
        self.habitDataSource = habitDataSource
//        startContinuousUpdates()
    }
    
    
    deinit {
        Task {
            await stopContinuousUpdates()
        }
    }
    
    func updateAllHabitsCompletedDays() {
        var newCompletedDays = Set<Date>()
        let calendar = Calendar.current
        
        for date in habits.flatMap({ $0.dailyHabitEntries.map({ $0.day }) }) {
            let startOfDay = calendar.startOfDay(for: date)
            if isAllHabitsCompletedForDay(startOfDay) {
                newCompletedDays.insert(startOfDay)
            }
        }
        
        self.allHabitsCompletedDays = newCompletedDays
    }
    
    func updateIndividualHabitCompletedDays(for habit: Habit) {
        var newCompletedDays = Set<Date>()
        let calendar = Calendar.current
        
        for entry in habit.dailyHabitEntries {
            let startOfDay = calendar.startOfDay(for: entry.day)
            if entry.tasks.allSatisfy({ $0.isChecked }) {
                newCompletedDays.insert(startOfDay)
            }
        }
        
        self.individualHabitCompletedDays = newCompletedDays
    }

    func updateCompletedDays() {
        var newCompletedDays = Set<Date>()
        let calendar = Calendar.current
        
        for habit in habits {
            for entry in habit.dailyHabitEntries {
                let startOfDay = calendar.startOfDay(for: entry.day)
                if isAllHabitsCompletedForDay(startOfDay) {
                    newCompletedDays.insert(startOfDay)
                }
            }
        }
        
        self.completedDays = newCompletedDays
    }
    
    func isAllHabitsCompletedForDay(_ date: Date) -> Bool {
        let startOfDay = Calendar.current.startOfDay(for: date)
        return habits.allSatisfy { habit in
            guard let entry = habit.hasEntry(for: startOfDay) else { return false }
            return entry.tasks.allSatisfy { $0.isChecked }
        }
    }
    
    private func startContinuousUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                await self.updateAllData()
            }
        }
    }
    
    private func stopContinuousUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    @MainActor
    private func updateAllData() async {
        await getHabits()
        updateStreaks(for: Date())
        updateAllHabitsCompletedDays()
        if let selectedHabit = selectedHabit {
            updateIndividualHabitCompletedDays(for: selectedHabit)
        }
        lastUpdateTimestamp = Date()
    }

    
    func updateStreaks(for date: Date) {
        if let swiftDataManager = habitDataSource as? SwiftDataManager {
            swiftDataManager.updateStreaks(for: date)
            Task {
                await refreshHabits()
                updateCompletedDays()
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
        updateCompletedDays()
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
    
    func toggleTask(_ task: DailyTask) {
        task.isChecked.toggle()
        task.checkedDate = task.isChecked ? Date() : nil
        updateAllHabitsCompletedDays()
        if let habit = task.dailyHabitEntry?.habit {
            updateIndividualHabitCompletedDays(for: habit)
        }
        updateStreaks(for: Date())
        lastUpdateTimestamp = Date()
        print("Changed!")
    }
    
}

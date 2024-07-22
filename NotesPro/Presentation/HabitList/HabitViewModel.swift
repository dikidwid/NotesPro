//
//  HabitViewModel.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 15/07/24.
//

import SwiftUI
import SwiftData

protocol HabitViewModelProtocol: ObservableObject {
    var habits: [HabitModel] { get set }
    var selectedHabit: HabitModel? { get set }
    var isShowAddNewHabitView: Bool { get set }
    var getHabitsUseCase: GetHabitsUseCase { get }
    func fetchHabits() async
}

class HabitViewModelMock: HabitViewModelProtocol {
    @Published var habits: [HabitModel] = []
    @Published var selectedHabit: HabitModel?
    @Published var isShowAddNewHabitView: Bool = false
    let getHabitsUseCase: GetHabitsUseCase
    
    init(getHabitsUseCase: GetHabitsUseCase) {
        self.getHabitsUseCase = getHabitsUseCase
    }
    
    func fetchHabits() {
        Task {
            let result = await getHabitsUseCase.execute()
            switch result {
            case .success(let habits):
                self.habits = habits
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

@MainActor
final class HabitViewModel: ObservableObject {
    @Published var habits: [HabitModel] = []
    @Published var selectedHabit: Habit?
    @Published var isAddHabitSheetPresented = false
    @Published var newHabitId: UUID?
    
    @Published var dailyHabitEntries: [DailyHabitEntry] = []
    @Published var responseError: ResponseError?
        
    @Published var completedDays: Set<Date> = []
    @Published var allHabitsCompletedDays: Set<Date> = []
    @Published var individualHabitCompletedDays: Set<Date> = []
    @Published var lastUpdateTimestamp: Date = Date()

    let getHabitsUseCase: GetHabitsUseCase
    
    private var updateTimer: Timer?
    
    @MainActor
    init(getHabitsUseCase: GetHabitsUseCase) {
        self.getHabitsUseCase = getHabitsUseCase
    }
    
//    func updateAllHabitsCompletedDays() {
//        var newCompletedDays = Set<Date>()
//        let calendar = Calendar.current
//        
//        for date in habits.flatMap({ $0.dailyHabitEntries.map({ $0.day }) }) {
//            let startOfDay = calendar.startOfDay(for: date)
//            if isAllHabitsCompletedForDay(startOfDay) {
//                newCompletedDays.insert(startOfDay)
//            }
//        }
//        
//        self.allHabitsCompletedDays = newCompletedDays
//    }
    
    func updateIndividualHabitCompletedDays(for habit: Habit) {
        var newCompletedDays = Set<Date>()
        let calendar = Calendar.current
        
        for entry in habit.dailyHabitEntries {
            let startOfDay = calendar.startOfDay(for: entry.day)
            if entry.tasks.allSatisfy({ $0.isChecked }) {
                newCompletedDays.insert(startOfDay)
            }
        }
        
//        self.individualHabitCompletedDays = newCompletedDays
    }

//    func updateCompletedDays() {
//        var newCompletedDays = Set<Date>()
//        let calendar = Calendar.current
//        
//        for habit in habits {
//            for entry in habit.dailyHabitEntries {
//                let startOfDay = calendar.startOfDay(for: entry.day)
//                if isAllHabitsCompletedForDay(startOfDay) {
//                    newCompletedDays.insert(startOfDay)
//                }
//            }
//        }
//        
//        self.completedDays = newCompletedDays
//    }
    
//    func isAllHabitsCompletedForDay(_ date: Date) -> Bool {
//        let startOfDay = Calendar.current.startOfDay(for: date)
//        return habits.allSatisfy { habit in
//            guard let entry = habit.hasEntry(for: startOfDay) else { return false }
//            return entry.tasks.allSatisfy { $0.isChecked }
//        }
//    }
    
    private func startContinuousUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                await self.updateAllData()
            }
        }
    }

    @MainActor
    private func updateAllData() async {
        await getHabits()
//        updateStreaks(for: Date())
//        updateAllHabitsCompletedDays()
        if let selectedHabit = selectedHabit {
            updateIndividualHabitCompletedDays(for: selectedHabit)
        }
//        lastUpdateTimestamp = Date()
    }

    
//    func updateStreaks(for date: Date) {
//        if let swiftDataManager = habitDataSource as? SwiftDataManager {
//            swiftDataManager.updateStreaks(for: date)
//            Task {
//                await refreshHabits()
//                updateCompletedDays()
//            }
//        }
//    }
// 
//    func getOrCreateEntry(for habit: Habit, on date: Date) -> DailyHabitEntry {
//        if let swiftDataManager = habitDataSource as? SwiftDataManager {
//            return swiftDataManager.getOrCreateEntry(for: habit, on: date)
//        } else {
//            // Fallback for other data sources, if necessary
//            return DailyHabitEntry(day: date)
//        }
//    }
//    
//    func checkAndCreateEntriesForDate(_ date: Date) async {
//        if let swiftDataManager = habitDataSource as? SwiftDataManager {
//            await swiftDataManager.checkAndCreateEntriesForDate(date, habits: self.habits)
//            await getHabits()
//            await getDailyHabitEntries(from: date)
//        }
//    }
//    
    func getHabits() async {
        let habitsResult = await getHabitsUseCase.execute()
        switch habitsResult {
        case .success(let habits):
            self.habits = habits
        case .failure(let responseError):
            print(responseError)
//            self.responseError = responseError
        }
    }
//    
//    func getDailyHabitEntries(from date: Date) async {
//        let dailyHabitEntryResult = await habitDataSource.fetchDailyHabitEntries(from: date)
//        switch dailyHabitEntryResult {
//        case .success(let dailyHabitEntries):
//            self.dailyHabitEntries = dailyHabitEntries
//        case .failure(let responseError):
//            self.responseError = responseError
//        }
//    }
    
    func addHabit(modelContext: ModelContext) -> Habit {
        let newHabit = Habit(title: "", description: "")
        modelContext.insert(newHabit)
        try? SwiftDataManager.shared.modelContainer.mainContext.save()
        newHabitId = newHabit.id
        return newHabit
    }
    
    @MainActor
    func deleteHabit(_ habit: Habit, modelContext: ModelContext) {
//        do {
            // First, delete all related DailyHabitEntries
            for entry in habit.dailyHabitEntries {
                SwiftDataManager.shared.modelContainer.mainContext.delete(entry)
            }
            
            // Then, delete all related DailyTaskDefinitions
            for task in habit.definedTasks {
                SwiftDataManager.shared.modelContainer.mainContext.delete(task)
            }
            
            // Finally, delete the habit itself
            SwiftDataManager.shared.modelContainer.mainContext.delete(habit)
            
            // Save the changes
            
//            try modelContext.save()
            
//            // Update UI on the main thread
//            DispatchQueue.main.async {
//                if self.selectedHabit?.id == habit.id {
//                    self.selectedHabit = nil
//                }
//                Task {
//                    await self.refreshHabits()
//                }
//            }
            
//        } catch {
//            print("Error deleting habit: \(error.localizedDescription)")
//            // Handle the error (e.g., show an alert to the user)
//        }
    }
    
    func saveHabit(modelContext: ModelContext) {
        try? SwiftDataManager.shared.modelContainer.mainContext.save()
    }
    
//    func refreshHabits() async {
//        await getHabits()
//        updateCompletedDays()
//    }
    
//    func updateDailyHabitEntry(for habit: Habit, on date: Date) {
//        if let swiftDataManager = habitDataSource as? SwiftDataManager {
//            swiftDataManager.updateDailyHabitEntry(for: habit, on: date)
//        }
//    }
//    
//    func updateAllDailyHabitEntries(for habit: Habit) {
//        if let swiftDataManager = habitDataSource as? SwiftDataManager {
//            swiftDataManager.updateAllDailyHabitEntries(for: habit)
//        }
//    }
//    
//    func updateHabit(_ habit: Habit, modelContext: ModelContext) {
//        do {
//            try modelContext.save()
//            // Sync defined tasks after updating the habit
//            if let swiftDataManager = habitDataSource as? SwiftDataManager {
//                swiftDataManager.syncDefinedTasks(for: habit)
//            }
//        } catch {
//            print("Error updating habit: \(error.localizedDescription)")
//        }
//    }
//    
//    func toggleTask(_ task: DailyTask) {
//        task.isChecked.toggle()
//        task.checkedDate = task.isChecked ? Date() : nil
//        updateAllHabitsCompletedDays()
//        if let habit = task.dailyHabitEntry?.habit {
//            updateIndividualHabitCompletedDays(for: habit)
//        }
//        updateStreaks(for: Date())
//        lastUpdateTimestamp = Date()
//        print("Changed!")
//    }
}


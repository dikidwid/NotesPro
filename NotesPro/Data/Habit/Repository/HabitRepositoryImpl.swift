//
//  HabitRepositoryImpl.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 19/07/24.
//

import Foundation
import EventKit

//struct HabitRepositoryImpl: HabitRepository {
//    let dataSource: HabitDataSource
//    
//    func getHabits() async -> Result<[HabitModel], ResponseError> {
//        let result = await dataSource.fetchHabits()
//        switch result {
//        case .success(let habitsResponse):
//            var habitsModel: [HabitModel] = []
//            
//            for habit in habitsResponse {
//                #warning("Ask to peoples, should we map the domain model in repo or map from data source")
//                let habitModel = habit.toHabitModel()
//                habitsModel.append(habitModel)
//            }
//            
//            return .success(habitsModel)
//        case .failure(let responseError):
//            return .failure(.localStorageError(cause: responseError.errorDescription ?? "Undefined Error"))
//        }
//    }
//    
//    func getHabit(_ habit: HabitModel) async -> Result<HabitModel, ResponseError> {
//        
//    }
//    
//    func createHabit(_ habit: HabitModel) {
//
//    }
//    
//    func getDailyHabitEntries(for habit: HabitModel) -> [DailyHabitEntryModel] {
//        
//    }
//
//}

class HabitRepositoryMock: HabitRepository {
    private let eventStore = EKEventStore()
    
    static var shared = HabitRepositoryMock()
    private init () {
        habits = DummyData.habitsDummy
    }
    
    var habits: [HabitModel]
    
    func getHabits() async -> Result<[HabitModel], ResponseError> {
        return .success(habits)
    }
    
    func getHabit(_ habit: HabitModel) async -> Result<HabitModel, ResponseError> {
        return .success(habit)
    }
    
//    func createHabit(_ habit: HabitModel) {
//        habits.append(habit)
//    }
    
    func createHabit(_ habit: HabitModel) async -> Result<HabitModel, ResponseError> {
        habits.append(habit)
        
        if habit.syncToCalendar {
            let syncResult = await syncHabitToCalendar(habit)
            switch syncResult {
            case .success:
                return .success(habit)
            case .failure(let error):
                return .failure(error)
            }
        }
        
        return .success(habit)
    }
    
    func syncHabitToCalendar(_ habit: HabitModel) async -> Result<Void, ResponseError> {
        do {
            try await requestCalendarAccess()
            try await addHabitToCalendar(habit)
            return .success(())
        } catch {
            return .failure(.localStorageError(cause: "Error sync habit"))
        }
    }
    
    private func requestCalendarAccess() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            eventStore.requestFullAccessToEvents { granted, error in
                if granted {
                    continuation.resume()
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NSError(domain: "CalendarAccess", code: 0, userInfo: [NSLocalizedDescriptionKey: "Access denied"]))
                }
            }
        }
    }
    
    private func addHabitToCalendar(_ habit: HabitModel) async throws {
        let event = EKEvent(eventStore: eventStore)
        event.title = habit.habitName
        event.notes = "Daily habit"
        event.startDate = Date()
        event.endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        try eventStore.save(event, span: .futureEvents)
    }
    
    func getDailyHabitEntries(for habit: HabitModel) -> [DailyHabitEntryModel] {
        return habits[0].dailyHabitEntries
    }
    
//    func upateEntry(_ entry: DailyHabitEntryModel) {
//        if let habitIndex = habits.firstIndex(where: { $0 == habit }) {
//            if let entryIndex = habits[habitIndex].dailyHabitEntries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
//                habits[habitIndex].dailyHabitEntries[entryIndex] = entry
//            }
//        }
//    }
    
    func updateTask(_ task: TaskModel) {
        for indexHabit in habits.indices {
            for indexDailyHabitEntry in habits[indexHabit].dailyHabitEntries.indices {
                for indexTask in habits[indexHabit].dailyHabitEntries[indexDailyHabitEntry].tasks.indices {
                    if habits[indexHabit].dailyHabitEntries[indexDailyHabitEntry].tasks[indexTask].id == task.id {
                        let foundedTask = habits[indexHabit].dailyHabitEntries[indexDailyHabitEntry].tasks[indexTask]
                        if foundedTask.isChecked == true {
                            habits[indexHabit].dailyHabitEntries[indexDailyHabitEntry].tasks[indexTask].isChecked = false
                            
                            print("foundedTask \(foundedTask.isChecked)")
                        } else {
                            habits[indexHabit].dailyHabitEntries[indexDailyHabitEntry].tasks[indexTask].isChecked = true
                            
                            print("foundedTask \(foundedTask.isChecked)")
                        }
                    }
                }
            }
        }
    }
}

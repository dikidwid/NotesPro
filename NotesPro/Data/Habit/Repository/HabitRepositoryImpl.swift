//
//  HabitRepositoryImpl.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 19/07/24.
//

import Foundation

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
    
    func createHabit(_ habit: HabitModel) {
        habits.append(habit)
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

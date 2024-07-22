//
//  HabitRepositoryImpl.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 19/07/24.
//

import Foundation

struct HabitRepositoryImpl: HabitRepository {
    let dataSource: HabitDataSource

    func getHabit(_ habit: HabitModel) async -> Result<HabitModel, ResponseError> {
        .success(DummyData.habitsDummy[0])
    }
    
    func getHabits() async -> Result<[HabitModel], ResponseError> {
        let result = await dataSource.fetchHabits()
        switch result {
        case .success(let habitsResponse):
            var habitsModel: [HabitModel] = []
            
            for habit in habitsResponse {
                #warning("Ask to peoples, should we map the domain model in repo or map from data source")
                let habitModel = habit.toHabitModel()
                habitsModel.append(habitModel)
            }
            
            return .success(habitsModel)
        case .failure(let responseError):
            return .failure(.localStorageError(cause: responseError.errorDescription ?? "Undefined Error"))
        }
    }
    
    func createHabit(_ habit: HabitModel) {
        
    }
}

class HabitRepositoryMock: HabitRepository {
    var habits: [HabitModel]
    let habit: HabitModel
    
    init(habits: [HabitModel], habit: HabitModel) {
        self.habits = habits
        self.habit = habit
    }
    
    func getHabits() async -> Result<[HabitModel], ResponseError> {
        return .success(habits)
    }
    
    func getHabit(_ habit: HabitModel) async -> Result<HabitModel, ResponseError> {
        return .success(self.habit)
    }
    
    func createHabit(_ habit: HabitModel) {
        habits.append(habit)
        print(habit.dailyHabitEntries)
    }
    
}

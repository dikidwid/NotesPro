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
    
    @Published var dailyHabitEntries: [DailyHabitEntry] = []
    
    @Published var responseError: ResponseError?
    
    let habitDataSource: HabitDataSource
    
    init(habitDataSource: HabitDataSource) {
        self.habitDataSource = habitDataSource
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
}

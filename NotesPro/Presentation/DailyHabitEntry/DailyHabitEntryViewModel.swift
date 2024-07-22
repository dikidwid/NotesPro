//
//  DailyHabitEntryViewModel.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 21/07/24.
//

import Foundation

final class DailyHabitEntryViewModel {
    @Published var dailyHabitEntries: [DailyHabitEntry] = []
    @Published var lastUpdateTimestamp: Date = Date()
    @Published var completedDays: Set<Date> = []
    @Published var allHabitsCompletedDays: Set<Date> = []
    
    // let dailyHabitEntry = GetDailyHabitEntryUseCase(for (date))
    // let dailyHabitEntries = GetDailyHabitEntriesUseCase()
}

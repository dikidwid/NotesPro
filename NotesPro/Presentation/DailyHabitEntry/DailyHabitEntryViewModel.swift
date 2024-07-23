//
//  DailyHabitEntryViewModel.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 21/07/24.
//

import Foundation

final class DailyHabitEntryViewModel: ObservableObject {
    @Published var dailyHabitEntries: [DailyHabitEntryModel] = []
    @Published var selectedEntry: DailyHabitEntryModel?
    @Published var temproaryNote: String = ""
    @Published var isShowDetalEntries: Bool = false
//    @Published var lastUpdateTimestamp: Date = Date()
//    @Published var completedDays: Set<Date> = []
//    @Published var allHabitsCompletedDays: Set<Date> = []
    
//     let dailyHabitEntry = GetDailyHabitEntryUseCase(for (date))
//     let dailyHabitEntries = GetDailyHabitEntriesUseCase()
    
    let getDailyHabitEntriesUseCase: GetDailyHabitEntriesUseCase
    
    init(habit: HabitModel, getDailyHabitEntriesUseCase: GetDailyHabitEntriesUseCase) {
        self.getDailyHabitEntriesUseCase = getDailyHabitEntriesUseCase
        self.dailyHabitEntries = getDailyHabitEntriesUseCase.execute(for: habit)
    }
}

//
//  GetDailyHabitEntriesUseCase.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 23/07/24.
//

import Foundation

struct GetDailyHabitEntriesUseCase {
    let repository: HabitRepository
    
    func execute(for habit: HabitModel) -> [DailyHabitEntryModel] {
        repository.getDailyHabitEntries(for: habit)
    }
}

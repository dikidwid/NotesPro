//
//  GetHabitEntryUseCase.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 25/07/24.
//

import Foundation

struct GetHabitEntryUseCase {
    let repository: HabitRepository
    
    init(repository: HabitRepository) {
        self.repository = repository
    }
    
    func execute(for habit: HabitModel, on date: Date) -> DailyHabitEntryModel {
        repository.getHabitEntry(habit, on: date)
    }
}

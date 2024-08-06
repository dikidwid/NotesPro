//
//  GetHabitEntryUseCase.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 25/07/24.
//

import Foundation

struct GetHabitEntryUseCase {
    let repository: HabitEntryRepository
    
    init(repository: HabitEntryRepository) {
        self.repository = repository
    }
    
    func execute(for habit: HabitModel, on date: Date) -> HabitEntryModel {
        repository.getHabitEntry(habit, on: date)
    }
}

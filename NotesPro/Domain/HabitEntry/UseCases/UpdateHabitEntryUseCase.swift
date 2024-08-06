//
//  UpdateHabitEntryUseCase.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 25/07/24.
//

import Foundation

struct UpdateHabitEntryUseCase {
    let repository: HabitEntryRepository
    
    func execute(habitEntry: HabitEntryModel) {
        repository.updateHabitEntry(habitEntry)
    }
}

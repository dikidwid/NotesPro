//
//  UpdateHabitUseCase.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 19/07/24.
//

import Foundation

struct UpdateHabitUseCase {
    let repository: HabitRepository
    
    func execute(for habit: HabitModel) {
        repository.updateHabit(habit)
    }
}

//
//  AddHabitUseCase.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 19/07/24.
//

import Foundation

struct AddHabitUseCase {
    let repository: HabitRepository
    
    func execute(habit: HabitModel) async {
        await repository.createHabit(habit)
    }
}

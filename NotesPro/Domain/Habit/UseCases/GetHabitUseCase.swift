//
//  GetHabitUseCase.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 19/07/24.
//

import Foundation

struct GetHabitUseCase {
    let repository: HabitRepository
    
    func execute(for habit: HabitModel) async -> Result<HabitModel, ResponseError> {
        await repository.getHabit(habit)
    }
}

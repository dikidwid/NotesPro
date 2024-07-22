//
//  GetHabitsUseCase.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 21/07/24.
//

import Foundation

struct GetHabitsUseCase {
    let repository: HabitRepository
    
    func execute() async -> Result<[HabitModel], ResponseError> {
        await repository.getHabits()
    }
}

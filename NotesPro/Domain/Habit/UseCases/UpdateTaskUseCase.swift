//
//  UpdateTaskUseCase.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 23/07/24.
//

import Foundation

struct UpdateTaskUseCase {
    let repository: HabitRepository
    
    func execute(for task: TaskModel) {
        repository.updateTask(task)
    }
}

//
//  DeleteTaskUseCase.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 30/07/24.
//

import Foundation

struct DeleteTaskUseCase {
    let repository: HabitRepository
    
    func execute(_ task: TaskModel) {
        repository.deleteTask(task)
    }
}

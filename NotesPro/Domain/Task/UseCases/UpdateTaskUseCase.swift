//
//  UpdateTaskUseCase.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 23/07/24.
//

import Foundation

struct UpdateTaskUseCase {
    let repository: TaskRepository
    
    func execute(for updatedTask: TaskModel, habitID: UUID, on entryDate: Date) {
        repository.updateTask(updatedTask, on: habitID, with: entryDate)
    }
}

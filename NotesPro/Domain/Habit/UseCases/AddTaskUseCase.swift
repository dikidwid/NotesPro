//
//  AddTaskUseCase.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 30/07/24.
//

import Foundation

struct AddTaskUseCase {
    let repository: HabitRepository
    
    func execute(_ task: TaskModel) {
        repository.addTask(task)
    }
}

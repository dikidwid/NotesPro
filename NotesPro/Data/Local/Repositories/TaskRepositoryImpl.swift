//
//  TaskRepositoryImpl.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 06/08/24.
//

import Foundation

struct TaskRepositoryImpl: TaskRepository {
    let dataSource: TaskDataSource
    
    func updateTask(_ updatedTask: TaskModel, on habitID: UUID, with entryDate: Date) {
        dataSource.updateTask(updatedTask, on: habitID, with: entryDate)
    }
}

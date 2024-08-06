//
//  TaskDataSource.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 06/08/24.
//

import Foundation

protocol TaskDataSource {
    func updateTask(_ updatedTask: TaskModel, on habitID: UUID, with entryDate: Date)
}

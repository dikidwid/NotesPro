//
//  DailyHabitEntryModel.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 20/07/24.
//

import Foundation

struct HabitEntryModel: Identifiable, Hashable {
    let id: UUID
    let date: Date
    var note: String
    var tasks: [TaskModel]
    
    init(
        id: UUID = UUID(),
        date: Date,
        note: String,
        tasks: [TaskModel] = []
    ) {
        self.id = id
        self.date = date
        self.note = note
        self.tasks = tasks
    }
}


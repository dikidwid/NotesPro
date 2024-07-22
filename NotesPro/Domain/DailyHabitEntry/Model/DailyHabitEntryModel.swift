//
//  DailyHabitEntryModel.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 20/07/24.
//

import Foundation

struct DailyHabitEntryModel {
    let id: UUID
    let date: Date
    var note: String
//    let habit: HabitModel?
    var tasks: [TaskModel]
    
    init(
        id: UUID = UUID(),
        date: Date,
        note: String,
//        habit: HabitModel?,
        tasks: [TaskModel] = []
    ) {
        self.id = id
        self.date = date
        self.note = note
//        self.habit = habit
        self.tasks = tasks
    }
}

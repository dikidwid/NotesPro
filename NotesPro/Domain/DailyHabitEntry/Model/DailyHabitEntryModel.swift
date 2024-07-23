//
//  DailyHabitEntryModel.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 20/07/24.
//

import Foundation

struct DailyHabitEntryModel: Identifiable, Hashable {
    let id: UUID
    let date: Date
    var note: String
    let habit: HabitModel?
    var tasks: [TaskModel]
    
    init(
        id: UUID = UUID(),
        date: Date,
        note: String,
        habit: HabitModel? = nil,
        tasks: [TaskModel] = []
    ) {
        self.id = id
        self.date = date
        self.note = note
        self.habit = habit
        self.tasks = tasks
    }
}

extension DailyHabitEntryModel {
    
}


//
//  DailyTask.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import Foundation
import SwiftData

@Model
final class DailyTask {
    var id: UUID
    var taskName: String
    var isChecked: Bool
    var createdDate: Date
    var checkedDate: Date?
    
    @Relationship var note: Note?
    
    init(taskName: String) {
        self.id = UUID()
        self.taskName = taskName
        self.isChecked = false
        self.createdDate = Date()
    }
}

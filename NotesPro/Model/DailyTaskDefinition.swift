//
//  DailyTaskDefinition.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import Foundation
import SwiftData

@Model
final class DailyTaskDefinition {
    var id: UUID
    var taskName: String
    var createdDate: Date
    
    @Relationship var habit: Habit?
    
    init(taskName: String) {
        self.id = UUID()
        self.taskName = taskName
        self.createdDate = Date()
    }
}

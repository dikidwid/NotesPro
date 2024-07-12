//
//  Habit.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import Foundation
import SwiftData

@Model
final class Habit: Identifiable {
    var id: UUID
    var title: String
    var desc: String
    var createdDate: Date
    
    @Relationship(deleteRule: .cascade) var definedTasks: [DailyTaskDefinition] = []
    
    init(title: String, description: String) {
        self.id = UUID()
        self.title = title
        self.desc = description
        self.createdDate = Date()
    }
}

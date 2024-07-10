//
//  Habit.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var title: String
    var desc: String
    var createdDate: Date
    
    @Relationship var goal: Goal?
    @Relationship(deleteRule: .cascade) var tasks: [DailyTaskDefinition] = []
    @Relationship(deleteRule: .cascade) var notes: [Note] = []
    
    init(title: String, description: String) {
        self.id = UUID()
        self.title = title
        self.desc = description
        self.createdDate = Date()
    }
}

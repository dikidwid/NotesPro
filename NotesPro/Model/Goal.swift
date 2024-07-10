//
//  Goal.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//
import Foundation
import SwiftData

@Model
final class Goal {
    var id: UUID
    var title: String
    var desc: String
    var createdDate: Date
    var deadlineDate: Date
    
    @Relationship(deleteRule: .cascade) var habits: [Habit] = []
    
    init(title: String, description: String, deadlineDate: Date) {
        self.id = UUID()
        self.title = title
        self.desc = description
        self.createdDate = Date()
        self.deadlineDate = deadlineDate
    }
}

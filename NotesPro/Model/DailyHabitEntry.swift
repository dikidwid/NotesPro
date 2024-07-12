//
//  DailyHabitEntry.swift
//  NotesPro
//
//  Created by Arya Adyatma on 12/07/24.
//


import Foundation
import SwiftData

@Model
final class DailyHabitEntry: Identifiable {
    var id: UUID
    var day: Date
    
    var userFeeling: String = ""
    var userDescription: String = ""
    
    @Relationship
    var habit: Habit?
    
    @Relationship
    var tasks: [DailyTask] = []
    
    init(id: UUID = UUID(), day: Date) {
        self.id = id
        self.day = day
        self.userFeeling = ""
        self.userDescription = ""
    }
}

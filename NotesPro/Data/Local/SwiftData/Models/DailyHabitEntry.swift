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
    // Daily journal/note entry for a habit, changing every day
    // This class includes DailyTasks that also change every day
    
    var id: UUID
    var habit: Habit?
    var date: Date
    var note: String
    
    @Relationship(inverse: \DailyTask.habitEntry)
    var tasks: [DailyTask] = []
    
    init(id: UUID = UUID(), habit: Habit? = nil, date: Date, note: String = "", tasks: [DailyTask] = []) {
        self.id = id
        self.habit = habit
        self.date = date
        self.note = note
        self.tasks = tasks
    }
}


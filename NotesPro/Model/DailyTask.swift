//
//  DailyTask.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import Foundation
import SwiftData

@Model
final class DailyTask: Identifiable {
    // Merupakan task harian dari sebuah habit. Objek ini berbeda setiap harinya. Nama task mengikuti DailyTaskDefinition yang merupakan blueprint dari tasks yang diberikan pada sebuah habit.
    
    var id: UUID
    var taskName: String
    var isChecked: Bool
    var createdDate: Date
    var checkedDate: Date?
    var reminderTime: Date?
    
    @Relationship var dailyHabitEntry: DailyHabitEntry?
    @Relationship var definition: DailyTaskDefinition?
    
    init(taskName: String) {
        self.id = UUID()
        self.taskName = taskName
        self.isChecked = false
        self.createdDate = Date()
    }
}

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
    var id: UUID
//    var habit: Habit?
    var taskDefinition: DailyTaskDefinition?
    var habitEntry: DailyHabitEntry?
    var taskName: String
    var isChecked: Bool
    var checkedDate: Date?
    
    init(id: UUID = UUID(), /*habit: Habit? = nil, habitEntry: DailyHabitEntry? = nil,*/ taskName: String, isChecked: Bool = false) {
        self.id = id
//        self.habit = habit
        self.habitEntry = nil
        self.taskName = taskName
        self.isChecked = isChecked
    }
}

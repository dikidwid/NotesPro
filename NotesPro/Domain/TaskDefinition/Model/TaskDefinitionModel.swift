//
//  TaskDefinition.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 21/07/24.
//

import Foundation

struct TaskDefinitionModel: Identifiable, Hashable {
    let id: UUID
    var taskName: String
//    let habit: HabitModel
//    let tasks: [TaskModel]
    var isReminderEnabled: Bool
    var reminderDate: Date
    
    let isSundayReminderOn: Bool
    let isMondayReminderOn: Bool
    let isTuesdayReminderOn: Bool
    let isWednesdayReminderOn: Bool
    let isThursdayReminderOn: Bool
    let isFridayReminderOn: Bool
    let isSaturdayRemidnerOn: Bool
    
    init(
        id: UUID = UUID(),
        taskName: String, /*habit: HabitModel,*/ /*tasks: [TaskModel],*/
        isReminderEnabled: Bool = false,
        reminderDate: Date = Date(),
        isSundayReminderOn: Bool = false,
        isMondayReminderOn: Bool = false,
        isTuesdayReminderOn: Bool = false,
        isWednesdayReminderOn: Bool = false,
        isThursdayReminderOn: Bool = false,
        isFridayReminderOn: Bool = false,
        isSaturdayRemidnerOn: Bool = false
    ) {
        self.id = id
        self.taskName = taskName
//        self.habit = habit
//        self.tasks = tasks
        self.isReminderEnabled = isReminderEnabled
        self.reminderDate = reminderDate
        self.isSundayReminderOn = isSundayReminderOn
        self.isMondayReminderOn = isMondayReminderOn
        self.isTuesdayReminderOn = isTuesdayReminderOn
        self.isWednesdayReminderOn = isWednesdayReminderOn
        self.isThursdayReminderOn = isThursdayReminderOn
        self.isFridayReminderOn = isFridayReminderOn
        self.isSaturdayRemidnerOn = isSaturdayRemidnerOn
    }
}

extension TaskDefinitionModel {
    func getReminderDescription() -> String {
        if !isReminderEnabled {
            return ""
        }
        
        let days = [
            (day: "Sun", isSelected: isSundayReminderOn),
            (day: "Mon", isSelected: isMondayReminderOn),
            (day: "Tue", isSelected: isTuesdayReminderOn),
            (day: "Wed", isSelected: isWednesdayReminderOn),
            (day: "Thu", isSelected: isThursdayReminderOn),
            (day: "Fri", isSelected: isFridayReminderOn),
            (day: "Sat", isSelected: isSaturdayRemidnerOn)
        ]
        
        let selectedDays = days.filter { $0.isSelected }.map { $0.day }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let timeString = timeFormatter.string(from: reminderDate)
        
        if selectedDays.count == 7 {
            return "Everyday at \(timeString)"
        } else if selectedDays.count == 1 {
            return "Every \(selectedDays[0]) at \(timeString)"
        } else {
            return selectedDays.joined(separator: ", ") + " at \(timeString)"
        }
    }

}

//
//  Task.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 21/07/24.
//

import Foundation

struct TaskModel: Identifiable, Hashable {
    let id: UUID
    var taskName: String
    var isChecked: Bool
    var isReminderEnabled: Bool
    var reminderTime: Date
    
    var isSundayReminderOn: Bool
    var isMondayReminderOn: Bool
    var isTuesdayReminderOn: Bool
    var isWednesdayReminderOn: Bool
    var isThursdayReminderOn: Bool
    var isFridayReminderOn: Bool
    var isSaturdayReminderOn: Bool
    
    init(id: UUID = UUID(),
         taskName: String,
         isChecked: Bool = false,
         isReminderEnabled: Bool = false,
         reminderTime: Date = .now,
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
        self.isChecked = isChecked
        self.isReminderEnabled = isReminderEnabled
        self.reminderTime = reminderTime
        self.isSundayReminderOn = isSundayReminderOn
        self.isMondayReminderOn = isMondayReminderOn
        self.isTuesdayReminderOn = isTuesdayReminderOn
        self.isWednesdayReminderOn = isWednesdayReminderOn
        self.isThursdayReminderOn = isThursdayReminderOn
        self.isFridayReminderOn = isFridayReminderOn
        self.isSaturdayReminderOn = isSaturdayRemidnerOn
    }
}

extension TaskModel {
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
            (day: "Sat", isSelected: isSaturdayReminderOn)
        ]
        
        let selectedDays = days.filter { $0.isSelected }.map { $0.day }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let timeString = timeFormatter.string(from: reminderTime)
        
        if selectedDays.count == 7 {
            return "Everyday at \(timeString)"
        } else if selectedDays.count == 1 {
            return "Every \(selectedDays[0]) at \(timeString)"
        } else {
            return selectedDays.joined(separator: ", ") + " at \(timeString)"
        }
    }
}

import Foundation
import SwiftData

@Model
final class DailyTaskDefinition: Identifiable {
    var id: UUID
    var taskName: String
    var createdDate: Date
    
    // Reminder properties
    var isReminderEnabled: Bool
    var reminderClock: Date
    
    // Repeat days
    var sundayReminder: Bool
    var mondayReminder: Bool
    var tuesdayReminder: Bool
    var wednesdayReminder: Bool
    var thursdayReminder: Bool
    var fridayReminder: Bool
    var saturdayReminder: Bool
    
    @Relationship var habit: Habit?
    
    @Relationship(deleteRule: .cascade, inverse: \DailyTask.definition)
    var dailyTasks: [DailyTask] = []
    
    init(id: UUID = UUID(), taskName: String, createdDate: Date = Date()) {
        self.id = id
        self.taskName = taskName
        self.createdDate = createdDate
        
        // Initialize reminder properties
        self.isReminderEnabled = false
        self.reminderClock = Date()
        
        // Initialize repeat days
        self.sundayReminder = false
        self.mondayReminder = false
        self.tuesdayReminder = false
        self.wednesdayReminder = false
        self.thursdayReminder = false
        self.fridayReminder = false
        self.saturdayReminder = false
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

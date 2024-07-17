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

extension DailyTaskDefinition {
    func getReminderDescription() -> String {
        if !isReminderEnabled {
            return ""
        }
        
        let days = [
            (day: NSLocalizedString("Sun", comment: "Sunday"), isSelected: sundayReminder),
            (day: NSLocalizedString("Mon", comment: "Monday"), isSelected: mondayReminder),
            (day: NSLocalizedString("Tue", comment: "Tuesday"), isSelected: tuesdayReminder),
            (day: NSLocalizedString("Wed", comment: "Wednesday"), isSelected: wednesdayReminder),
            (day: NSLocalizedString("Thu", comment: "Thursday"), isSelected: thursdayReminder),
            (day: NSLocalizedString("Fri", comment: "Friday"), isSelected: fridayReminder),
            (day: NSLocalizedString("Sat", comment: "Saturday"), isSelected: saturdayReminder)
        ]
        
        let selectedDays = days.filter { $0.isSelected }.map { $0.day }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let timeString = timeFormatter.string(from: reminderClock)
        
        if selectedDays.count == 7 {
            return String(format: NSLocalizedString("Everyday at %@", comment: "Reminder description for everyday"), timeString)
        } else if selectedDays.count == 1 {
            return String(format: NSLocalizedString("Every %@ at %@", comment: "Reminder description for single day"), selectedDays[0], timeString)
        } else {
            let daysString = selectedDays.joined(separator: ", ")
            return String(format: NSLocalizedString("%@ at %@", comment: "Reminder description for multiple days"), daysString, timeString)
        }
    }
}

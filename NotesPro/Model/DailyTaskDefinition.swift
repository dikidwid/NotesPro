import Foundation
import SwiftData

@Model
final class DailyTaskDefinition: Identifiable {
    // Merupakan blueprint / template task yang di assign ke suatu habit. Objek ini hanya bersifat referensi untuk mendefinisikan tasks yang nantinya akan disalin kedalam objek DailyTask yang berubah setiap harinya.
    let id: UUID
    var taskName: String
    var createdDate: Date
    
    @Relationship var habit: Habit?
    @Relationship var reminder: DailyTaskReminder
    
    @Relationship(deleteRule: .cascade, inverse: \DailyTask.definition)
    var dailyTasks: [DailyTask] = []
    
    init(id: UUID = UUID(), taskName: String, createdDate: Date = Date()) {
        self.id = id
        self.taskName = taskName
        self.createdDate = createdDate
        self.reminder = DailyTaskReminder()
    }
}

@Model
final class DailyTaskReminder: Identifiable {
    var id: UUID
    var isEnabled: Bool
    var clock: Date
    var repeatDays: DailyTaskReminderRepeatDays
    
    init(isEnabled: Bool = false, clock: Date = Date(), repeatDays: DailyTaskReminderRepeatDays = DailyTaskReminderRepeatDays()) {
        self.id = UUID()
        self.isEnabled = isEnabled
        self.clock = clock
        self.repeatDays = repeatDays
    }
    
    func getDescription() -> String {
        
        if !isEnabled {
            return ""
        }
        
        let days = [
            (day: "Sun", isSelected: repeatDays.sunday),
            (day: "Mon", isSelected: repeatDays.monday),
            (day: "Tue", isSelected: repeatDays.tuesday),
            (day: "Wed", isSelected: repeatDays.wednesday),
            (day: "Thu", isSelected: repeatDays.thursday),
            (day: "Fri", isSelected: repeatDays.friday),
            (day: "Sat", isSelected: repeatDays.saturday)
        ]
        
        let selectedDays = days.filter { $0.isSelected }.map { $0.day }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let timeString = timeFormatter.string(from: clock)
        
        if selectedDays.count == 7 {
            return "Everyday at \(timeString)"
        } else if selectedDays.count == 1 {
            return "Every \(selectedDays[0]) at \(timeString)"
        } else {
            return selectedDays.joined(separator: ", ") + " at \(timeString)"
        }
    }
}

@Model
final class DailyTaskReminderRepeatDays: Identifiable {
    var id: UUID
    
    var sunday: Bool = false
    var monday: Bool = false
    var tuesday: Bool = false
    var wednesday: Bool = false
    var thursday: Bool = false
    var friday: Bool = false
    var saturday: Bool = false
    
    init(sunday: Bool = false, monday: Bool = false, tuesday: Bool = false, wednesday: Bool = false, thursday: Bool = false, friday: Bool = false, saturday: Bool = false) {
        self.id = UUID()
        self.sunday = sunday
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
    }
}

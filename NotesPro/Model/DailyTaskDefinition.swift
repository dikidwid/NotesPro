import Foundation
import SwiftData

@Model
final class DailyTaskDefinition: Identifiable {
    let id: UUID
    var taskName: String
    let createdDate: Date
    
    @Relationship var habit: Habit?
    @Relationship var reminder: DailyTaskReminder?
    
    init(id: UUID = UUID(), taskName: String, createdDate: Date = Date()) {
        self.id = id
        self.taskName = taskName
        self.createdDate = createdDate
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

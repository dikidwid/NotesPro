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
    var habit: HabitModel?
    var habitEntry: DailyHabitEntryModel?
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
         habit: HabitModel? = nil,
         habitEntry: DailyHabitEntryModel? = nil,
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
        self.habit = habit
        self.habitEntry = habitEntry
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

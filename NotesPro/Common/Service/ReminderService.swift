//
//  ReminderService.swift
//  NotesPro
//
//  Created by Jason Susanto on 16/07/24.
//

import UserNotifications
import SwiftData

class ReminderService {
    static let shared = ReminderService()
    private init() {}
    
    func scheduleReminders(for habit: Habit) {
        for taskDefinition in habit.definedTasks {
            if taskDefinition.isReminderEnabled {
                scheduleReminder(for: taskDefinition)
            }
        }
    }
    
    private func scheduleReminder(for taskDefinition: DailyTaskDefinition) {
        let content = UNMutableNotificationContent()
        content.title = "Habit Reminder"
        content.body = "Time to do: \(taskDefinition.taskName)"
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: taskDefinition.reminderClock)
        
        let days = [
            taskDefinition.sundayReminder,
            taskDefinition.mondayReminder,
            taskDefinition.tuesdayReminder,
            taskDefinition.wednesdayReminder,
            taskDefinition.thursdayReminder,
            taskDefinition.fridayReminder,
            taskDefinition.saturdayReminder
        ]
        
        for (index, isSelected) in days.enumerated() {
            if isSelected {
                var triggerComponents = components
                triggerComponents.weekday = index + 1 // Sunday = 1, Monday = 2, etc.
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
                let request = UNNotificationRequest(identifier: "\(taskDefinition.id)-\(index)", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    }
                }
            }
        }
    }
    
    func cancelReminders(for habit: Habit) {
        for taskDefinition in habit.definedTasks {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: (0...6).map { "\(taskDefinition.id)-\($0)" })
        }
    }
}

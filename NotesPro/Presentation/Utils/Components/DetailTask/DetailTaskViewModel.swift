//
//  DetailTaskViewModel.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 01/08/24.
//

import Foundation

final class DetailTaskViewModel: ObservableObject {
    @Published var selectedTask: TaskModel
    
    init(selectedTask: TaskModel) {
        self.selectedTask = selectedTask
    }
    
    enum Weekday: String, CaseIterable {
        case sunday = "Sunday"
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
    }
    
    var isEveryday: Bool {
        return selectedTask.isSundayReminderOn &&
        selectedTask.isMondayReminderOn &&
        selectedTask.isTuesdayReminderOn &&
        selectedTask.isWednesdayReminderOn &&
        selectedTask.isThursdayReminderOn &&
        selectedTask.isFridayReminderOn &&
        selectedTask.isSaturdayReminderOn
    }
    
    var reminderLabel: String {
        if isEveryday {
            return "Everyday"
        }
        
        let days = [
            (day: "Sun", isSelected: selectedTask.isSundayReminderOn),
            (day: "Mon", isSelected: selectedTask.isMondayReminderOn),
            (day: "Tue", isSelected: selectedTask.isTuesdayReminderOn),
            (day: "Wed", isSelected: selectedTask.isWednesdayReminderOn),
            (day: "Thu", isSelected: selectedTask.isThursdayReminderOn),
            (day: "Fri", isSelected: selectedTask.isFridayReminderOn),
            (day: "Sat", isSelected: selectedTask.isSaturdayReminderOn)
        ]
        
        let selectedDays = days.filter { $0.isSelected }.map { $0.day }
        
        if selectedDays.isEmpty {
            return "Never"
        } else {
            return selectedDays.joined(separator: ", ")
        }
    }
    
    var reminderDescription: String {
        if !selectedTask.isReminderEnabled {
            return ""
        }
        
        let days = [
            (day: "Sun", isSelected: selectedTask.isSundayReminderOn),
            (day: "Mon", isSelected: selectedTask.isMondayReminderOn),
            (day: "Tue", isSelected: selectedTask.isTuesdayReminderOn),
            (day: "Wed", isSelected: selectedTask.isWednesdayReminderOn),
            (day: "Thu", isSelected: selectedTask.isThursdayReminderOn),
            (day: "Fri", isSelected: selectedTask.isFridayReminderOn),
            (day: "Sat", isSelected: selectedTask.isSaturdayReminderOn)
        ]
        
        let selectedDays = days.filter { $0.isSelected }.map { $0.day }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let timeString = timeFormatter.string(from: selectedTask.reminderTime)
        
        if selectedDays.count == 7 {
            return "Everyday at \(timeString)"
        } else if selectedDays.count == 1 {
            return "Every \(selectedDays[0]) at \(timeString)"
        } else {
            return selectedDays.joined(separator: ", ") + " at \(timeString)"
        }
    }
    
    func toggleReminder(for day: Weekday) {
        switch day {
        case .sunday:
            selectedTask.isSundayReminderOn.toggle()
        case .monday:
            selectedTask.isMondayReminderOn.toggle()
        case .tuesday:
            selectedTask.isTuesdayReminderOn.toggle()
        case .wednesday:
            selectedTask.isWednesdayReminderOn.toggle()
        case .thursday:
            selectedTask.isThursdayReminderOn.toggle()
        case .friday:
            selectedTask.isFridayReminderOn.toggle()
        case .saturday:
            selectedTask.isSaturdayReminderOn.toggle()
        }
    }

    func toggleReminderForEveryday() {
        selectedTask.isSundayReminderOn.toggle()
        selectedTask.isMondayReminderOn.toggle()
        selectedTask.isTuesdayReminderOn.toggle()
        selectedTask.isWednesdayReminderOn.toggle()
        selectedTask.isThursdayReminderOn.toggle()
        selectedTask.isFridayReminderOn.toggle()
        selectedTask.isSaturdayReminderOn.toggle()
    }
    
    func iconReminder(for day: Weekday) -> String {
        switch day {
        case .sunday:
            return selectedTask.isSundayReminderOn ? "checkmark" : ""
        case .monday:
            return selectedTask.isMondayReminderOn ? "checkmark" : ""
        case .tuesday:
            return selectedTask.isTuesdayReminderOn ? "checkmark" : ""
        case .wednesday:
            return selectedTask.isWednesdayReminderOn ? "checkmark" : ""
        case .thursday:
            return selectedTask.isThursdayReminderOn ? "checkmark" : ""
        case .friday:
            return selectedTask.isFridayReminderOn ? "checkmark" : ""
        case .saturday:
            return selectedTask.isSaturdayReminderOn ? "checkmark" : ""
        }
    }
}

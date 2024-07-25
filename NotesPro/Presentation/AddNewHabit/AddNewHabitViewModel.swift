//
//  AddNewHabitViewModel.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 22/07/24.
//

import Foundation

final class AddHabitViewModell: ObservableObject {
    @Published var habitName: String = ""
    @Published var tasks: [TaskModel] = []
    @Published var isShowAIOnboardingView: Bool = false
    
    @Published var selectedTask: TaskModel?
    
    @Published var isReminderEnabled: Bool = false
    @Published var reminderDate: Date = .now
    @Published var isSundayReminderOn: Bool = false
    @Published var isMondayReminderOn: Bool = false
    @Published var isTuesdayReminderOn: Bool = false
    @Published var isWednesdayReminderOn: Bool = false
    @Published var isThursdayReminderOn: Bool = false
    @Published var isFridayReminderOn: Bool = false
    @Published var isSaturdayReminderOn: Bool = false
    
    var isValidHabit: Bool {
        !habitName.isEmpty && !tasks.isEmpty
    }
    
    let addHabitUseCase: AddHabitUseCase
    
    init(addHabitUseCase: AddHabitUseCase) {
        self.addHabitUseCase = addHabitUseCase
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
        return isSundayReminderOn &&
        isMondayReminderOn &&
        isTuesdayReminderOn &&
        isWednesdayReminderOn &&
        isThursdayReminderOn &&
        isFridayReminderOn &&
        isSaturdayReminderOn
    }
    
//    var reminderLabel: String {
//        if isEveryday {
//            return "Everyday"
//        }
//        
//        let days = [
//            (day: "Sun", isSelected: isSundayReminderOn),
//            (day: "Mon", isSelected: isMondayReminderOn),
//            (day: "Tue", isSelected: isTuesdayReminderOn),
//            (day: "Wed", isSelected: isWednesdayReminderOn),
//            (day: "Thu", isSelected: isThursdayReminderOn),
//            (day: "Fri", isSelected: isFridayReminderOn),
//            (day: "Sat", isSelected: isSaturdayReminderOn)
//        ]
//        
//        let selectedDays = days.filter { $0.isSelected }.map { $0.day }
//        
//        if selectedDays.isEmpty {
//            return "Never"
//        } else {
//            return selectedDays.joined(separator: ", ")
//        }
//    }
    
    var reminderDescription: String {
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
        let timeString = timeFormatter.string(from: reminderDate)
        
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
            isSundayReminderOn.toggle()
        case .monday:
            isMondayReminderOn.toggle()
        case .tuesday:
            isTuesdayReminderOn.toggle()
        case .wednesday:
            isWednesdayReminderOn.toggle()
        case .thursday:
            isThursdayReminderOn.toggle()
        case .friday:
            isFridayReminderOn.toggle()
        case .saturday:
            isSaturdayReminderOn.toggle()
        }
    }

    func toggleReminderForEveryday() {
       isSundayReminderOn.toggle()
       isMondayReminderOn.toggle()
       isTuesdayReminderOn.toggle()
       isWednesdayReminderOn.toggle()
       isThursdayReminderOn.toggle()
       isFridayReminderOn.toggle()
       isSaturdayReminderOn.toggle()
    }
    
    func reminderIcon(for day: Weekday) -> String {
        switch day {
        case .sunday:
            return isSundayReminderOn ? "checkmark" : ""
        case .monday:
            return isMondayReminderOn ? "checkmark" : ""
        case .tuesday:
            return isTuesdayReminderOn ? "checkmark" : ""
        case .wednesday:
            return isWednesdayReminderOn ? "checkmark" : ""
        case .thursday:
            return isThursdayReminderOn ? "checkmark" : ""
        case .friday:
            return isFridayReminderOn ? "checkmark" : ""
        case .saturday:
            return isSaturdayReminderOn ? "checkmark" : ""
        }
    }
    
    func createNewTask() {
        let newTask = TaskModel(taskName: "")
        tasks.append(newTask)
        selectedTask = newTask
    }
    
    func saveTask(_ task: TaskModel) {
        if let selectedTask, let index = tasks.firstIndex(where: { $0.id == selectedTask.id }) {
            tasks[index] = task
        }
    }
    
    func deleteTask(_ task: TaskModel) {
        tasks.removeAll { $0.id == task.id }
    }
    
    func setSelectedTask(to task: TaskModel) {
        selectedTask = task
    }
    
    func createHabit() async{
        let newHabit = HabitModel(habitName: habitName)
        await addHabitUseCase.execute(habit: newHabit)
    }

//    private func generateEntriesForPast30Days() -> [DailyHabitEntryModel] {
//        var entries: [DailyHabitEntryModel] = []
//        let calendar = Calendar.current
//        let currentDate = Date()
//        
//        for dayOffset in 0..<30 {
//            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: currentDate) {
//                let entry = DailyHabitEntryModel(
//                    date: date,
//                    note: "Entry for \(calendar.component(.day, from: date))",
//                    tasks: tasks, 
//                    habit:
//                )
//                entries.append(entry)
//            }
//        }
//        
//        return entries
//    }
}

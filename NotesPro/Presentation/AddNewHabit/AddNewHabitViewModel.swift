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
    
    func createNewTask() {
        let newTask = TaskModel(taskName: "")
        tasks.append(newTask)
        selectedTask = newTask
    }
    
    func updateTask(_ task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    func deleteTask(_ task: TaskModel) {
        tasks.removeAll { $0.id == task.id }
    }
    
    func setSelectedTask(to task: TaskModel) {
        selectedTask = task
    }
    
    func createHabit() {
        var newHabit = HabitModel(id: UUID(),
                                  habitName: habitName,
                                  currentStreak: 0,
                                  bestStreak: 0,
                                  lastCompletedDate: .now,
                                  definedTasks: tasks)
    
        let generatedHabitEntryFor100Days = generateHabitEntries(for: 30, in: newHabit)
        
        newHabit.dailyHabitEntries = generatedHabitEntryFor100Days
        
        addHabitUseCase.execute(habit: newHabit)
    }
    
    private func generateHabitEntries(for totalPastDays: Int, in habit: HabitModel) -> [DailyHabitEntryModel] {
        var entries: [DailyHabitEntryModel] = []
        var tasks: [TaskModel] = tasks
        let calendar = Calendar.current
        let currentDate = Date()
        
        for totalPastDays in 0..<totalPastDays {
            if let date = calendar.date(byAdding: .day, value: -totalPastDays, to: currentDate) {
                var entry = DailyHabitEntryModel(
                    date: date,
                    note: "Entry for \(calendar.component(.day, from: date))",
                    habit: habit
                )
                
                for taskIndex in tasks.indices {
                    tasks[taskIndex].habit = habit
                    tasks[taskIndex].habitEntry = entry
                }
                
                
                entry.tasks = tasks
                
                entries.append(entry)
            }
        }
        
        let tasksID = entries.flatMap { $0.tasks.flatMap { $0.habit?.id } }
        
        print("habit id from tasks: \(tasksID)")

        return entries
    }
}

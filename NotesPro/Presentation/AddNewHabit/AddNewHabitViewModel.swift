//
//  AddNewHabitViewModel.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 22/07/24.
//

import Foundation

struct HabitEntry {
    let date: Date
    let note: String
    let habit: [HabitModel]
    let tasks: [TaskModel]
}


final class AddHabitViewModell: ObservableObject {
//    @Published var habitName: String = ""
    @Published var habit: HabitModel =  HabitModel(habitName: "")
//    @Published var tasks: [TaskModel] = []
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
        !habit.habitName.isEmpty && !habit.definedTasks.isEmpty
    }
    
    let addHabitUseCase: AddHabitUseCase
    
    init(addHabitUseCase: AddHabitUseCase) {
        self.addHabitUseCase = addHabitUseCase
    }

    func showAIOnboardingView() {
        isShowAIOnboardingView.toggle()
    }
    
    func populateFromRecommendation(_ recommendation: Recommendation) {
        habit.habitName = recommendation.title
        habit.definedTasks = recommendation.items.map { TaskModel(taskName: $0) }
    }
    
    func createNewTask() {
        let newTask = TaskModel(taskName: "")
        habit.definedTasks.append(newTask)
        selectedTask = newTask
    }
    
    func updateTask(_ task: TaskModel) {
        if let index = habit.definedTasks.firstIndex(where: { $0.id == task.id }) {
            habit.definedTasks[index] = task
        }
    }
    
    func deleteTask(_ task: TaskModel) {
        habit.definedTasks.removeAll { $0.id == task.id }
    }
    
    func setSelectedTask(to task: TaskModel) {
        selectedTask = task
    }
    
    func createHabit(_ habit: @escaping ((HabitModel)-> Void)) {
        var newHabit = HabitModel( id: self.habit.id,
                                   habitName: self.habit.habitName,
                                   currentStreak: self.habit.currentStreak,
                                   bestStreak: self.habit.bestStreak,
                                   lastCompletedDate: self.habit.lastCompletedDate,
                                   definedTasks: self.habit.definedTasks)
        
        habit(newHabit)

        addHabitUseCase.execute(habit: newHabit)
    }
    
//    private func generateHabitEntries(for totalPastDays: Int, in habit: HabitModel) -> [DailyHabitEntryModel] {
//        var entries: [DailyHabitEntryModel] = []
//        var tasks: [TaskModel] = habit.definedTasks
//        let calendar = Calendar.current
//        let currentDate = Date()
//        
//        for totalPastDays in 0..<totalPastDays {
//            if let date = calendar.date(byAdding: .day, value: -totalPastDays, to: currentDate) {
//                var entry = DailyHabitEntryModel(
//                    date: date,
//                    note: "Entry for \(calendar.component(.day, from: date))"
////                    habit: habit
//                )
//                
//                for taskIndex in tasks.indices {
//                    tasks[taskIndex].habit = habit
//                    tasks[taskIndex].habitEntry = entry
//                }
//                
//                
//                entry.tasks = tasks
//                
//                entries.append(entry)
//            }
//        }
//        
//        let tasksID = entries.flatMap { $0.tasks.flatMap { $0.habit?.id } }
//        
//        print("habit id from tasks: \(tasksID)")
//
//        return entries
//    }
}

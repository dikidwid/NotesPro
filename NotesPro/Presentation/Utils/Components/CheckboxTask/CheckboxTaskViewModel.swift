//
//  CheckboxTaskViewModel.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 30/07/24.
//

import Foundation

final class CheckboxTaskViewModel: ObservableObject {
    @Published var task: TaskModel
    let isShowReminderTime: Bool
    let taskHabit: HabitModel
    let taskDate: Date
    let updateTaskUseCase: UpdateTaskUseCase
    
    init(task: TaskModel, isShowReminderTime: Bool = false, taskHabit: HabitModel, taskDate: Date, updateTaskUseCase: UpdateTaskUseCase) {
        self.task = task
        self.isShowReminderTime = isShowReminderTime
        self.taskHabit = taskHabit
        self.taskDate = taskDate
        self.updateTaskUseCase = updateTaskUseCase
    }
    
    func toggleTask() {
        task.isChecked.toggle()
        updateTaskUseCase.execute(for: task, habitID: taskHabit.id, on: taskDate)
    }
}

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
    let updateTaskUseCase: UpdateTaskUseCase
    
    init(task: TaskModel, isShowReminderTime: Bool = false, updateTaskUseCase: UpdateTaskUseCase) {
        self.task = task
        self.isShowReminderTime = isShowReminderTime
        self.updateTaskUseCase = updateTaskUseCase
    }
    
    func toggleTask() {
        task.isChecked.toggle()
        updateTaskUseCase.execute(for: task)
    }
}

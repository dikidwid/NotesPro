//
//  CheckboxTaskView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 16/07/24.
//

import SwiftUI

struct CheckboxTaskView<HabitViewModel>: View where HabitViewModel: HabitViewModelProtocol {
    @StateObject var checkboxTaskViewModel: CheckboxTaskViewModel
    @EnvironmentObject private var habitViewModel: HabitViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: checkboxTaskViewModel.task.isChecked ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(checkboxTaskViewModel.task.isChecked ? .accent : .secondary)
                .font(.title3)
                .fontWeight(.semibold)
                .contentTransition(.symbolEffect(.replace))
                .onTapGesture {
                    checkboxTaskViewModel.toggleTask()
                    Task {
                       await habitViewModel.fetchHabits()
                    }
                }
            
            
            VStack(alignment: .leading, spacing: 2.5) {
                Text(checkboxTaskViewModel.task.taskName)
                    .font(.system(.body))
                    .foregroundStyle(checkboxTaskViewModel.task.isChecked ? Color.secondary : .primary)
                
                if checkboxTaskViewModel.isShowReminderTime {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        
                        Text("08.00")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    
                }
            }
            .strikethrough(checkboxTaskViewModel.task.isChecked)
        }
    }
}

final class CheckboxTaskViewModel: ObservableObject {
    @Published var task: TaskModel
    let isShowReminderTime: Bool
    let updateTaskUseCase: UpdateTaskUseCase
    
    init(task: TaskModel, isShowReminderTime: Bool = false, updateTaskUseCase: UpdateTaskUseCase = UpdateTaskUseCase(repository: HabitRepositoryMock.shared)) {
        self.task = task
        self.isShowReminderTime = isShowReminderTime
        self.updateTaskUseCase = updateTaskUseCase
    }
    
    func toggleTask() {
        task.isChecked.toggle()
        print(task.isChecked)
        updateTaskUseCase.execute(for: task)
    }
}

//#Preview {
//    CheckboxTaskVieww(checkboxTaskViewModel: CheckboxTaskViewModel(task: TaskModel(taskName: "Test"), isShowReminderTime: true))
//}

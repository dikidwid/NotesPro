//
//  CheckboxTaskView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 16/07/24.
//

import SwiftUI

struct CheckboxTaskView: View {
    @ObservedObject var checkboxTaskViewModel: CheckboxTaskViewModel
    let onCheckTask: ((TaskModel) -> Void)
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: checkboxTaskViewModel.task.isChecked ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(checkboxTaskViewModel.task.isChecked ? .accent : .secondary)
                .font(.title3)
                .fontWeight(.semibold)
                .contentTransition(.symbolEffect(.replace))
                .onTapGesture {
                    checkboxTaskViewModel.toggleTask()
                    onCheckTask(checkboxTaskViewModel.task)
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

//#Preview {
//    CheckboxTaskVieww(checkboxTaskViewModel: CheckboxTaskViewModel(task: TaskModel(taskName: "Test"), isShowReminderTime: true))
//}

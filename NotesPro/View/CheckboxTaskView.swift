//
//  CheckboxTaskView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 16/07/24.
//

import SwiftUI

struct CheckboxTaskView: View {
    let isShowReminderTime: Bool
    @Bindable var task: DailyTask
    
//    @EnvironmentObject var viewModel: NotesViewModel
    @EnvironmentObject var viewModel: HabitViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: task.isChecked ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(task.isChecked ? .accent : .secondary)
                .font(.title3)
                .fontWeight(.semibold)
                .contentTransition(.symbolEffect(.replace))
                .onTapGesture {
                    viewModel.toggleTask(task)
                }
            
            
            VStack(alignment: .leading, spacing: 2.5) {
                Text(task.taskName)
                    .font(.system(.body))
                    .foregroundStyle(task.isChecked ? Color.secondary : .primary)
                
                if isShowReminderTime {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        
                        Text("08.00")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    
                }
            }
            .strikethrough(task.isChecked)
        }
    }
}

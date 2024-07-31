//
//  EditHabitView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 25/07/24.
//

import SwiftUI

struct EditHabitView: View {
    @ObservedObject var editHabitViewModel: EditHabitViewModel
    @EnvironmentObject var coordinator: AppCoordinatorImpl
        
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Habit")) {
                    TextField("Enter Habit Name", text: $editHabitViewModel.habit.habitName)
                        .autocorrectionDisabled()
                }
                
                Section(header: Text("Tasks")) {
                    ForEach(editHabitViewModel.habit.definedTasks) { task in
                        HStack {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                                .font(.title3)
                                .onTapGesture {
                                    editHabitViewModel.deleteTask(task)
                                }
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(task.taskName)
                                    
                                    if task.isReminderEnabled {
                                        Text(task.getReminderDescription())
                                            .font(.footnote)
                                            .opacity(0.6)
                                    }
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                editHabitViewModel.selectedTask = task
                            }
                        }
                        .foregroundColor(.primary)
                    }
                    
                    Button {
                        editHabitViewModel.createNewTask()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .font(.title3)
                            Text("Add Task")
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                        }
                    }
                }
                
                Section(header: Text("or use AI habit Generator")) {
                    Button("✨ Generate Habits with AI") {
                        //                            addHabitViewModel.showAIOnboardingSheet()
                    }
                    .foregroundColor(.accentColor)
                }
            }
            .background(.black)
            .navigationTitle("Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $editHabitViewModel.selectedTask) { task in
                coordinator.createDetailTaskView(for: task, onSaveTapped: { editHabitViewModel.updateTask($0)})
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        coordinator.dismissSheet()
                    }
                    .foregroundColor(.accentColor)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        editHabitViewModel.saveHabitAndDismiss(with: coordinator)
                    }
                    .foregroundColor(editHabitViewModel.isValidHabit ? .accentColor : .gray)
                    .disabled(!editHabitViewModel.isValidHabit)
                }
            }
        }
    }
}

//
//  AddNewHabitView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 22/07/24.
//

import SwiftUI

struct AddNewHabitView<HabitViewModel>: View where HabitViewModel: HabitViewModelProtocol {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var addHabitViewModel: AddHabitViewModell
    @ObservedObject var habitViewModel: HabitViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Habit")) {
                    TextField("Enter Habit Name", text: $addHabitViewModel.habitName)
                        .autocorrectionDisabled()
                }
                
                Section(header: Text("Tasks")) {
                    ForEach(addHabitViewModel.tasks) { task in
                        HStack {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                                .font(.title3)
                                .onTapGesture {
                                    addHabitViewModel.deleteTask(task)
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
                                addHabitViewModel.setSelectedTask(to: task)
                            }
                        }
                        .foregroundColor(.primary)
                    }
                    
                    Button {
                        addHabitViewModel.createNewTask()
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
            .navigationTitle("Add Habit")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $addHabitViewModel.selectedTask) { task in
                DetailTaskView(addHabitViewModel: addHabitViewModel,
                               detailTaskViewModel: DetailTaskViewModel(selectedTask: task))
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.accentColor)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            await addHabitViewModel.createHabit()
                            await habitViewModel.fetchHabits()
                        }
                        dismiss()
                    }
                    .foregroundColor(addHabitViewModel.isValidHabit ? .accentColor : .gray)
                    .disabled(!addHabitViewModel.isValidHabit)
                }
            }
        }
    }
}

//
//  AddNewHabitView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 22/07/24.
//

import SwiftUI

struct AddNewHabitView: View {
    @EnvironmentObject private var appCoordinator: AppCoordinatorImpl
    @ObservedObject var addHabitViewModel: AddHabitViewModell
    let onDismiss: ((HabitModel) -> Void?)
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Habit")) {
                    TextField("Enter Habit Name", text: $addHabitViewModel.habit.habitName)
                        .autocorrectionDisabled()
                }
                
                Section(header: Text("Tasks")) {
                    ForEach(addHabitViewModel.habit.definedTasks) { task in
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
                        addHabitViewModel.showAIOnboardingView()
                    }
                    .foregroundColor(.accentColor)
                }
            }
            .background(.black)
            .navigationTitle("Add Habit")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $addHabitViewModel.selectedTask) { task in
                DetailTaskView(detailTaskViewModel: DetailTaskViewModel(selectedTask: task), onSaveTapped: { addHabitViewModel.updateTask($0)})
            }
            .sheet(isPresented: $addHabitViewModel.isShowAIOnboardingView) {
                appCoordinator.createAIOnBoardingView { addHabitViewModel.populateFromRecommendation($0) }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        appCoordinator.dismissSheet()
                    }
                    .foregroundColor(.accentColor)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        addHabitViewModel.createHabit { onDismiss($0) }
                        appCoordinator.dismissSheet()
                    }
                    .foregroundColor(addHabitViewModel.isValidHabit ? .accentColor : .gray)
                    .disabled(!addHabitViewModel.isValidHabit)
                }
            }
        }
    }
}

////
////  DetailTaskView.swift
////  NotesPro
////
////  Created by Jason Susanto on 13/07/24.
////
//
//import SwiftUI
//
//struct DetailTaskView: View {
//    
//    @Environment(\.modelContext) private var modelContext
//    @Environment(\.dismiss) private var dismiss
//    @EnvironmentObject private var viewModel: HabitsViewModel
//    
//    @Bindable var task : DailyTaskDefinition
////    
//    @State private var taskName: String = ""
//    @State private var isReminder: Bool = false
//    
//    @State private var selectedTime = Date()
//    @State private var selectedRepeatOption = 0
//    
//    private let isNewTask: Bool
//
//    init(task: DailyTaskDefinition, isNewTask: Bool) {
//        self._task = Bindable(task)
////        _selectedRepeatOption = State(initialValue: RepeatOption.allCases.firstIndex(where: { $0.rawValue == task.repeatSchedule }) ?? 0)
//        self.isNewTask = isNewTask
//    }
//    
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 0) {
//                Divider()
//                Form(content: {
//                    Section {
//                        TextField("Enter Task Name", text: $task.taskName)
//                    } header: {
//                        Text("TASK")
//                    }
//                    
//                    Section {
//                        Toggle(isOn: $task.isReminder, label: {
//                            Text("Reminder")
//                        })
//                        if task.isReminder {
//                            DatePicker("Time", selection: $task.reminderTime, displayedComponents: .hourAndMinute)
//                                .environment(\.locale, Locale(identifier: "en_US_POSIX"))
//                            
//                            Picker(selection: $selectedRepeatOption, label: Text("Repeat")) {
//                                ForEach(RepeatOption.allCases.indices, id: \.self) { index in
//                                    Text(RepeatOption.allCases[index].localized)
//                                }
//                            }
//                            .pickerStyle(MenuPickerStyle())
//                            .onChange(of: selectedRepeatOption) {
//                                task.repeatSchedule = RepeatOption.allCases[selectedRepeatOption].rawValue
//                            }
////                            .onChange(of: selectedRepeatOption) { newValue in
////                                task.repeatSchedule = RepeatOption.allCases[newValue].rawValue
////                            }
//                        }
//                    } header: {
//                        Text("Reminders")
//                            .textCase(.uppercase)
//                    }
//                    
//                    
//                })
//            }
//            .navigationBarBackButtonHidden(true)
//            .navigationTitle(isNewTask ? "New Task" : "Edit Task")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar(content: {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button(action: {
//                        dismiss()
//                    }, label: {
//                        HStack(spacing: 4) {
//                            Image(systemName: "chevron.backward")
//                                .font(.subheadline)
//                            Text("Back")
//                        }
//                    })
//                    .foregroundColor(.orange)
//                }
//            })
//            .toolbar(content: {
//                ToolbarItem(placement: .topBarTrailing) {
//                    if isNewTask{
//                        Button(action: {
//                            task.repeatSchedule = RepeatOption.allCases[selectedRepeatOption].rawValue
//                            viewModel.saveHabit(modelContext: modelContext)
//                            dismiss()
//                        }, label: {
//                            Text("Add")
//                        })
//                        .foregroundColor(.orange)
//                    } else {
//                        EmptyView()
//                    }
//                }
//            })
//        }
//        .padding(.top, 10)
//    }
//    
//    
//}
//
////#Preview {
////    DetailTaskView()
////}

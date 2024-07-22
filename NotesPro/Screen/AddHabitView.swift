//
//  AddHabitView.swift
//  NotesPro
//
//  Created by Jason Susanto on 12/07/24.
//
import SwiftUI
import SwiftData

//struct AddHabitView: View {
//    @ObservedObject var addHabitViewModel: AddHabitViewModel
//    @ObservedObject var habitViewModel: HabitViewModel
//    
//    @State private var showDetailTaskSheet = false
//    @State private var selectedTask: DailyTaskDefinition?
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                
//                Divider()
//                
//                Form {
//                    HabitNameSection(habitName: $addHabitViewModel.habitName,
//                                     updateHabitName: addHabitViewModel.updateHabitName)
//                    
//                    TasksSection(tasks: addHabitViewModel.definedTasks,
//                                 viewModel: addHabitViewModel,
//                                 showDetailTaskSheet: $showDetailTaskSheet,
//                                 selectedTask: $selectedTask)
//                    
//                    Section(header: Text("or use AI habit Generator")) {
//                        Button("✨ Generate Habits with AI") {
//                            addHabitViewModel.showAIOnboardingSheet()
//                        }
//                        .foregroundColor(.accentColor)
//                    }
//                }
//            }
//            .navigationTitle(habitViewModel.selectedHabit == nil ? "New Habit" : "Edit Habit")
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationDestination(item: $selectedTask) { task in
//                DetailTaskView(task: task, isNewTask: habitViewModel.selectedHabit == nil)
//                    .onDisappear {
//                        addHabitViewModel.deleteEmptyTasks()
//                    }
//            }
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                    .foregroundColor(.accentColor)
//                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("Save") {
//                        if addHabitViewModel.isValidHabit {
//                            addHabitViewModel.saveHabit(modelContext: modelContext, existingHabit: habitViewModel.selectedHabit)
//                            dismiss()
//                        }
//                    }
//                    .foregroundColor(addHabitViewModel.isValidHabit ? .accentColor : .gray)
//                    .disabled(!addHabitViewModel.isValidHabit)
//                }
//            }
//        }
//        .sheet(isPresented: $addHabitViewModel.isAIOnboardingPresented) {
//            AIOnboardingView()
//        }
//    }
//}

//struct HabitNameSection: View {
//    @Binding var habitName: String
//    var updateHabitName: (String) -> Void
//    
//    var body: some View {
//        Section(header: Text("Habit")) {
//            TextField("Enter Habit Name", text: $habitName)
//                .autocorrectionDisabled()
//                .onChange(of: habitName) { _, newValue in
//                    updateHabitName(newValue)
//                }
//        }
//    }
//}
//
//struct TasksSection: View {
//    let tasks: [DailyTaskDefinition]
//    var viewModel: AddHabitViewModel
//    @Binding var showDetailTaskSheet: Bool
//    @Binding var selectedTask: DailyTaskDefinition?
//    
//    var body: some View {
//        Section(header: Text("Tasks")) {
//            ForEach(tasks) { task in
//                TaskRow(task: task, viewModel: viewModel, showDetailTaskSheet: $showDetailTaskSheet, selectedTask: $selectedTask)
//            }
//            
//            HStack {
//                Image(systemName: "plus.circle.fill")
//                    .foregroundColor(.green)
//                    .font(.title3)
//                Text("Add Task")
//                    .foregroundColor(.primary)
//                
//                Spacer()
//
//            }
//            .onTapGesture {
//                selectedTask = viewModel.addTask()
//                showDetailTaskSheet = true
//            }
//        }
//    }
//}
//
//struct TaskRow: View {
//    var task: TaskModel
//    var viewModel: AddHabitViewModel
//    @Binding var showDetailTaskSheet: Bool
//    @Binding var selectedTask: DailyTaskDefinition?
//    
//    var body: some View {
//        HStack {
//            Image(systemName: "minus.circle.fill")
//                .foregroundColor(.red)
//                .font(.title3)
//                .onTapGesture {
//                    viewModel.deleteTask(task)
//                }
//            
//            HStack {
//                VStack(alignment: .leading) {
//                    Text(task.taskName)
//                    if task.isReminderEnabled {
//                        Text(task.getReminderDescription())
//                            .font(.footnote)
//                            .opacity(0.6)
//                    }
//                }
//                
//                Spacer()
//                
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.secondary)
//            }
//            .contentShape(Rectangle())
//            .onTapGesture {
//                selectedTask = task
//                showDetailTaskSheet = true
//            }
//        }
//        .foregroundColor(.primary)
//    }
//}

//#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: Habit.self, DailyTaskDefinition.self, configurations: config)
//        
//        let sampleHabit = Habit(habitName: "Read Books", description: "Read for personal growth")
//        
//        let task1 = DailyTaskDefinition(taskName: "Read 30 minutes")
//        let task2 = DailyTaskDefinition(taskName: "Write summary")
//        
//        sampleHabit.definedTasks = [task1, task2]
//        
//        container.mainContext.insert(sampleHabit)
//        
//        let viewModel = AddHabitViewModel()
//        viewModel.populateFromHabit(sampleHabit)
//        
//        return AddHabitView()
//            .modelContainer(container)
//            .environmentObject(viewModel)
////            .environmentObject(/*HabitsViewModel()*/)
//        
//    } catch {
//        return Text("Failed to create preview: \(error.localizedDescription)")
//    }
//}

//#Preview {
//    let addHabitUseCase = AddHabitUseCase(repository: HabitRepositoryImpl(dataSource: SwiftDataManager.shared))
//    
//    return AddNewHabitView(addHabitViewModel: AddHabitViewModell(addHabitUseCase: addHabitUseCase), habitViewModel: Habit)
//}



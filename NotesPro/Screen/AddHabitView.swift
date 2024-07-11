//
//  DetailHabitView.swift
//  NotesPro
//
//  Created by Jason Susanto on 11/07/24.
//

import SwiftUI
import SwiftData

struct AddHabitView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var newTaskName: String = ""
    @State private var tasks: [DailyTaskDefinition] = []
    @StateObject private var viewModel = HabitsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 0) {
                Divider()
                Form{
                    Section {
                        HStack{
                            Text("Name")
                                .padding(.trailing, 50)
                            TextField("Enter Habit Name", text: $viewModel.habit.title)
                            
                            Button {
                                viewModel.habit.title = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                            }
                            
                        }
                    }
                    
                    Section{
                        ForEach(tasks) {task in
                            TaskRow(task: task) {
                                tasks.removeAll { $0.id == task.id }
                            }
                        }
                        AddRow(titleRow: "Add Task") {
//                            let newTask = viewModel.addTask(to: viewModel.habit, taskName: "New Task", description: "Task Description", modelContext: modelContext)
                            let newTask = DailyTaskDefinition(taskName: "NewTask")
                            tasks.append(newTask)
                        }
                    }
                    
                    Section{
                        HStack {
                            Spacer()
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Delete Habit")
                                    .foregroundColor(.red)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitle("New Habit", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.yellow)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        _ = viewModel.addHabit(modelContext: modelContext)
                        viewModel.saveHabit(modelContext: modelContext)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.gray)
                }
            }
        }
    }
}

struct TaskRow: View {
    var task: DailyTaskDefinition
    var onDelete: () -> Void
    
    @State private var showDetailView: Bool = false
    @State private var isEditing: Bool = false
    @State private var editedTaskName: String = ""
    
    var body: some View {
        HStack {
            Button(action: onDelete, label: {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
            })
            
            if isEditing {
                TextField("Edit Task", text: $editedTaskName, onCommit: {
                    task.taskName = editedTaskName
                    isEditing = false
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onAppear {
                    editedTaskName = task.taskName
                }
                
                Button(action: {
                    isEditing = false
                }) {
                    Text("Done")
                }
                .padding(.horizontal)
            } else {
                HStack{
                    Text(task.taskName)
                    Spacer()
                    Image(systemName: "info.circle")
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    isEditing = true
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Note.self, configurations: config)

        return AddHabitView()
            .environmentObject(HabitsViewModel())
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}


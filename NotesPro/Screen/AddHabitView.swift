//
//  AddHabitView.swift
//  NotesPro
//
//  Created by Jason Susanto on 12/07/24.
//

import SwiftUI
import SwiftData

struct AddHabitView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: HabitsViewModel
    
    @Binding var tasks: [DailyTaskDefinition]
    @Bindable var habit: Habit
    
    @State private var habitName: String
    
    init(habit: Habit) {
        self.habit = habit
        _tasks = .constant(habit.tasks.sorted(by: { $0.createdDate < $1.createdDate }))
        _habitName = State(initialValue: habit.title)
     }
    
    var body: some View {
        NavigationStack{
            VStack(spacing:0) {
                Divider()
                
                Form {
                    HabitNameSection(habitName: $habitName)
                    TasksSection(tasks: $tasks, habit: habit)
                    RewardsSection()
                    IntelligenceSection()
                }
            }
            .navigationTitle(habit.title == "" ? "New Habit" : "Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                    .foregroundColor(.orange)
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        habit.title = habitName
                        viewModel.saveHabit(modelContext: modelContext)
                        dismiss()
                    }, label: {
                        Text("Add")
                    })
                    .foregroundColor(.orange)
                }
            })
        }
        .padding(.top, 10)
    }
}

struct HabitNameSection: View {
    @Binding var habitName: String
    
    var body: some View {
        Section {
            TextField("Enter Habit Name", text: $habitName)
        } header: {
            Text("Habit")
        }
    }
}

struct TasksSection: View {
    @Binding var tasks: [DailyTaskDefinition]
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var viewModel: HabitsViewModel
    
    @State private var newTask: DailyTaskDefinition?
    @State private var showDetailTaskSheet = false
    
    var habit: Habit

    var body: some View {
        Section {
            ForEach(tasks, id: \.self) { task in
                if task.taskName != "" {
                    TaskRow(task: task, habit: habit)
                }
            }
            
            Button(action: {
                newTask = viewModel.addTask(to: habit.id, modelContext: modelContext)
                showDetailTaskSheet = true

            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                        .padding(.trailing, 12)
                    Text("Add Task")
                        .foregroundColor(.appBlack)
                }
            }
        } header: {
            Text("Tasks")
        }
        .sheet(isPresented: $showDetailTaskSheet) {
            if let task = newTask {
                DetailTaskView(task: task).environmentObject(viewModel)
                    .onDisappear(perform: {
                        viewModel.deleteEmptyTasks(from: habit, modelContext: modelContext)
                    })
                    .presentationDragIndicator(.visible) 
            }
        }
    }
}

struct TaskRow: View {
    var task: DailyTaskDefinition
    var habit: Habit
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var viewModel: HabitsViewModel

    var body: some View {
        HStack {
            Image(systemName: "minus.circle.fill")
                .foregroundColor(.red)
                .font(.title3)
                .padding(.trailing, 12)
                .onTapGesture {
                    viewModel.deleteTask(task: task, from: habit, modelContext: modelContext)
                }
            
            NavigationLink(
                destination: DetailTaskView(task: task)
            ) {
                VStack(alignment: .leading) {
                    Text(task.taskName)
                    if task.isReminder {
                        Text("\(task.repeatSchedule) on \(formatTime(task.reminderTime))")
                            .font(.footnote)
                            .opacity(0.6)
                    }
                }
            }
            .contentShape(Rectangle())
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}



struct RewardsSection: View {
    var body: some View {
        Section {
            HStack {
                Button(action: {
                    print("Delete reward")
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                }
                .padding(.trailing, 12)
                Text("Enjoy a cup of tea after reading")
            }
            
            HStack {
                Button(action: {
                    print("Delete reward")
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                }
                .padding(.trailing, 12)
                Text("Add Reward")
            }
        } header: {
            Text("Rewards")
        }
    }
}

struct IntelligenceSection: View {
    var body: some View {
        Section {
            HStack {
                Button(action: {
                    print("Generate habits with AI")
                }) {
                    HStack(spacing: 0) {
                        Text("Generate Habits with AI ")
                        Image(systemName: "sparkles")
                    }
                    .foregroundColor(.orange)
                }
                .padding(.trailing, 12)
            }
        } header: {
            Text("or use Apple Intelligence habit Generator")
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, DailyTaskDefinition.self, configurations: config)
        
        let habit = Habit(title: "Sleeping", description: "Tidur 2 jam")
        let task: [DailyTaskDefinition] = [
            DailyTaskDefinition(taskName: "Example task 1"),
            DailyTaskDefinition(taskName: "Example task 2")
        ]
        
        task.first?.isReminder = true
        task.first?.reminderTime = .now
        task.first?.repeatSchedule = "Everday"
        
        habit.tasks = task
        container.mainContext.insert(habit)
        
        
        return AddHabitView(habit: habit)
            .modelContainer(container)
            .environmentObject(HabitsViewModel())

        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

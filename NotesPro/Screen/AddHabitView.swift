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
    
    @EnvironmentObject private var viewModel: HabitsViewModel
    @State private var habitName: String = ""
    @Binding var tasks: [DailyTaskDefinition]
    var habit: Habit
    
    init(habit: Habit) {
            self.habit = habit
            _tasks = .constant(habit.tasks)
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
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        print("yay")
                    }, label: {
                        Text("Cancel")
                    })
                    .foregroundColor(.orange)
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        print("yay")
                    }, label: {
                        Text("Add")
                    })
                    .foregroundColor(.orange)
                }
            })
        }
        .onAppear(perform: {
            print(habit.id)
        })
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
    var habit: Habit

    var body: some View {
        Section {
            ForEach(tasks, id: \.self) { task in
                TaskRow(task: task, habit: habit)
            }
            
            Button(action: {
                viewModel.addTask(to: habit.id, taskName: "", modelContext: modelContext)
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                        .padding(.trailing, 12)
                    Text("Add Task")
                        .foregroundColor(.black) // Set default text color
                }
            }
        } header: {
            Text("Tasks")
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
            
            NavigationLink(destination: DetailTaskView()) {
                VStack(alignment: .leading) {
                    Text(task.taskName)
                    Text("Everyday on 08.00 PM")
                        .font(.footnote)
                        .opacity(0.6)
                }
            }
            .contentShape(Rectangle())
        }
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
        
        habit.tasks = task
        container.mainContext.insert(habit)
        
        
        return AddHabitView(habit: habit)
            .modelContainer(container)
            .environmentObject(HabitsViewModel())

        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

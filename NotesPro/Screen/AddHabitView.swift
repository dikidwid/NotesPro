// File: /Users/aryadytm/Documents/CS/NotesPro/NotesPro/Screen/AddHabitView.swift

import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddHabitViewModel
    
    @State private var showDetailTaskSheet = false
    @State private var newTask: DailyTaskDefinition?
    
    init(habit: Habit, modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: AddHabitViewModel(habit: habit, modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Divider()
                
                Form {
                    HabitNameSection(habitName: $viewModel.habitName, habitDescription: $viewModel.habitDescription)
                    TasksSection(definedTasks: $viewModel.definedTasks, addTask: addTask, deleteTask: viewModel.deleteTask)
                    RewardsSection(reward: $viewModel.reward, addReward: viewModel.addReward, deleteReward: viewModel.deleteReward)
                    IntelligenceSection()
                }
            }
            .navigationTitle(viewModel.habitName.isEmpty ? "New Habit" : "Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        viewModel.saveHabit()
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
            }
        }
        .padding(.top, 10)
        .sheet(isPresented: $showDetailTaskSheet) {
            if let task = newTask {
//                DetailTaskView(task: task, isNewTask: true)
//                    .onDisappear {
//                        viewModel.deleteEmptyTasks()
//                    }
//                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    private func addTask() {
        newTask = viewModel.addTask()
        showDetailTaskSheet = true
    }
}

struct HabitNameSection: View {
    @Binding var habitName: String
    @Binding var habitDescription: String
    
    var body: some View {
        Section(header: Text("Habit")) {
            TextField("Enter Habit Name", text: $habitName)
            TextField("Enter Habit Description", text: $habitDescription)
        }
    }
}

struct TasksSection: View {
    @Binding var definedTasks: [DailyTaskDefinition]
    let addTask: () -> Void
    let deleteTask: (DailyTaskDefinition) -> Void
    
    var body: some View {
        Section(header: Text("Tasks")) {
            ForEach(definedTasks, id: \.self) { task in
                if !task.taskName.isEmpty {
                    TaskRow(task: task, deleteTask: deleteTask)
                }
            }
            
            Button(action: addTask) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                        .padding(.trailing, 12)
                    Text("Add Task")
                        .foregroundColor(.appBlack)
                }
            }
        }
    }
}

struct TaskRow: View {
    let task: DailyTaskDefinition
    let deleteTask: (DailyTaskDefinition) -> Void
    
    var body: some View {
        HStack {
            Button(action: { deleteTask(task) }) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
                    .font(.title3)
            }
            .padding(.trailing, 12)
            
//            NavigationLink(destination: DetailTaskView(task: task, isNewTask: false)) {
//                VStack(alignment: .leading) {
//                    Text(task.taskName)
//                    if let reminder = task.reminder, reminder.isEnabled {
//                        Text("\(reminder.repeatDays.description) at \(formatTime(reminder.clock))")
//                            .font(.footnote)
//                            .opacity(0.6)
//                    }
//                }
//            }
//            .contentShape(Rectangle())
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

struct RewardsSection: View {
    @Binding var reward: Reward?
    let addReward: () -> Void
    let deleteReward: () -> Void
    
    var body: some View {
        Section(header: Text("Rewards")) {
            if let reward = reward {
                HStack {
                    Button(action: deleteReward) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                            .font(.title3)
                    }
                    .padding(.trailing, 12)
                    Text(reward.rewardName)
                }
            }
            
            Button(action: addReward) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                        .padding(.trailing, 12)
                    Text("Add Reward")
                }
            }
        }
    }
}

struct IntelligenceSection: View {
    var body: some View {
        Section(header: Text("or use Apple Intelligence habit Generator")) {
            Button(action: {
                print("Generate habits with AI")
            }) {
                HStack(spacing: 0) {
                    Text("Generate Habits with AI ")
                    Image(systemName: "sparkles")
                }
                .foregroundColor(.orange)
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, DailyTaskDefinition.self, configurations: config)
        
        let habit = Habit(title: "Sleeping", description: "Tidur 2 jam")
        let tasks: [DailyTaskDefinition] = [
            DailyTaskDefinition(taskName: "Example task 1"),
            DailyTaskDefinition(taskName: "Example task 2")
        ]
        
        tasks.first?.reminder = DailyTaskReminder(isEnabled: true, clock: .now)
        
        habit.definedTasks = tasks
        container.mainContext.insert(habit)
        
        return AddHabitView(habit: habit, modelContext: container.mainContext)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

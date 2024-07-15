//
//  AddHabitView.swift
//  NotesPro
//
//  Created by Jason Susanto on 12/07/24.
//
import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var viewModel: AddHabitViewModel
    
    @Bindable var habit: Habit
    
    @State private var showDetailTaskSheet = false
    @State private var selectedTask: DailyTaskDefinition?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Divider()
                
                Form {
                    HabitNameSection(habitName: $viewModel.habitName, updateHabitName: viewModel.updateHabitName)
                    TasksSection(tasks: habit.definedTasks, viewModel: viewModel, habit: habit, showDetailTaskSheet: $showDetailTaskSheet, selectedTask: $selectedTask)
                    RewardsSection(reward: habit.reward, viewModel: viewModel, habit: habit)
                    IntelligenceSection()
                }
            }
            .navigationTitle(viewModel.habitName.isEmpty ? "New Habit" : "Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Cancel")
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            dismiss()
                        }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Text("Save")
                        .foregroundColor(viewModel.isValidHabit ? .accentColor : .gray)
                        .onTapGesture {
                            if viewModel.isValidHabit {
                                viewModel.saveHabit(habit: habit)
                                dismiss()
                            }
                        }
                }
            }
        }
        .padding(.top, 10)
        .onAppear {
            viewModel.updateModelContext(modelContext)
            viewModel.habitName = habit.title
            viewModel.habitDescription = habit.desc
        }
        .sheet(item: $selectedTask) { task in
            DetailTaskView(task: task, isNewTask: true)
                .onDisappear {
                    viewModel.deleteEmptyTasks(from: habit)
                }
        }
    }
}

struct HabitNameSection: View {
    @Binding var habitName: String
    var updateHabitName: (String) -> Void
    
    var body: some View {
        Section(header: Text("Habit")) {
            TextField("Enter Habit Name", text: $habitName)
                .onChange(of: habitName) { _, newValue in
                    updateHabitName(newValue)
                }
        }
    }
}

struct TasksSection: View {
    let tasks: [DailyTaskDefinition]
    var viewModel: AddHabitViewModel
    var habit: Habit
    @Binding var showDetailTaskSheet: Bool
    @Binding var selectedTask: DailyTaskDefinition?
    
    var body: some View {
        Section(header: Text("Tasks")) {
            ForEach(tasks) { task in
                TaskRow(task: task, viewModel: viewModel, habit: habit, showDetailTaskSheet: $showDetailTaskSheet, selectedTask: $selectedTask)
            }
            
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
                    .font(.title3)
                Text("Add Task")
                    .foregroundColor(.primary)
            }
            .onTapGesture {
                selectedTask = viewModel.addTask(to: habit)
                showDetailTaskSheet = true
            }
        }
    }
}

struct TaskRow: View {
    var task: DailyTaskDefinition
    var viewModel: AddHabitViewModel
    var habit: Habit
    @Binding var showDetailTaskSheet: Bool
    @Binding var selectedTask: DailyTaskDefinition?
    
    var body: some View {
        HStack {
            Image(systemName: "minus.circle.fill")
                .foregroundColor(.red)
                .font(.title3)
                .onTapGesture {
                    viewModel.deleteTask(task, from: habit)
                }
            
            VStack(alignment: .leading) {
                Text(task.taskName)
                if task.reminder.isEnabled {
                    Text(task.reminder.getDescription())
                        .font(.footnote)
                        .opacity(0.6)
                }
            }
            .onTapGesture {
                selectedTask = task
                showDetailTaskSheet = true
            }
        }
        .foregroundColor(.primary)
    }
}

struct RewardsSection: View {
    var reward: Reward?
    var viewModel: AddHabitViewModel
    var habit: Habit
    @State private var isEditing: Bool = false
    @State private var rewardName: String = ""
    
    var body: some View {
        Section(header: Text("Rewards")) {
            if let reward = reward {
                HStack {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                        .onTapGesture {
                            viewModel.deleteReward(from: habit)
                            isEditing = false
                        }
                    
                    if isEditing {
                        TextField("Enter reward name", text: $rewardName)
                            .onSubmit {
                                reward.rewardName = rewardName
                                isEditing = false
                            }
                    } else {
                        Text(reward.rewardName)
                            .onTapGesture {
                                rewardName = reward.rewardName
                                isEditing = true
                            }
                    }
                }
            } else {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(.green)
                    
                    Text("Add Reward")
                        .foregroundColor(.primary)
                }
                .onTapGesture {
                    viewModel.addReward(to: habit)
                    if let newReward = habit.reward {
                        rewardName = newReward.rewardName
                        isEditing = true
                    }
                }
            }
        }
    }
}

struct IntelligenceSection: View {
    var body: some View {
        Section(header: Text("or use AI habit Generator")) {
            Text("Generate Habits with AI")
                .foregroundColor(.accentColor)
                .onTapGesture {
                    print("Generate habits with AI")
                }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, DailyTaskDefinition.self, DailyTaskReminder.self, DailyTaskReminderRepeatDays.self, Reward.self, configurations: config)
        
        let sampleHabit = Habit(title: "Read Books", description: "Read for personal growth")
        
        let task1 = DailyTaskDefinition(taskName: "Read 30 minutes")
        task1.reminder = DailyTaskReminder(isEnabled: true, clock: Date(), repeatDays: DailyTaskReminderRepeatDays(monday: true, wednesday: true, friday: true))
        
        let task2 = DailyTaskDefinition(taskName: "Write summary")
        
        sampleHabit.definedTasks = [task1, task2]
        sampleHabit.reward = Reward(rewardName: "Buy a new book")
        
        container.mainContext.insert(sampleHabit)
        
        let viewModel = AddHabitViewModel(modelContext: container.mainContext)
        
        return AddHabitView(habit: sampleHabit)
            .modelContainer(container)
            .environmentObject(viewModel)
        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

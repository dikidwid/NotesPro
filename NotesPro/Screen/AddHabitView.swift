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
    @EnvironmentObject private var addHabitViewModel: AddHabitViewModel
    @EnvironmentObject private var habitsViewModel: HabitsViewModel
    
    @State private var showDetailTaskSheet = false
    @State private var selectedTask: DailyTaskDefinition?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Divider()
                
                Form {
                    HabitNameSection(habitName: $addHabitViewModel.habitName, updateHabitName: addHabitViewModel.updateHabitName)
                    TasksSection(tasks: addHabitViewModel.definedTasks, viewModel: addHabitViewModel, showDetailTaskSheet: $showDetailTaskSheet, selectedTask: $selectedTask)
                    IntelligenceSection()
                }
            }
            .navigationTitle(habitsViewModel.selectedHabit == nil ? "New Habit" : "Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.accentColor)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        if addHabitViewModel.isValidHabit {
                            addHabitViewModel.saveHabit(modelContext: modelContext, existingHabit: habitsViewModel.selectedHabit)
                            dismiss()
                        }
                    }
                    .foregroundColor(addHabitViewModel.isValidHabit ? .accentColor : .gray)
                }
            }
        }
        .padding(.top, 10)
        .sheet(item: $selectedTask) { task in
            DetailTaskView(task: task, isNewTask: habitsViewModel.selectedHabit == nil)
                .onDisappear {
                    addHabitViewModel.deleteEmptyTasks()
                }
        }
        .sheet(isPresented: $addHabitViewModel.isAIChatSheetPresented) {
            AIChatView()
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
    @Binding var showDetailTaskSheet: Bool
    @Binding var selectedTask: DailyTaskDefinition?
    
    var body: some View {
        Section(header: Text("Tasks")) {
            ForEach(tasks) { task in
                TaskRow(task: task, viewModel: viewModel, showDetailTaskSheet: $showDetailTaskSheet, selectedTask: $selectedTask)
            }
            
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
                    .font(.title3)
                Text("Add Task")
                    .foregroundColor(.primary)
            }
            .onTapGesture {
                selectedTask = viewModel.addTask()
                showDetailTaskSheet = true
            }
        }
    }
}

struct TaskRow: View {
    var task: DailyTaskDefinition
    var viewModel: AddHabitViewModel
    @Binding var showDetailTaskSheet: Bool
    @Binding var selectedTask: DailyTaskDefinition?
    
    var body: some View {
        HStack {
            Image(systemName: "minus.circle.fill")
                .foregroundColor(.red)
                .font(.title3)
                .onTapGesture {
                    viewModel.deleteTask(task)
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



struct IntelligenceSection: View {
    @EnvironmentObject var viewModel: AddHabitViewModel

    var body: some View {
        Section(header: Text("or use AI habit Generator")) {
            Button("Generate Habits with AI") {
                viewModel.showAIChatSheet()
            }
            .foregroundColor(.accentColor)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, DailyTaskDefinition.self, DailyTaskReminder.self, DailyTaskReminderRepeatDays.self, configurations: config)
        
        let sampleHabit = Habit(title: "Read Books", description: "Read for personal growth")
        
        let task1 = DailyTaskDefinition(taskName: "Read 30 minutes")
        task1.reminder = DailyTaskReminder(isEnabled: true, clock: Date(), repeatDays: DailyTaskReminderRepeatDays(monday: true, wednesday: true, friday: true))
        
        let task2 = DailyTaskDefinition(taskName: "Write summary")
        
        sampleHabit.definedTasks = [task1, task2]
        
        container.mainContext.insert(sampleHabit)
        
        let viewModel = AddHabitViewModel()
        viewModel.populateFromHabit(sampleHabit)
        
        return AddHabitView()
            .modelContainer(container)
            .environmentObject(viewModel)
            .environmentObject(HabitsViewModel())
        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

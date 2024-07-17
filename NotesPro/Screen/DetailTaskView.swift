import SwiftUI
import SwiftData

struct DetailTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var task: DailyTaskDefinition
    
    let isNewTask: Bool
    
    init(task: DailyTaskDefinition, isNewTask: Bool) {
        self.task = task
        self.isNewTask = isNewTask
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("TASK")) {
                    TextField("Enter Task Name", text: $task.taskName)
                        .autocorrectionDisabled()
                }
                
                Section(header: Text("REMINDERS")) {
                    Toggle("Reminder", isOn: $task.isReminderEnabled)
                    
                    if task.isReminderEnabled {
                        DatePicker("Time", selection: $task.reminderClock, displayedComponents: .hourAndMinute)
                        
                        RepeatDaysMenu(task: task)
                    }
                }
            }
            .navigationTitle(isNewTask ? "Task Details" : "Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Back")
                        }
                    }
                    .foregroundColor(.accentColor)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if isNewTask {
                        Button("Save") {
                            try? modelContext.save()
                            dismiss()
                        }
                        .foregroundColor(.accentColor)
                    }
                }
            }
        }
    }
}

struct RepeatDaysMenu: View {
    @Bindable var task: DailyTaskDefinition
    @State private var showMenu = false
    
    var body: some View {
        Menu {
            Button(action: {
                task.sundayReminder = true
                task.mondayReminder = true
                task.tuesdayReminder = true
                task.wednesdayReminder = true
                task.thursdayReminder = true
                task.fridayReminder = true
                task.saturdayReminder = true
            }) {
                Label("Everyday", systemImage: isEveryday() ? "checkmark" : "")
            }
            
            Divider()
            
            Button(action: { task.sundayReminder.toggle() }) {
                Label("Sunday", systemImage: task.sundayReminder ? "checkmark" : "")
            }
            Button(action: { task.mondayReminder.toggle() }) {
                Label("Monday", systemImage: task.mondayReminder ? "checkmark" : "")
            }
            Button(action: { task.tuesdayReminder.toggle() }) {
                Label("Tuesday", systemImage: task.tuesdayReminder ? "checkmark" : "")
            }
            Button(action: { task.wednesdayReminder.toggle() }) {
                Label("Wednesday", systemImage: task.wednesdayReminder ? "checkmark" : "")
            }
            Button(action: { task.thursdayReminder.toggle() }) {
                Label("Thursday", systemImage: task.thursdayReminder ? "checkmark" : "")
            }
            Button(action: { task.fridayReminder.toggle() }) {
                Label("Friday", systemImage: task.fridayReminder ? "checkmark" : "")
            }
            Button(action: { task.saturdayReminder.toggle() }) {
                Label("Saturday", systemImage: task.saturdayReminder ? "checkmark" : "")
            }
        } label: {
            HStack {
                Text("Repeat")
                    .foregroundColor(.primary)
                Spacer()
                Text(getRepeatDescription())
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func isEveryday() -> Bool {
        return task.sundayReminder && task.mondayReminder && task.tuesdayReminder && task.wednesdayReminder && task.thursdayReminder && task.fridayReminder && task.saturdayReminder
    }
    
    private func getRepeatDescription() -> String {
        if isEveryday() {
            return "Everyday"
        }
        
        let days = [
            (day: "Sun", isSelected: task.sundayReminder),
            (day: "Mon", isSelected: task.mondayReminder),
            (day: "Tue", isSelected: task.tuesdayReminder),
            (day: "Wed", isSelected: task.wednesdayReminder),
            (day: "Thu", isSelected: task.thursdayReminder),
            (day: "Fri", isSelected: task.fridayReminder),
            (day: "Sat", isSelected: task.saturdayReminder)
        ]
        
        let selectedDays = days.filter { $0.isSelected }.map { $0.day }
        
        if selectedDays.isEmpty {
            return "Never"
        } else {
            return selectedDays.joined(separator: ", ")
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: DailyTaskDefinition.self, configurations: config)
        
        let sampleTask = DailyTaskDefinition(taskName: "Meditate for 10 minutes")
        sampleTask.isReminderEnabled = true
        sampleTask.reminderClock = Calendar.current.date(from: DateComponents(hour: 7, minute: 0)) ?? Date()
        container.mainContext.insert(sampleTask)
        return DetailTaskView(task: sampleTask, isNewTask: false)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

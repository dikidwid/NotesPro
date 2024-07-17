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
                }
                
                Section(header: Text("REMINDERS")) {
                    Toggle("Reminder", isOn: $task.reminder.isEnabled)
                    
                    if task.reminder.isEnabled {
                        DatePicker("Time", selection: $task.reminder.clock, displayedComponents: .hourAndMinute)
                        
                        RepeatDaysMenu(repeatDays: $task.reminder.repeatDays)
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
    @Binding var repeatDays: DailyTaskReminderRepeatDays
    @State private var showMenu = false
    
    var body: some View {
        Menu {
            Button(action: {
                repeatDays.sunday = true
                repeatDays.monday = true
                repeatDays.tuesday = true
                repeatDays.wednesday = true
                repeatDays.thursday = true
                repeatDays.friday = true
                repeatDays.saturday = true
            }) {
                Label("Everyday", systemImage: isEveryday() ? "checkmark" : "")
            }
            
            Divider()
            
            Button(action: { repeatDays.sunday.toggle() }) {
                Label("Sunday", systemImage: repeatDays.sunday ? "checkmark" : "")
            }
            Button(action: { repeatDays.monday.toggle() }) {
                Label("Monday", systemImage: repeatDays.monday ? "checkmark" : "")
            }
            Button(action: { repeatDays.tuesday.toggle() }) {
                Label("Tuesday", systemImage: repeatDays.tuesday ? "checkmark" : "")
            }
            Button(action: { repeatDays.wednesday.toggle() }) {
                Label("Wednesday", systemImage: repeatDays.wednesday ? "checkmark" : "")
            }
            Button(action: { repeatDays.thursday.toggle() }) {
                Label("Thursday", systemImage: repeatDays.thursday ? "checkmark" : "")
            }
            Button(action: { repeatDays.friday.toggle() }) {
                Label("Friday", systemImage: repeatDays.friday ? "checkmark" : "")
            }
            Button(action: { repeatDays.saturday.toggle() }) {
                Label("Saturday", systemImage: repeatDays.saturday ? "checkmark" : "")
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
        return repeatDays.sunday && repeatDays.monday && repeatDays.tuesday && repeatDays.wednesday && repeatDays.thursday && repeatDays.friday && repeatDays.saturday
    }
    
    private func getRepeatDescription() -> String {
        if isEveryday() {
            return "Everyday"
        }
        
        let days = [
            (day: "Sun", isSelected: repeatDays.sunday),
            (day: "Mon", isSelected: repeatDays.monday),
            (day: "Tue", isSelected: repeatDays.tuesday),
            (day: "Wed", isSelected: repeatDays.wednesday),
            (day: "Thu", isSelected: repeatDays.thursday),
            (day: "Fri", isSelected: repeatDays.friday),
            (day: "Sat", isSelected: repeatDays.saturday)
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
        let config = ModelConfiguration(isStoredInMemoryOnly: false)
        let container = try ModelContainer(for: DailyTaskDefinition.self, DailyTaskReminder.self, DailyTaskReminderRepeatDays.self, configurations: config)
        
        let sampleTask = DailyTaskDefinition(taskName: "Meditate for 10 minutes")
        sampleTask.reminder = DailyTaskReminder(
            isEnabled: true,
            clock: Calendar.current.date(from: DateComponents(hour: 7, minute: 0)) ?? Date(),
            repeatDays: DailyTaskReminderRepeatDays()
        )
        container.mainContext.insert(sampleTask)
        return DetailTaskView(task: sampleTask, isNewTask: false)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

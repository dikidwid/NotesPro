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
    
    private let localizedDays: [(day: String, isSelected: KeyPath<DailyTaskDefinition, Bool>)] = [
        (day: NSLocalizedString("Sun", comment: "Sunday"), isSelected: \DailyTaskDefinition.sundayReminder),
        (day: NSLocalizedString("Mon", comment: "Monday"), isSelected: \DailyTaskDefinition.mondayReminder),
        (day: NSLocalizedString("Tue", comment: "Tuesday"), isSelected: \DailyTaskDefinition.tuesdayReminder),
        (day: NSLocalizedString("Wed", comment: "Wednesday"), isSelected: \DailyTaskDefinition.wednesdayReminder),
        (day: NSLocalizedString("Thu", comment: "Thursday"), isSelected: \DailyTaskDefinition.thursdayReminder),
        (day: NSLocalizedString("Fri", comment: "Friday"), isSelected: \DailyTaskDefinition.fridayReminder),
        (day: NSLocalizedString("Sat", comment: "Saturday"), isSelected: \DailyTaskDefinition.saturdayReminder)
    ]
    
    var body: some View {
        Menu {
            Button(action: {
                updateToEveryday()
            }) {
                Label(NSLocalizedString("Everyday", comment: "Everyday"), systemImage: isEveryday() ? "checkmark" : "")
            }
            
            Divider()
            
            Button(action: {
                task.sundayReminder.toggle()
                if !anyDaySelected() { updateToEveryday() }
            }) {
                Label("Sunday", systemImage: task.sundayReminder ? "checkmark" : "")
            }
            
            Button(action: {
                task.mondayReminder.toggle()
                if !anyDaySelected() { updateToEveryday() }
            }) {
                Label("Monday", systemImage: task.mondayReminder ? "checkmark" : "")
            }
            
            Button(action: {
                task.tuesdayReminder.toggle()
                if !anyDaySelected() { updateToEveryday() }
            }) {
                Label("Sunday", systemImage: task.tuesdayReminder ? "checkmark" : "")
            }
            
            Button(action: {
                task.wednesdayReminder.toggle()
                if !anyDaySelected() { updateToEveryday() }
            }) {
                Label("Monday", systemImage: task.wednesdayReminder ? "checkmark" : "")
            }
            
            Button(action: {
                task.thursdayReminder.toggle()
                if !anyDaySelected() { updateToEveryday() }
            }) {
                Label("Monday", systemImage: task.thursdayReminder ? "checkmark" : "")
            }
            
            Button(action: {
                task.fridayReminder.toggle()
                if !anyDaySelected() { updateToEveryday() }
            }) {
                Label("Sunday", systemImage: task.fridayReminder ? "checkmark" : "")
            }
            
            Button(action: {
                task.saturdayReminder.toggle()
                if !anyDaySelected() { updateToEveryday() }
            }) {
                Label("Monday", systemImage: task.saturdayReminder ? "checkmark" : "")
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
    
    private func anyDaySelected() -> Bool {
        return localizedDays.contains { task[keyPath: $0.isSelected] }
    }
    
    private func updateToEveryday() {
        task.sundayReminder = true
        task.mondayReminder = true
        task.tuesdayReminder = true
        task.wednesdayReminder = true
        task.thursdayReminder = true
        task.fridayReminder = true
        task.saturdayReminder = true
    }
    
    private func getRepeatDescription() -> String {
        if !anyDaySelected() {
            updateToEveryday()
        }
        
        if isEveryday() {
            return NSLocalizedString("Everyday", comment: "Everyday")
        }
        
        let selectedDays = localizedDays.filter { task[keyPath: $0.isSelected] }.map { $0.day }
        return selectedDays.joined(separator: ", ")
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

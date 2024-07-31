import SwiftUI
import SwiftData

struct DetailTaskView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var detailTaskViewModel: DetailTaskViewModel
    let onSaveTapped: ((TaskModel) -> Void?)
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("TASK NAME")) {
                    TextField("Enter Task Name", text: $detailTaskViewModel.selectedTask.taskName)
                        .autocorrectionDisabled()
                }
                
                Section(header: Text("REMINDERS")) {
                    Toggle("Reminder", isOn: $detailTaskViewModel.selectedTask.isReminderEnabled)
                    
                    if detailTaskViewModel.selectedTask.isReminderEnabled {
                        DatePicker("Time", selection: $detailTaskViewModel.selectedTask.reminderTime, displayedComponents: .hourAndMinute)
                        
                        RepeatDaysMenu(detailTaskViewModel: detailTaskViewModel)
                    }
                }
            }
            .navigationTitle("Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Back")
                        }
                    }
                    .foregroundColor(.accentColor)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSaveTapped(detailTaskViewModel.selectedTask)
//                        addHabitViewModel.saveTask(detailTaskViewModel.selectedTask)
                        dismiss()
                    }
                    .foregroundColor(.accentColor)
                    
                }
            }
        }
    }
}

final class DetailTaskViewModel: ObservableObject {
    @Published var selectedTask: TaskModel
    
    init(selectedTask: TaskModel) {
        self.selectedTask = selectedTask
    }
    
    enum Weekday: String, CaseIterable {
        case sunday = "Sunday"
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
    }
    
    var isEveryday: Bool {
        return selectedTask.isSundayReminderOn &&
        selectedTask.isMondayReminderOn &&
        selectedTask.isTuesdayReminderOn &&
        selectedTask.isWednesdayReminderOn &&
        selectedTask.isThursdayReminderOn &&
        selectedTask.isFridayReminderOn &&
        selectedTask.isSaturdayReminderOn
    }
    
    var reminderLabel: String {
        if isEveryday {
            return "Everyday"
        }
        
        let days = [
            (day: "Sun", isSelected: selectedTask.isSundayReminderOn),
            (day: "Mon", isSelected: selectedTask.isMondayReminderOn),
            (day: "Tue", isSelected: selectedTask.isTuesdayReminderOn),
            (day: "Wed", isSelected: selectedTask.isWednesdayReminderOn),
            (day: "Thu", isSelected: selectedTask.isThursdayReminderOn),
            (day: "Fri", isSelected: selectedTask.isFridayReminderOn),
            (day: "Sat", isSelected: selectedTask.isSaturdayReminderOn)
        ]
        
        let selectedDays = days.filter { $0.isSelected }.map { $0.day }
        
        if selectedDays.isEmpty {
            return "Never"
        } else {
            return selectedDays.joined(separator: ", ")
        }
    }
    
    var reminderDescription: String {
        if !selectedTask.isReminderEnabled {
            return ""
        }
        
        let days = [
            (day: "Sun", isSelected: selectedTask.isSundayReminderOn),
            (day: "Mon", isSelected: selectedTask.isMondayReminderOn),
            (day: "Tue", isSelected: selectedTask.isTuesdayReminderOn),
            (day: "Wed", isSelected: selectedTask.isWednesdayReminderOn),
            (day: "Thu", isSelected: selectedTask.isThursdayReminderOn),
            (day: "Fri", isSelected: selectedTask.isFridayReminderOn),
            (day: "Sat", isSelected: selectedTask.isSaturdayReminderOn)
        ]
        
        let selectedDays = days.filter { $0.isSelected }.map { $0.day }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let timeString = timeFormatter.string(from: selectedTask.reminderTime)
        
        if selectedDays.count == 7 {
            return "Everyday at \(timeString)"
        } else if selectedDays.count == 1 {
            return "Every \(selectedDays[0]) at \(timeString)"
        } else {
            return selectedDays.joined(separator: ", ") + " at \(timeString)"
        }
    }
    
    func toggleReminder(for day: Weekday) {
        switch day {
        case .sunday:
            selectedTask.isSundayReminderOn.toggle()
        case .monday:
            selectedTask.isMondayReminderOn.toggle()
        case .tuesday:
            selectedTask.isTuesdayReminderOn.toggle()
        case .wednesday:
            selectedTask.isWednesdayReminderOn.toggle()
        case .thursday:
            selectedTask.isThursdayReminderOn.toggle()
        case .friday:
            selectedTask.isFridayReminderOn.toggle()
        case .saturday:
            selectedTask.isSaturdayReminderOn.toggle()
        }
    }

    func toggleReminderForEveryday() {
        selectedTask.isSundayReminderOn.toggle()
        selectedTask.isMondayReminderOn.toggle()
        selectedTask.isTuesdayReminderOn.toggle()
        selectedTask.isWednesdayReminderOn.toggle()
        selectedTask.isThursdayReminderOn.toggle()
        selectedTask.isFridayReminderOn.toggle()
        selectedTask.isSaturdayReminderOn.toggle()
    }
    
    func iconReminder(for day: Weekday) -> String {
        switch day {
        case .sunday:
            return selectedTask.isSundayReminderOn ? "checkmark" : ""
        case .monday:
            return selectedTask.isMondayReminderOn ? "checkmark" : ""
        case .tuesday:
            return selectedTask.isTuesdayReminderOn ? "checkmark" : ""
        case .wednesday:
            return selectedTask.isWednesdayReminderOn ? "checkmark" : ""
        case .thursday:
            return selectedTask.isThursdayReminderOn ? "checkmark" : ""
        case .friday:
            return selectedTask.isFridayReminderOn ? "checkmark" : ""
        case .saturday:
            return selectedTask.isSaturdayReminderOn ? "checkmark" : ""
        }
    }
}

struct RepeatDaysMenu: View {
    @ObservedObject var detailTaskViewModel: DetailTaskViewModel
    
    var body: some View {
        Menu {
            Button {
                detailTaskViewModel.toggleReminderForEveryday()
                
            } label: {
                Label("Everyday", systemImage: detailTaskViewModel.isEveryday ? "checkmark" : "")
            }
            
            Divider()
            
            ForEach(DetailTaskViewModel.Weekday.allCases, id: \.self) { day in
                Button(action: { detailTaskViewModel.toggleReminder(for: day) }) {
                    Label(day.rawValue, systemImage: detailTaskViewModel.iconReminder(for: day))
                }
            }
        } label: {
            HStack {
                Text("Repeat")
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(detailTaskViewModel.reminderLabel)
                    .foregroundColor(.secondary)
            }
        }
    }
}

//#Preview {
//    DetailTaskView(detailTaskViewModel: DetailTaskViewModel(), 
//                   addHabitViewModel: <#AddHabitViewModell#>)
//}

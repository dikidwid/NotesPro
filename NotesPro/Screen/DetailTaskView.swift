import SwiftUI
import SwiftData

struct DetailTaskView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var addHabitViewModel: AddHabitViewModell
    @ObservedObject var detailTaskViewModel: DetailTaskViewModel
    
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
                
                Section(header: Text("Sync to Calendar")) {
                    Toggle("Sync to Calendar", isOn: $detailTaskViewModel.syncToCalendar)
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
                        addHabitViewModel.saveTask(detailTaskViewModel.selectedTask)
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
    
    @Published var isReminderEnabled: Bool = false
    @Published var reminderDate: Date = .now
        
    @Published var isSundayReminderOn: Bool = false
    @Published var isMondayReminderOn: Bool = false
    @Published var isTuesdayReminderOn: Bool = false
    @Published var isWednesdayReminderOn: Bool = false
    @Published var isThursdayReminderOn: Bool = false
    @Published var isFridayReminderOn: Bool = false
    @Published var isSaturdayReminderOn: Bool = false
    
    @Published var syncToCalendar: Bool = false
    
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
        return isSundayReminderOn &&
        isMondayReminderOn &&
        isTuesdayReminderOn &&
        isWednesdayReminderOn &&
        isThursdayReminderOn &&
        isFridayReminderOn &&
        isSaturdayReminderOn
    }
    
    var reminderLabel: String {
        if isEveryday {
            return "Everyday"
        }
        
        let days = [
            (day: "Sun", isSelected: isSundayReminderOn),
            (day: "Mon", isSelected: isMondayReminderOn),
            (day: "Tue", isSelected: isTuesdayReminderOn),
            (day: "Wed", isSelected: isWednesdayReminderOn),
            (day: "Thu", isSelected: isThursdayReminderOn),
            (day: "Fri", isSelected: isFridayReminderOn),
            (day: "Sat", isSelected: isSaturdayReminderOn)
        ]
        
        let selectedDays = days.filter { $0.isSelected }.map { $0.day }
        
        if selectedDays.isEmpty {
            return "Never"
        } else {
            return selectedDays.joined(separator: ", ")
        }
    }
    
    var reminderDescription: String {
        if !isReminderEnabled {
            return ""
        }
        
        let days = [
            (day: "Sun", isSelected: isSundayReminderOn),
            (day: "Mon", isSelected: isMondayReminderOn),
            (day: "Tue", isSelected: isTuesdayReminderOn),
            (day: "Wed", isSelected: isWednesdayReminderOn),
            (day: "Thu", isSelected: isThursdayReminderOn),
            (day: "Fri", isSelected: isFridayReminderOn),
            (day: "Sat", isSelected: isSaturdayReminderOn)
        ]
        
        let selectedDays = days.filter { $0.isSelected }.map { $0.day }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let timeString = timeFormatter.string(from: reminderDate)
        
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
            isSundayReminderOn.toggle()
        case .monday:
            isMondayReminderOn.toggle()
        case .tuesday:
            isTuesdayReminderOn.toggle()
        case .wednesday:
            isWednesdayReminderOn.toggle()
        case .thursday:
            isThursdayReminderOn.toggle()
        case .friday:
            isFridayReminderOn.toggle()
        case .saturday:
            isSaturdayReminderOn.toggle()
        }
    }

    func toggleReminderForEveryday() {
       isSundayReminderOn.toggle()
       isMondayReminderOn.toggle()
       isTuesdayReminderOn.toggle()
       isWednesdayReminderOn.toggle()
       isThursdayReminderOn.toggle()
       isFridayReminderOn.toggle()
       isSaturdayReminderOn.toggle()
    }
    
    func iconReminder(for day: Weekday) -> String {
        switch day {
        case .sunday:
            return isSundayReminderOn ? "checkmark" : ""
        case .monday:
            return isMondayReminderOn ? "checkmark" : ""
        case .tuesday:
            return isTuesdayReminderOn ? "checkmark" : ""
        case .wednesday:
            return isWednesdayReminderOn ? "checkmark" : ""
        case .thursday:
            return isThursdayReminderOn ? "checkmark" : ""
        case .friday:
            return isFridayReminderOn ? "checkmark" : ""
        case .saturday:
            return isSaturdayReminderOn ? "checkmark" : ""
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

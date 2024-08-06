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
                        dismiss()
                    }
                    .foregroundColor(.accentColor)
                    
                }
            }
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

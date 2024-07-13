//
//  DetailTaskView.swift
//  NotesPro
//
//  Created by Jason Susanto on 13/07/24.
//

import SwiftUI

struct DetailTaskView: View {
    
    @State private var taskName: String = ""
    @State private var isReminder: Bool = false
    
    @State private var selectedTime = Date()
    @State private var repeatOptions = ["Everyday", "Every Monday", "Every Tuesday", "Every Wednesday", "Every Thursday", "Every Friday", "Every Saturday", "Every Sunday"]
    @State private var selectedRepeatOption = 0
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Divider()
                Form(content: {
                    Section {
                        TextField("Enter Task Name", text: $taskName)
                    } header: {
                        Text("TASK")
                    }
                    
                    Section {
                        Toggle(isOn: $isReminder, label: {
                            Text("Reminder")
                        })
                        if isReminder {
                            DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                            
                            Picker(selection: $selectedRepeatOption, label: Text("Repeat")) {
                                ForEach(repeatOptions.indices, id: \.self) { index in
                                    Text(repeatOptions[index])
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    } header: {
                        Text("Reminders")
                            .textCase(.uppercase)
                    }
                    
                    
                })
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.backward")
                                .font(.subheadline)
                            Text("Back")
                        }
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
    }
}

#Preview {
    DetailTaskView()
}

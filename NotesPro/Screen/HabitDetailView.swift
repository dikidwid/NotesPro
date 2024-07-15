//
//  HabitDetailView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 14/07/24.
//

import SwiftUI
import SwiftData

struct HabitDetailView: View {
    @ObservedObject var viewModel: NotesViewModel
    let habit: Habit
    
    var body: some View {
        VStack {
            DatePicker("Date", selection: .constant(.now), displayedComponents: .date)
                .padding()
                .background(.white)
            
            HStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.background)
                    .frame(width: 175, height: 83)
                    .overlay {
                        VStack {
                            HStack {
                                Image(systemName: "trophy.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundStyle(.orange)
                                
                                Spacer()
                                
                                Text("102")
                                    .font(.system(.title, weight: .bold))
                            }
                            
                            Spacer()
                            
                            Text("Best Habit Streak")
                                .font(.system(.body, weight: .semibold))
                                .foregroundStyle(.secondary)

                        }
                        .padding()

                    }
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(.background)
                    .frame(width: 175, height: 83)
                    .overlay {
                        VStack {
                            HStack {
                                Image(systemName: "flame.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundStyle(.secondary)
                                
                                Spacer()
                                
                                Text("102")
                                    .font(.system(.title, weight: .bold))
                            }
                            
                            Spacer()
                            
                            Text("Best Habit Streak")
                                .font(.system(.body, weight: .semibold))
                                .foregroundStyle(.secondary)

                        }
                        .padding()

                    }

            }
            .overlay(alignment: .topLeading) {
                Text("Overview")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .offset(x: 24 ,y: -20)
            }
            .padding(.top, 24)
            .padding(.horizontal, 18)
            
            List {
                Section("Tasks") {
                    CheckboxTaskView(isShowReminderTime: true, task: DailyTask(taskName: "Read the book for 5 minutes"), viewModel: viewModel)
                    
                    CheckboxTaskView(isShowReminderTime: true, task: DailyTask(taskName: "Take note important things"), viewModel: viewModel)
                }
                
                Section("How do you feel?") {
                    TextField("Happy", text: .constant(""))
                }
                
                Section("What you can learn from today?") {
                    TextField("I will do better next time", text: .constant(""))
                }
            }
            .scrollDisabled(true)
        }
        .navigationTitle(habit.title)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "wand.and.stars")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "pencil")
                }
            }
        }
    }
}

struct CheckboxTaskView: View {
    let isShowReminderTime: Bool
    @Bindable var task: DailyTask
    @ObservedObject var viewModel: NotesViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: task.isChecked ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(task.isChecked ? .accent : .secondary)
                .font(.title3)
                .fontWeight(.semibold)
                .contentTransition(.symbolEffect(.replace))
                .onTapGesture {
                    viewModel.toggleTask(task)
                }
            
            
            VStack(alignment: .leading, spacing: 6) {
                Text(task.taskName)
                    .font(.system(.body))
                    .foregroundStyle(task.isChecked ? Color.secondary : .black)
                
                if isShowReminderTime {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        
                        Text("08.00")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    
                }
            }
            .strikethrough(task.isChecked)

        }
        .background(Color(.systemBackground))
    }
}

#Preview("Habit Detail") {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: DailyTask.self, configurations: config)
        
        return NavigationStack {
            HabitDetailView(viewModel: NotesViewModel(), habit: Habit(title: "Reading Habit", description: "This is description for reading habit"))
                .modelContainer(container)
            
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

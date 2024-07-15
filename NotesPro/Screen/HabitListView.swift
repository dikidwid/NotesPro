//
//  HabitListView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 15/07/24.
//

import SwiftUI
import SwiftData
struct HabitListView: View {
    @Query(sort: \Habit.title) var habits: [Habit]
    @ObservedObject var viewModel: NotesViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Overview cards
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
                .padding(.top, 24)
                .padding(.horizontal, 18)
                
                // Habits List
                ForEach(habits) { habit in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.background)
                        .overlay {
                            VStack(alignment: .leading) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(habit.title)
                                            .font(.system(.headline))
                                        
                                        Text("\(habit.definedTasks.count) Tasks to do")
                                            .font(.system(.subheadline))
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Text("Detail")
                                        
                                        Image(systemName: "chevron.right")
                                    }
                                    .foregroundStyle(.secondary)
                                }
                                
                                Divider()
                                    .padding(.all, 5)
                                
                                if let todayEntry = habit.dailyHabitEntries.first(where: { Calendar.current.isDateInToday($0.day) }) {
                                    ForEach(todayEntry.tasks) { task in
                                        TaskCheckboxView(viewModel: viewModel, task: task)
                                    }
                                } else {
                                    Text("No tasks for today")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding()
                        }
                        .frame(height: 170)
                        .padding(.horizontal)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
        }
    }
}



struct TaskCheckboxView: View {
    @ObservedObject var viewModel: NotesViewModel
    let task: DailyTask
    
    var body: some View {
        HStack {
            Button(action: {
                viewModel.toggleTask(task)
            }) {
                Image(systemName: task.isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(task.isChecked ? .blue : .secondary)
            }
            VStack(alignment: .leading) {
                Text(task.taskName)
                Text("08:00")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, DailyHabitEntry.self, DailyTask.self, DailyTaskDefinition.self, configurations: config)
        
        let habit1 = Habit(title: "Reading Habit", description: "This is description of the reading habit")
        let habit2 = Habit(title: "Writing Habit", description: "This is description of the writing habit")
        
        let readingTask1 = DailyTaskDefinition(taskName: "Read the book for 5 minutes")
        let readingTask2 = DailyTaskDefinition(taskName: "Enjoy a cup of tea after reading")
        habit1.definedTasks = [readingTask1, readingTask2]
        
        let writingTask1 = DailyTaskDefinition(taskName: "Write for 10 minutes")
        let writingTask2 = DailyTaskDefinition(taskName: "Review what you've written")
        habit2.definedTasks = [writingTask1, writingTask2]
        
        let today = Date()
        let readingEntry = DailyHabitEntry(day: today)
        readingEntry.habit = habit1
        readingEntry.tasks = [
            DailyTask(taskName: readingTask1.taskName),
            DailyTask(taskName: readingTask2.taskName)
        ]
        habit1.dailyHabitEntries = [readingEntry]
        
        let writingEntry = DailyHabitEntry(day: today)
        writingEntry.habit = habit2
        writingEntry.tasks = [
            DailyTask(taskName: writingTask1.taskName),
            DailyTask(taskName: writingTask2.taskName)
        ]
        habit2.dailyHabitEntries = [writingEntry]
        
        container.mainContext.insert(habit1)
        container.mainContext.insert(habit2)
        
        return NavigationStack {
            HabitListView(viewModel: NotesViewModel())
                .modelContainer(container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

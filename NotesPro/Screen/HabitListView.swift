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
                                        
                                        Text("2 Tasks to do")
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
                                                                
                                ForEach(habit.dailyHabitEntries) { dailyHabitEntries in
                                    ForEach(dailyHabitEntries.tasks) { task in
                                        CheckboxTaskView(isShowReminderTime: false,
                                                                                             task: task,
                                                                                             viewModel: viewModel)                                    }
//                                    Text(task.day)
//                                    Text(task.title ?? "dwd")
//                                    CheckboxTaskView(isShowReminderTime: false,
//                                                     task: task,
//                                                     viewModel: viewModel)
                                    
//                                    print(task)
                                }
                                
                            }
                            .padding()
                        }
                        .frame(height: 170)
                        .padding(.horizontal)
                }
                
//                // Reading Habit
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(.background)
//                    .overlay {
//                        VStack(alignment: .leading) {
//                            HStack {
//                                VStack(alignment: .leading) {
//                                    Text("Reading Habit")
//                                        .font(.system(.headline))
//                                    
//                                    Text("2 Tasks to do")
//                                        .font(.system(.subheadline))
//                                        .foregroundStyle(.secondary)
//                                }
//                                
//                                Spacer()
//                                
//                                HStack {
//                                    Text("Detail")
//                                    
//                                    Image(systemName: "chevron.right")
//                                }
//                                .foregroundStyle(.secondary)
//                            }
//                            
//                            Divider()
//                                .padding(.all, 5)
//                            
////                            CheckboxTaskView(isShowReminderTime: false, task: DailyTask(taskName: "Read the book for 5 minutes"), viewModel: viewModel)
////                            
////                            Divider()
////                                .padding(.vertical, 5)
////                                .padding(.leading, 40)
////
////                            CheckboxTaskView(isShowReminderTime: false, task: DailyTask(taskName: "Enjoy a cup of tea after reading"), viewModel: viewModel)
//                            
//                        }
//                        .padding()
//                    }
//                    .frame(height: 170)
//                    .padding(.horizontal)
                
                // Writing Habit
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(.background)
//                    .overlay {
//                        VStack(alignment: .leading) {
//                            HStack {
//                                VStack(alignment: .leading) {
//                                    Text("Writing Habit")
//                                        .font(.system(.headline))
//                                    
//                                    Text("1 of 2 Task Done")
//                                        .font(.system(.subheadline))
//                                        .foregroundStyle(.secondary)
//                                }
//                                
//                                Spacer()
//                                
//                                HStack {
//                                    Text("Detail")
//                                    
//                                    Image(systemName: "chevron.right")
//                                }
//                                .foregroundStyle(.secondary)
//                            }
//                            
//                            Divider()
//                                .padding(.all, 5)
//                            
////                            CheckboxTaskView(isShowReminderTime: false, task: DailyTask(taskName: "Enjoy a cup of tea after reading"), viewModel: viewModel)
////                            
//                        }
//                        .padding()
//                    }
//                    .frame(height: 120)
//                    .padding(.horizontal)
                
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(.background)
//                    .overlay {
//                        VStack(alignment: .leading) {
//                            HStack {
//                                VStack(alignment: .leading) {
//                                    Text("Speaking Habit")
//                                        .font(.system(.headline))
//                                    
//                                    Text("All task done, write reflection")
//                                        .font(.system(.subheadline))
//                                        .foregroundStyle(.secondary)
//                                }
//                                
//                                Spacer()
//                                
//                                HStack {
//                                    Text("Detail")
//                                    
//                                    Image(systemName: "chevron.right")
//                                }
//                                .foregroundStyle(.secondary)
//                            }
//                            
//                        }
//                        .padding()
//                    }
//                    .frame(height: 70)
//                    .padding(.horizontal)
//                
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(.background)
//                    .overlay {
//                        VStack(alignment: .leading) {
//                            HStack {
//                                VStack(alignment: .leading) {
//                                    Text("Running Habit")
//                                        .font(.system(.headline))
//                                    
//                                    Text("All task done, write reflection")
//                                        .font(.system(.subheadline))
//                                        .foregroundStyle(.secondary)
//                                }
//                                
//                                Spacer()
//                                
//                                HStack {
//                                    Text("Detail")
//                                    
//                                    Image(systemName: "chevron.right")
//                                }
//                                .foregroundStyle(.secondary)
//                            }
//                            
//                        }
//                        .padding()
//                    }
//                    .frame(height: 70)
//                    .padding(.horizontal)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, configurations: config)
        
        let habits: [Habit] =
        [
            Habit(title: "Reading Habit", description: "This is description of the habit"),
        ]
        
        var readingHabitTask1: DailyTask = DailyTask(taskName: "Read the book for 5 minutes")
        var readingHabitEntry: DailyHabitEntry = DailyHabitEntry(day: Date())
        var definedTask = DailyTaskDefinition(taskName: readingHabitTask1.taskName)
        
        habits[0].dailyHabitEntries = [readingHabitEntry]
        habits[0].definedTasks = [definedTask]

        readingHabitEntry.habit = habits[0]
        
        for habit in habits {
            container.mainContext.insert(habit)
        }
        
//        container.mainContext.insert(readingHabitTask1)
        
        return NavigationStack {
            HabitListView(viewModel: NotesViewModel())
                .modelContainer(container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
    
}

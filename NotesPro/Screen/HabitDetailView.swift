//
//  HabitDetailView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 14/07/24.
//

import SwiftUI
import SwiftData

struct HabitDetailView: View {
    let habit: Habit
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var noteViewModel: NotesViewModel
    
    @State private var note = ""
    
    var body: some View {
        ScrollView {
            VStack {
                StreakCardView(bestTreak: 40, currentStreak: 3)
                    .padding(.top)
                
                CalendarView(viewModel: calendarViewModel)
                    .padding(.top)
                
                Divider()
                
                if habit.isTaskEmpty(for: calendarViewModel.currentDate) {
                    Text("You don't have any specific task for this habit")
                        .font(.system(.subheadline))
                        .foregroundStyle(.secondary)
                        .padding(.vertical)
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(habit.tasks(for: calendarViewModel.currentDate)) { task in
                            CheckboxTaskView(isShowReminderTime: false, task: task, viewModel: noteViewModel)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                    .padding(.horizontal, 32)
                }
                
                Divider()
                
                Text(calendarViewModel.currentDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(.caption2))
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 10)
                
                TextField("Add Note", text: $note, axis: .vertical)
                    .padding(.horizontal, 24)
                    .padding(.bottom)
                    .autocorrectionDisabled()
            }
            .navigationTitle(habit.title)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button {
                            
                        } label: {
                            Image(systemName: "checklist")
                        }
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "camera")
                        }
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "pencil.tip.crop.circle")
                        }
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "pencil.line")
                        }
                    }
                }
            }
        }
    }
}

struct StreakCardView: View {
    let bestTreak: Int
    let currentStreak: Int
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 1)
                .fill(.secondary)
                .frame(width: 175, height: 83)
                .overlay {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "trophy.circle.fill")
                                .font(.system(size: 30))
                                .foregroundStyle(.orange)
                            
                            Spacer()
                            
                            Text("\(bestTreak)")
                                .font(.system(.title, weight: .bold))
                        }
                        
                        Spacer()
                        
                        Text("Best Streak")
                            .font(.system(.body, weight: .semibold))
                            .foregroundStyle(.secondary)
                        
                    }
                    .padding()
                    
                }
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 1)
                .fill(.secondary)
                .overlay {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "flame.circle.fill")
                                .font(.system(size: 30))
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text("\(currentStreak)")
                                .font(.system(.title, weight: .bold))
                        }
                        
                        Spacer()
                        
                        Text("Current Streak")
                            .font(.system(.body, weight: .semibold))
                            .foregroundStyle(.secondary)
                        
                    }
                    .padding()
                    
                }
            
        }
        .padding(.horizontal, 18)
    }
}


//
//#Preview("Habit Detail") {
//    NavigationStack {
//        HabitDetailView(habit: DummyData.habitsDummy[0])
//    }
//
//}

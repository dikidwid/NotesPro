//
//  HabitDetailView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 14/07/24.
//

import SwiftUI
import SwiftData

struct HabitDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var habitViewModel: HabitViewModel
    @EnvironmentObject private var addHabitViewModel: AddHabitViewModel
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    @EnvironmentObject var noteViewModel: NotesViewModel
    
    @Bindable var habit: Habit
    @Bindable var dailyHabitEntry: DailyHabitEntry
    
    @State private var isEditSheetPresented = false
    @State private var showDeleteAlert = false
    
    init(habit: Habit, dailyHabitEntry: DailyHabitEntry, calendarViewModel: CalendarViewModel, noteViewModel: NotesViewModel) {
        self.habit = habit
        self.dailyHabitEntry = dailyHabitEntry
    }
    
    var body: some View {
        ScrollView {
            VStack {
                StreakCardView(bestStreak: habit.bestStreak, currentStreak: habit.currentStreak)
                    .onChange(of: calendarViewModel.currentDate) { oldValue, newValue in
                        habitViewModel.updateStreaks(for: .now)
                    }
                
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
                
                TextField("Add Note", text: $dailyHabitEntry.userDescription, axis: .vertical)
                    .padding(.horizontal, 24)
                    .padding(.bottom)
                    .autocorrectionDisabled()
            }
            .navigationTitle(habit.title)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Edit") {
                            addHabitViewModel.populateFromHabit(habit)
                            isEditSheetPresented = true
                        }
                        Button("Delete", role: .destructive) {
                            showDeleteAlert = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        
//                    } label: {
//                        Image(systemName: "ellipsis.circle")
//                    }
//                }
//                
//                ToolbarItem(placement: .bottomBar) {
//                    HStack {
//                        Button {
//                            
//                        } label: {
//                            Image(systemName: "checklist")
//                        }
//                        
//                        Spacer()
//                        
//                        Button {
//                            
//                        } label: {
//                            Image(systemName: "camera")
//                        }
//                        
//                        Spacer()
//                        
//                        Button {
//                            
//                        } label: {
//                            Image(systemName: "pencil.tip.crop.circle")
//                        }
//                        
//                        Spacer()
//                        
//                        Button {
//                            
//                        } label: {
//                            Image(systemName: "pencil.line")
//                        }
//                    }
//                }
//            }
        }
        .onDisappear {
            if habitViewModel.selectedHabit?.id != habit.id {
                dismiss()
            }
        }
        .sheet(isPresented: $isEditSheetPresented) {
            AddHabitView()
                .environmentObject(habitViewModel)
                .environmentObject(addHabitViewModel)
        }
        .alert("Delete Habit", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteHabit()
            }
        } message: {
            Text("Are you sure you want to delete this habit? This action cannot be undone.")
        }
    }
    
    private func deleteHabit() {
        habitViewModel.deleteHabit(habit, modelContext: modelContext)
        dismiss()
    }
    
}

struct StreakCardView: View {
    let bestStreak: Int
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
                            
                            Text("\(bestStreak)")
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

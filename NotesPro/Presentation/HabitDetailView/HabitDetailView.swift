//
//  HabitDetailView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 14/07/24.
//

import SwiftUI
import SwiftData

struct HabitDetailVieww: View {
    @ObservedObject var habitDetailViewModel: HabitDetailViewModel
    @EnvironmentObject private var coordinator: AppCoordinatorImpl
    
    var body: some View {
        ScrollView {
            VStack {
                StreakCardView(bestStreak: habitDetailViewModel.entryHabit.habit.bestStreak,
                               currentStreak: habitDetailViewModel.entryHabit.habit.currentStreak)
                
                CalendarView(calendarViewModel: CalendarViewModel(selectedDate: habitDetailViewModel.entryHabit.date)) {
                    date in
                    habitDetailViewModel.refreshHabitEntry(to: date)
                }
                
                Divider()
                
                if habitDetailViewModel.entryHabit.tasks.isEmpty {
                    Text("You don't have any specific task for this habit")
                        .font(.system(.subheadline))
                        .foregroundStyle(.secondary)
                        .padding(.vertical)
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(habitDetailViewModel.entryHabit.tasks) { task in
                            CheckboxTaskView(checkboxTaskViewModel: coordinator.container.makeCheckboxTaskViewModel(task: task)) { updatedTask in
                                habitDetailViewModel.updateTask(updatedTask)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                    .padding(.horizontal, 32)
                }
                
                Divider()
                
                Text(habitDetailViewModel.selectedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(.caption2))
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 10)
                
                TextField("Add Note", text: $habitDetailViewModel.note, axis: .vertical)
                    .padding(.horizontal, 24)
                    .padding(.bottom)
                    .autocorrectionDisabled()
                
            }
            .onDisappear {
                habitDetailViewModel.updateHabitEntryNote()
            }
            .onAppear {
                habitDetailViewModel.updateHabit()
            }
            .navigationTitle(habitDetailViewModel.entryHabit.habit.habitName)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Edit Habit", systemImage: "pencil") {
                            coordinator.present(.editHabit(habitDetailViewModel.entryHabit.habit))
                        }
                        
                        Button("Delete Habit", systemImage: "trash", role: .destructive) {
                            habitDetailViewModel.isShowDeleteConfirmation.toggle()
                        }
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
            .alert("Delete Habit", isPresented: $habitDetailViewModel.isShowDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) { habitDetailViewModel.deleteHabitAndPop(with: coordinator) }
            } message: {
                Text("Are you sure you want to delete this habit? This action cannot be undone.")
            }
        }
    }
}

//#Preview("Habit Detail") {
//    let readingHabit = DummyData.habitsDummy[0]
//    let getHabitsUseCase = GetHabitsUseCase(repository: HabitRepositoryMock(habits: DummyData.habitsDummy, habit: readingHabit))
//    let habitDetailViewModel = HabitDetailViewModel(selectedHabit: readingHabit, selectedEntry: )
//    
//    let habitViewModel = HabitViewModelMock(getHabitsUseCase: getHabitsUseCase)
//    
//    return NavigationStack {
//        HabitDetailVieww(habitViewModel: habitViewModel, 
//                         habitDetailViewModel: habitDetailViewModel,
//                         calendarViewModel: CalendarViewModel())
//    }
//}


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

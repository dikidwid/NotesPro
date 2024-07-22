//
//  HabitListView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 15/07/24.
//

import SwiftUI

struct HabitListView<HabitViewModel>: View where HabitViewModel: HabitViewModelProtocol {
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var habitViewModel: HabitViewModel
    @ObservedObject var addHabitViewModel: AddHabitViewModell

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    CalendarView(calendarViewModel: calendarViewModel)
                    
                    if habitViewModel.habits.isEmpty {
                        ContentUnavailableView {
                            Label("No Habit Tracked", systemImage: "note.text")
                        } description: {
                            Text("You didn't defined the habit yet.")
                        } actions: {
                            Button {
                                habitViewModel.isShowAddNewHabitView.toggle()
                            } label: {
                                Text("Add New Habit")
                            }
                        }
                    } else {
                        ForEach(habitViewModel.habits) { habit in
                            HabitRowView(habit: habit,
                                         calendarViewModel: calendarViewModel,
                                         habitViewModel: habitViewModel)
                            .onTapGesture {
                                habitViewModel.selectedHabit = habit
                            }
                            
                        }
                    }
                }
            }
            .navigationBarBackgroundColor(Color(.systemBackground))
            .navigationTitle("Habits")
            .background(Color(.systemGroupedBackground))
            .task {
                await habitViewModel.fetchHabits()
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundStyle(.clear)
                        
                        Spacer()
                        
                        Text("\(habitViewModel.habits.count) habits")
                            .font(.system(.caption))
                        
                        Spacer()
                        
                        Button {
                            habitViewModel.isShowAddNewHabitView.toggle()
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                    }
                }
            }
            .sheet(isPresented: $habitViewModel.isShowAddNewHabitView) {
                AddNewHabitView(addHabitViewModel: addHabitViewModel,
                                habitViewModel: habitViewModel)
            }
        }
    }
}


struct HabitRowView<HabitViewModel>: View where HabitViewModel: HabitViewModelProtocol {
    let habit: HabitModel
    @Environment(\.colorScheme) private var isDarkMode
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var habitViewModel: HabitViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(habit.habitName)
                        .font(.system(.headline))
                    
//                    if habit.isDefinedTaskEmpty(for: calendarViewModel.currentDate) {
//                        Text("No task defined")
//                            .font(.system(.subheadline))
//                            .foregroundStyle(.secondary)
//                    } else {
                        Text("\(habit.totalUndoneTask(for: calendarViewModel.currentDate)) tasks to do")
                            .font(.system(.subheadline))
                            .foregroundStyle(.secondary)
//                    }
                }
                
                Spacer()
                
                HStack {
                    Label("\(habit.currentStreak)", systemImage: "flame.fill")
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.secondary)
            }
            
            Divider()
                .padding(.all, 5)

            VStack(alignment: .leading, spacing: 10) {
                ForEach(habit.tasks(for: calendarViewModel.currentDate)) { task in
                    CheckboxTaskView(isShowReminderTime: false, task: task)
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(isDarkMode == .dark ? Color(.secondarySystemGroupedBackground) : .white)
        }
        .padding(.horizontal)
    }
}

#Preview {
    let habitRepoMock       = HabitRepositoryMock(habits: DummyData.habitsDummy, habit: DummyData.habitsDummy[0])
    let calendarViewModel   = CalendarViewModel()
    let habitViewModel      = HabitViewModelMock(getHabitsUseCase: GetHabitsUseCase(repository: habitRepoMock))
    let addHabitViewModel   = AddHabitViewModell(addHabitUseCase: AddHabitUseCase(repository: habitRepoMock))
    
    return HabitListView(calendarViewModel: calendarViewModel,
                         habitViewModel: habitViewModel,
                         addHabitViewModel: addHabitViewModel)
    
}

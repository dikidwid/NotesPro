//
//  HabitListView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 15/07/24.
//

import SwiftUI

struct HabitListView<HabitViewModel>: View where HabitViewModel: HabitViewModelProtocol {
    @StateObject var habitViewModel: HabitViewModel
    @EnvironmentObject var coordinator: AppCoordinatorImpl
    
    init(habitViewModel: HabitViewModel) {
        self._habitViewModel = StateObject(wrappedValue: habitViewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                CalendarView(calendarViewModel: CalendarViewModel(selectedDate: habitViewModel.selectedDate)) { date in
                    habitViewModel.selectedDate = date
                }
                
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
                                     habitViewModel: habitViewModel)
                        .onTapGesture {
                            coordinator.push(.detailHabit(habit, habitViewModel.selectedDate))
                        }
                    }
                }
            }
        }
        .navigationBarBackgroundColor(Color(.systemBackground))
        .navigationTitle("Habits")
        .background(Color(.systemGroupedBackground))
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
                        coordinator.present(.addHabit)
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
        .onAppear {
            Task {
                await habitViewModel.fetchHabits()
            }
        }
    }
}


struct HabitRowView<HabitViewModel>: View where HabitViewModel: HabitViewModelProtocol {
    let habit: HabitModel
    @Environment(\.colorScheme) private var isDarkMode
    @ObservedObject var habitViewModel: HabitViewModel
    
    @EnvironmentObject var coordinator: AppCoordinatorImpl
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(habit.habitName)
                        .font(.system(.headline))
                    
                    if habit.isDefinedTaskEmpty(for: habitViewModel.selectedDate) {
                        Text("No task defined")
                            .font(.system(.subheadline))
                            .foregroundStyle(.secondary)
                    } else {
                        Text("\(habit.totalUndoneTask(for: habitViewModel.selectedDate)) tasks to do")
                            .font(.system(.subheadline))
                            .foregroundStyle(.secondary)
                    }
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
                ForEach(habit.tasks(for: habitViewModel.selectedDate)) { task in
                    CheckboxTaskView(checkboxTaskViewModel: coordinator.container.makeCheckboxTaskViewModel(task: task)) { task in
                        habitViewModel.updateTask(task)
                    }
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

//#Preview {
//    let habitRepoMock       = HabitRepositoryMock.shared
//    let calendarViewModel   = CalendarViewModel()
//    let habitViewModel      = HabitViewModelMock(getHabitsUseCase: GetHabitsUseCase(repository: habitRepoMock), updateTaskUseCase: UpdateTaskUseCase(repository: habitRepoMock))
//    let addHabitViewModel   = AddHabitViewModell(addHabitUseCase: AddHabitUseCase(repository: habitRepoMock))
//
//    return HabitListView(calendarViewModel: calendarViewModel,
//                         habitViewModel: habitViewModel,
//                         addHabitViewModel: addHabitViewModel)
//
//}

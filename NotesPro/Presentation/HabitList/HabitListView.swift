//
//  HabitListView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 15/07/24.
//

import SwiftUI

struct HabitListView<HabitListViewModel>: View where HabitListViewModel: HabitListViewModelProtocol {
    @StateObject var habitListViewModel: HabitListViewModel
    @EnvironmentObject var coordinator: AppCoordinatorImpl
    
    init(habitViewModel: HabitListViewModel) {
        self._habitListViewModel = StateObject(wrappedValue: habitViewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                CalendarView(calendarViewModel: CalendarViewModel(selectedDate: habitListViewModel.selectedDate)) { date in
                    habitListViewModel.selectedDate = date
                }
                
                if habitListViewModel.habits.isEmpty {
                    ContentUnavailableView {
                        Label("No Habit Tracked", systemImage: "note.text")
                    } description: {
                        Text("You didn't defined the habit yet.")
                    } actions: {
                        Button {
                            habitListViewModel.isShowAddNewHabitView.toggle()
                        } label: {
                            Text("Add New Habit")
                        }
                    }
                } else {
                    ForEach(habitListViewModel.habits) { habit in
                        HabitRowView(habit: habit,
                                     habitViewModel: habitListViewModel)
                        .onTapGesture {
                            coordinator.push(.detailHabit(habit, habitListViewModel.selectedDate))
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
                    
                    Text("\(habitListViewModel.habits.count) habits")
                        .font(.system(.caption))
                    
                    Spacer()
                    
                    Button {
                        coordinator.present(.addHabit(onDismiss: { _ in
                            Task {
                                await habitListViewModel.fetchHabits()
                            }
                        }))
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
        .onAppear {
            Task {
                await habitListViewModel.fetchHabits()
            }
        }
    }
}

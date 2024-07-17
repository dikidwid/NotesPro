//
//  HabitListView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 15/07/24.
//

import SwiftUI
import SwiftData

struct HabitListView: View {
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    @EnvironmentObject var habitViewModel: HabitViewModel
    @EnvironmentObject var addHabitViewModel: AddHabitViewModel
    @EnvironmentObject var noteViewModel: NotesViewModel
    
    @Query var habits: [Habit]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                CalendarView(viewModel: calendarViewModel)
                    .background(.background)
                
                if habits.isEmpty {
                    Spacer().frame(height: 100)
                    
                    ContentUnavailableView {
                        Label("No Habit Found", systemImage: "note.text")
                    } description: {
                        Text("You didn't defined the habit yet.")
                    } actions: {
                        Button {
                            habitViewModel.isAddHabitSheetPresented.toggle()
                        } label: {
                            Text("Add New Habit")
                        }
                    }
                } else {
                    ForEach(habits) { habit in
                        HabitRowView(habit: habit, calendarViewModel: calendarViewModel,
                                     habitViewModel: habitViewModel,
                                     noteViewModel: noteViewModel)
                        .onTapGesture {
                            habitViewModel.selectedHabit = habit
                        }
                    }
                }
            }
        }
        .navigationBarBackgroundColor(Color(.systemBackground))
        .frame(maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Habit")
        .navigationDestination(item: $habitViewModel.selectedHabit) { habit in
            if habits.contains(where: { $0.id == habit.id }) {
                HabitDetailView(
                    habit: habit,
                    dailyHabitEntry: habitViewModel.getOrCreateEntry(for: habit, on: calendarViewModel.currentDate),
                    calendarViewModel: calendarViewModel,
                    noteViewModel: noteViewModel
                )
            }
        }
        .sheet(isPresented: $habitViewModel.isAddHabitSheetPresented) {
            AddHabitView()
                .environmentObject(habitViewModel)
                .environmentObject(addHabitViewModel)
                .presentationDragIndicator(.visible)
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
                        habitViewModel.isAddHabitSheetPresented.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
        .onChange(of: habitViewModel.selectedHabit) { oldValue, newValue in
            habitViewModel.updateCompletedDays()
            calendarViewModel.updateCompletedDays(habitViewModel.completedDays)
        }
        .onChange(of: calendarViewModel.selectedDate) { oldValue, newValue in
            Task {
                await habitViewModel.checkAndCreateEntriesForDate(newValue)
                await habitViewModel.getDailyHabitEntries(from: newValue)
                habitViewModel.updateStreaks(for: .now)
                habitViewModel.updateCompletedDays()
                calendarViewModel.updateCompletedDays(habitViewModel.completedDays)
            }
        }
        .task {
            DispatchQueue.main.async {
                Task {
                    await habitViewModel.getHabits()
                    await habitViewModel.checkAndCreateEntriesForDate(calendarViewModel.currentDate)
                    await habitViewModel.getDailyHabitEntries(from: calendarViewModel.currentDate)
                    habitViewModel.updateStreaks(for: .now)
                    habitViewModel.updateCompletedDays()
                    calendarViewModel.updateCompletedDays(habitViewModel.completedDays)
                }
            }
        }
    }
}

struct HabitRowView: View {
    let habit: Habit
    @Environment(\.colorScheme) private var isDarkMode
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var habitViewModel: HabitViewModel
    @ObservedObject var noteViewModel: NotesViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(habit.title)
                        .font(.system(.headline))
                    
                    Text("\(habit.totalUndoneTask(for: calendarViewModel.currentDate)) tasks to do")
                        .font(.system(.subheadline))
                        .foregroundStyle(.secondary)

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
                    CheckboxTaskView(isShowReminderTime: false, task: task, viewModel: noteViewModel)

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
    NavigationStack {
        HabitListView()
    }
    .environmentObject(CalendarViewModel())
    .environmentObject(HabitViewModel(habitDataSource: SwiftDataManager.shared))
    .environmentObject(AddHabitViewModel())
    .environmentObject(NotesViewModel())
    .modelContainer(SwiftDataManager.shared.modelContainer)
}

//
//  HabitListView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 15/07/24.
//

import SwiftUI
import SwiftData

struct HabitListView: View {
    @StateObject var calendarViewModel: CalendarViewModel = CalendarViewModel()
    @ObservedObject var habitViewModel: HabitViewModel
    @ObservedObject var addHabitViewModel: AddHabitViewModel
    @ObservedObject var noteViewModel: NotesViewModel
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
            HabitDetailView(habit: habit, 
                            dailyHabitEntry: habit.hasEntry(for: calendarViewModel.currentDate) ?? DailyHabitEntry(day: .now),
                            calendarViewModel: calendarViewModel, noteViewModel: noteViewModel)
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
                    // Just for balancing purpose that's why its color is .clear
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
        .task {
            DispatchQueue.main.async {
                Task {
                    await habitViewModel.getHabits()
                    await habitViewModel.getDailyHabitEntries(from: calendarViewModel.currentDate)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for habit in habitViewModel.habits {
                    if habit.hasEntry(for: .now) == nil {
                        SwiftDataManager.shared.addNewEntry(habit: habit, date: .now)
                    }
                    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)
                    SwiftDataManager.shared.addNewEntry(habit: habit, date: yesterday!)

                }
//                habitViewModel.habits.forEach { myHabit in
//                    if myHabit.isTaskEmpty(for: .now) {
//                        SwiftDataManager.shared.addNewEntry(habit: myHabit, date: .now)
//                    }
//                }
//                checkNewDay()
            }
        }
    }
    
//    func checkNewDay() {
//        print("Checking new day")
//        
//        // Check if there is any entry in this day
//        let currentDate = Date()
//        print(habitViewModel.habits)
//
//        habitViewModel.habits.forEach { myHabit in
//            var entriesThisDay: [DailyHabitEntry] = []
//            print("Habit")
//
//            // Populate entries today for this habit
//            myHabit.dailyHabitEntries.forEach { myHabitEntry in
//                print("Tasks: \(myHabitEntry.tasks)")
//
//                if Calendar.current.isDateInToday(myHabitEntry.day) {
//                    print("Tasks: \(myHabitEntry.tasks)")
//                    entriesThisDay.append(myHabitEntry)
//                }
//            }
//            
//            // If there is no entry this day for this habit, add a new entry
//            if entriesThisDay.isEmpty {
//                print("No entries this day. Adding...")
//                
//                SwiftDataManager.shared.addNewEntry(habit: myHabit, date: currentDate)
//                
////                var todayEntry = DailyHabitEntry(day: currentDate)
////                todayEntry.habit = myHabit
////                
////                // Assign tasks to the entry based on DailyTaskDefinition
////                myHabit.definedTasks.forEach{ definedTask in
////                    let newDailyTask = DailyTask(taskName: definedTask.taskName)
////                    todayEntry.tasks.append(newDailyTask)
////                }
////                
////                SwiftDataManager.shared.modelContainer.mainContext.insert(todayEntry)
//            }
//                        
//        }
//        
//        // If there are not entries this day, add new entry
////        if entriesThisDay.isEmpty {
////            let newEntry = DailyHabitEntry(day: Date())
////            newEntry.tasks.append(newEntry.habit?.definedTasks)
////            SwiftDataManager.shared.modelContainer.mainContext.insert(newEntry)
////        }
//    }
    
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
                    
//                    if !habit.isTaskEmpty(for: calendarViewModel.currentDate) {
                        Text("\(habit.totalUndoneTask(for: calendarViewModel.currentDate)) tasks to do")
                            .font(.system(.subheadline))
                            .foregroundStyle(.secondary)
//                    } else {
//                        Text("No tasks have been defined")
//                            .font(.system(.subheadline))
//                            .foregroundStyle(.secondary)
//                    }
                }
                
                Spacer()
                
                HStack {
                    Label("2", systemImage: "flame.fill")
                    
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.secondary)
            }
            
//            // List of task
//            if !habit.isTaskEmpty(for: calendarViewModel.currentDate) {
                Divider()
                    .padding(.all, 5)
//
//                if habit.isAllTaskDone(for: calendarViewModel.currentDate) {
//                    Button("Add Note", systemImage: "note.text") {
//                        habitViewModel.selectedHabit = habit
//                    }
//                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(habit.tasks(for: calendarViewModel.currentDate)) { task in
                            CheckboxTaskView(isShowReminderTime: false, task: task, viewModel: noteViewModel)
//                        }
//                    }
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
//    let newTask = DailyTaskDefinition(taskName: "")
//    let reminder = DailyTaskReminder()    
    return NavigationStack {
        HabitListView(habitViewModel: HabitViewModel(habitDataSource: SwiftDataManager.shared),
                      addHabitViewModel: AddHabitViewModel(), noteViewModel: NotesViewModel())
        .modelContainer(SwiftDataManager.shared.modelContainer)
    }
}

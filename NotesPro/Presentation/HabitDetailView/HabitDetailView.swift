//
//  HabitDetailView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 14/07/24.
//

import SwiftUI
import SwiftData

struct HabitDetailVieww<HabitViewModel>: View where HabitViewModel: HabitViewModelProtocol {
    @ObservedObject var habitViewModel: HabitViewModel
    @ObservedObject var habitDetailViewModel: HabitDetailViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                StreakCardView(bestStreak: habitDetailViewModel.selectedHabit.bestStreak,
                               currentStreak: habitDetailViewModel.selectedHabit.currentStreak)
                
                CalendarView(calendarViewModel: calendarViewModel,
                             forAllHabits: false)
                
                Divider()
                
                if habitDetailViewModel.selectedHabit.isDefinedTaskEmpty(for: calendarViewModel.selectedDate) {
                    Text("You don't have any specific task for this habit")
                        .font(.system(.subheadline))
                        .foregroundStyle(.secondary)
                        .padding(.vertical)
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(habitDetailViewModel.selectedHabit.tasks(for: calendarViewModel.selectedDate)) { task in
//                            CheckboxTaskVieww(checkboxTaskViewModel: CheckboxTaskViewModel(task: task))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                    .padding(.horizontal, 32)
                }
                
                Divider()
                
                Text(calendarViewModel.selectedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(.caption2))
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 10)
                
                TextField("Add Note", text: $habitDetailViewModel.selectedEntry.note, axis: .vertical)
                    .padding(.horizontal, 24)
                    .padding(.bottom)
                    .autocorrectionDisabled()
                
            }
            .onChange(of: habitDetailViewModel.selectedEntry.note) {
                habitViewModel.updateNote(for: habitDetailViewModel.selectedEntry,
                                          from: habitDetailViewModel.selectedHabit,
                                          on: calendarViewModel.selectedDate)
            }
            .navigationTitle(habitDetailViewModel.selectedHabit.habitName)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Edit Habit", systemImage: "pencil") {
                            habitDetailViewModel.isEditSelectedHabit.toggle()
                        }
                        
                        Button("Delete Habit", systemImage: "trash", role: .destructive) {
//                            showDeleteAlert = true
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

        }
//        .sheet(isPresented: $isEditSheetPresented) {
//            AddHabitView(addHabitViewModel: addHabitViewModel,
//                         habitViewModel: habitViewModel)
//        }
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

final class HabitDetailViewModel: ObservableObject {
    @Published var selectedHabit: HabitModel
    @Published var selectedEntry: DailyHabitEntryModel
    @Published var note: String = ""
    @Published var isEditSelectedHabit: Bool = false
    
    init(selectedHabit: HabitModel, date: Date) {
        self.selectedHabit = selectedHabit
        
        print("passed date \(date.formatted(date: .complete, time: .complete))")
        
        if let existingHabitEntry = selectedHabit.dailyHabitEntries.first(where: { entry in
            print("date in habit entry \(entry.date.formatted(date: .complete, time: .complete))")
            return Calendar.current.isDate(date, inSameDayAs: entry.date)
        }) {
            self.selectedEntry = existingHabitEntry
            print("use the existing entry")
        } else {
            self.selectedEntry = DailyHabitEntryModel(date: date,
                                                     note: "", habit: selectedHabit,
                                                     tasks: selectedHabit.definedTasks)
            
            print("use the new entry")

        }
    }
    
//    func selectedDate(date: Date) {
//       selectedEntry = selectedHabit.hasEntry(for: date)
//        print(selectedEntry.date)
//    }
    
    func updateNote(for date: Date) {
        if let index = selectedHabit.dailyHabitEntries.firstIndex(where: { $0.date == selectedEntry.date }) {
            selectedHabit.dailyHabitEntries[index] = selectedEntry
            print("note from selectedEntry \(selectedEntry.note)")
            print("note from the (same) entry \(selectedHabit.dailyHabitEntries[index].note)")
        }
    }
    
    func updateEntry(for date: Date) {
        
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

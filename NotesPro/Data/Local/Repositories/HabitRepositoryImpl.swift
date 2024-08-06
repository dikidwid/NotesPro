//
//  HabitRepositoryImpl.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 19/07/24.
//

import Foundation
import SwiftData

struct HabitRepositoryImpl: HabitRepository {
    let dataSource: HabitDataSource
    
    func createHabit(_ habit: HabitModel) {
        let newHabit = Habit(id: habit.id,
                             habitName: habit.habitName,
                             currentStreak: habit.currentStreak,
                             bestStreak: habit.currentStreak,
                             definedTasks: habit.toTasksDefinitions())
                                        
        dataSource.createHabit(newHabit)
    }
    
    func getHabits() async -> Result<[HabitModel], ResponseError> {
        let result = await dataSource.fetchHabits()
        switch result {
        case .success(let habitsResponse):
            return .success(habitsResponse.map { $0.toHabitModel() })
        case .failure(let responseError):
            return .failure(.localStorageError(cause: responseError.localizedDescription))
        }
    }
    
    func updateHabit(_ habit: HabitModel) {
        dataSource.updateHabit(habit)
    }
    
    func deleteHabit(_ habit: HabitModel) {
        dataSource.deleteHabit(with: habit.id)
    }
}

#warning("FOCUS BASED ON ARRAY OF HABITS IN THE FUTURE WE WILL IMPLEMENTED THE REAL Database")
//class HabitRepositoryMock: HabitRepository {
//    
//    static var shared = HabitRepositoryMock()
//    
//    var habits: [HabitModel]
//
//    private init () {
//        habits = DummyData.habitsDummy
//    }
//    
//    
//    func createHabit(_ habit: HabitModel) {
//        habits.append(habit)
//    }
//    
//    func getHabits() async -> Result<[HabitModel], ResponseError> {
//        return .success(habits)
//    }
//    
//    func getHabit(_ habit: HabitModel) async -> Result<HabitModel, ResponseError> {
//        return .success(habit)
//    }
//    
//    func updateHabit(_ habit: HabitModel) {
//        if let habitIndex = habits.firstIndex(where: { $0.id == habit.id }) {
//            habits[habitIndex].habitName = habit.habitName
//            habits[habitIndex].definedTasks = habit.definedTasks
//            
//            for habitEntryIndex in habits[habitIndex].dailyHabitEntries.indices {
//                habits[habitIndex].dailyHabitEntries[habitEntryIndex].habit = habit
//                
//                for taskIndex in habits[habitIndex].dailyHabitEntries[habitEntryIndex].tasks.indices {
//                    
//                    
////                    if let existingTask = habit.definedTasks.firstIndex(where: { $0. })
////                    for updatedTask in habit.definedTasks {
////                        if updatedTask.id == habits[habitIndex].dailyHabitEntries[habitEntryIndex].tasks[taskIndex].id {
////                            habits[habitIndex].dailyHabitEntries[habitEntryIndex].tasks[taskIndex] = updatedTask
////                        }
////                    }
//                }
//            }
//        }
//    }
//    
//    func deleteHabit(_ habit: HabitModel) {
//        if let habitIndex = habits.firstIndex(where: { $0.id == habit.id }) {
//            habits.remove(at: habitIndex)
//        }
//    }
//    
//    func getDailyHabitEntries(for habit: HabitModel) -> [DailyHabitEntryModel] {
//        return habits[0].dailyHabitEntries
//    }
//    
//    func getHabitEntry(_ habit: HabitModel, on date: Date) -> DailyHabitEntryModel {
//        if let habit = habits.first(where: { $0.id == habit.id }) {
//            if let foundedEntry = habit.dailyHabitEntries.first(where: { Calendar.current.isDate(date , inSameDayAs: $0.date) }) {
//                return foundedEntry
//            }
//        }
//        
//        return DailyHabitEntryModel(date: .now, note: "SALAHH KOCAK", habit: habits[0])
//    }
//    
//    func updateHabitEntry(_ habitEntry: DailyHabitEntryModel) {
//        for indexHabit in habits.indices {
//            for indexDailyHabitEntry in habits[indexHabit].dailyHabitEntries.indices {
//                if habits[indexHabit].dailyHabitEntries[indexDailyHabitEntry].id == habitEntry.id {
//                    habits[indexHabit].dailyHabitEntries[indexDailyHabitEntry] = habitEntry
//                }
//                
//            }
//        }
//    }
//    
//    func addTask(_ task: TaskModel) {
//        if let habitIndex = habits.firstIndex(where: { $0.id == task.habit?.id }) {
//            habits[habitIndex].definedTasks.append(task)
//                        
//            for entryIndex in habits[habitIndex].dailyHabitEntries.indices {
//                var newTask = task
//                newTask.habitEntry = habits[habitIndex].dailyHabitEntries[entryIndex]
//                habits[habitIndex].dailyHabitEntries[entryIndex].tasks.append(newTask)
//            }
//        }
//    }
//
//    func updateTask(_ task: TaskModel) {
//        for habitIndex in habits.indices {
//            if let entryIndex = habits[habitIndex].dailyHabitEntries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: task.habitEntry?.date) })
//           for entryIndex in habits[habitIndex].dailyHabitEntries.indices {
//               if let taskIndex = habits[habitIndex].dailyHabitEntries[entryIndex].tasks.firstIndex(where: { $0.habitEntry?.date == task.habitEntry?.date }) {
//                   habits[habitIndex].dailyHabitEntries[entryIndex].tasks[taskIndex].isChecked.toggle()
//               }
//           }
//       }
//            
//            for habitIndex in habits.indices {
//                for dailyHabitEntryIndex in habits[habitIndex].dailyHabitEntries.indices {
//                    if let taskIndex = habits[habitIndex].dailyHabitEntries[dailyHabitEntryIndex].tasks.firstIndex(where: { $0.habitEntry?.date == task.habitEntry?.date }) {
//                        habits[habitIndex].dailyHabitEntries[dailyHabitEntryIndex].tasks[taskIndex].isChecked.toggle()
//                    }
//                }
//            }
//    }
//    
//    func deleteTask(_ task: TaskModel) {
//        for habitIndex in habits.indices {
//            for entryIndex in habits[habitIndex].dailyHabitEntries.indices {
//                habits[habitIndex].dailyHabitEntries[entryIndex].tasks.removeAll { $0.id == task.id }
//            }
//        }
//    }
//}

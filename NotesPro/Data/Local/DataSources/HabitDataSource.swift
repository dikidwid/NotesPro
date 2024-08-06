//
//  HabitDataSource.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 19/07/24.
//

import Foundation

protocol HabitDataSource {
    func createHabit(_ habit: Habit)
    func fetchHabits() async -> Result<[Habit], ResponseError>
    func updateHabit(_ updatedHabitModel: HabitModel)
    func deleteHabit(with id: UUID)
    
//    func fetchHabitEntries(for habit: Habit) -> [DailyHabitEntry]
//    func fetchHabitEntry(_ habit: Habit, on date: Date) -> DailyHabitEntry
//    func updateHabitEntry(_ updatedHabitEntryID: UUID, with newNote: String)
    
    func updateTask(_ updatedTask: TaskModel, on habitID: UUID, with entryDate: Date)
}

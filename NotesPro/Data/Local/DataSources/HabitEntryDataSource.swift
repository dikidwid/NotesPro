//
//  HabitEntryDataSource.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 06/08/24.
//

import Foundation

protocol HabitEntryDataSource {
    func fetchHabitEntries(for habit: Habit) -> [DailyHabitEntry]
    func fetchHabitEntry(_ habit: Habit, on date: Date) -> DailyHabitEntry
    func updateHabitEntry(_ updatedHabitEntryID: UUID, with newNote: String)
}

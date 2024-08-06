//
//  HabitEntryRepositoryImpl.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 06/08/24.
//

import Foundation

struct HabitEntryRepositoryImpl: HabitEntryRepository {
    let dataSource: HabitEntryDataSource
    
    func getHabitEntry(_ habit: HabitModel, on date: Date) -> HabitEntryModel {
        let habitEntry = dataSource.fetchHabitEntry(habit.toHabit(), on: date).toDailyHabitEntryModel()
        return habitEntry
    }
    
    func updateHabitEntry(_ habitEntry: HabitEntryModel) {
        dataSource.updateHabitEntry(habitEntry.id, with: habitEntry.note)
    }
}

//
//  HabitEntryRepository.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 23/07/24.
//

import Foundation

protocol HabitEntryRepository {
    func getHabitEntry(_ habit: HabitModel, on date: Date) -> HabitEntryModel
    func updateHabitEntry(_ habitEntry: HabitEntryModel)
}


//
//  DailyHabitEntryRepository.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 23/07/24.
//

import Foundation

protocol DailyHabitEntryRepository {
    func getDailyHabitEntries(for habit: HabitModel) async -> Result<[DailyHabitEntryModel], ResponseError>
}

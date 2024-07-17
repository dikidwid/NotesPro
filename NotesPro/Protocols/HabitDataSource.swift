//
//  HabitDataSource.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 17/07/24.
//

import Foundation

protocol HabitDataSource {
    func fetchHabits() async -> Result<[Habit], ResponseError>
    func fetchDailyHabitEntries(from date: Date) async -> Result<[DailyHabitEntry], ResponseError>
}

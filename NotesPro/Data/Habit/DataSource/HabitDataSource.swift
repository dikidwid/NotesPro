//
//  HabitDataSource.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 19/07/24.
//

import Foundation

protocol HabitDataSource {
    func fetchHabits() async -> Result<[Habit], ResponseError>
}

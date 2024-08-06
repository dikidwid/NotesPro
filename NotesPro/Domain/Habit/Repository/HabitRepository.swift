//
//  HabitRepository.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 19/07/24.
//

import Foundation

protocol HabitRepository {
    func createHabit(_ habit: HabitModel)
    func getHabits() async -> Result<[HabitModel], ResponseError>
    func updateHabit(_ habit: HabitModel)
    func deleteHabit(_ habit: HabitModel)
}

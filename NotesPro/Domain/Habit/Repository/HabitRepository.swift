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
    func getHabit(_ habit: HabitModel) async -> Result<HabitModel, ResponseError>
    func updateHabit(_ habit: HabitModel)
    func deleteHabit(_ habit: HabitModel)
    
    func getDailyHabitEntries(for habit: HabitModel) -> [DailyHabitEntryModel]
    func getHabitEntry(_ habit: HabitModel, on date: Date) -> DailyHabitEntryModel
    func updateHabitEntry(_ HabitEntry: DailyHabitEntryModel)

    func addTask(_ task: TaskModel)
    func updateTask(_ task: TaskModel)
    func deleteTask(_ task: TaskModel)
}

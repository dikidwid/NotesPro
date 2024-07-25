//
//  HabitRepository.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 19/07/24.
//

import Foundation

protocol HabitRepository {
    func getHabits() async -> Result<[HabitModel], ResponseError>
    func getHabit(_ habit: HabitModel) async -> Result<HabitModel, ResponseError>
//    func createHabit(_ habit: HabitModel)
    func createHabit(_ habit: HabitModel) async -> Result<HabitModel, ResponseError>
    func syncTaskToCalendar(_ taks: TaskModel) async -> Result<Void, ResponseError>
    
    
    func getDailyHabitEntries(for habit: HabitModel) -> [DailyHabitEntryModel]
//    func updateEntry(_ entry: DailyHabitEntryModel, for habit: HabitModel)
    func updateTask(_ task: TaskModel)
}

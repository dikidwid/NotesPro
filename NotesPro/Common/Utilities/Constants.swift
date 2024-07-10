//
//  Constants.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import SwiftData

let swiftDataModels: [any PersistentModel.Type] = [
    Goal.self,
    Habit.self,
    Note.self,
    DailyTask.self,
    DailyTaskDefinition.self
]

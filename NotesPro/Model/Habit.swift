//
//  Habit.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import Foundation
import SwiftData

@Model
final class Habit: Identifiable {
    // Objek yang mendefinisikan habit.
    var id: UUID
    var title: String
    var desc: String
    var createdDate: Date
    
    // Suatu habit mempunyai task yang sudah didefinisikan yang nantinya tiap hari akan tersalin ke dalam DailyTask untuk menciptakan objek yang berbeda.
    @Relationship(deleteRule: .cascade, inverse: \DailyTaskDefinition.habit) 
    var definedTasks: [DailyTaskDefinition] = []
    
    // User mengisi journal / notes harian untuk habit. Data tersebut disimpan di DailyHabitEntry.
    @Relationship(deleteRule: .cascade, inverse: \DailyHabitEntry.habit)
    var dailyHabitEntries: [DailyHabitEntry] = []
        
    init(title: String, description: String) {
        self.id = UUID()
        self.title = title
        self.desc = description
        self.createdDate = Date()
    }
}

//
//  DailyHabitEntry.swift
//  NotesPro
//
//  Created by Arya Adyatma on 12/07/24.
//


import Foundation
import SwiftData

@Model
final class DailyHabitEntry: Identifiable {
    // Merupakan objek pengisian journal / notes untuk sebuah habit yang setiap harinya berubah.
    // Class ini sudah terdapat DailyTask yang juga berubah tiap harinya
    
    var id: UUID
    var day: Date
    
    var userFeeling: String = ""
    var userDescription: String = ""
    
    @Relationship 
    var habit: Habit?
    
    @Relationship(deleteRule: .cascade, inverse: \DailyTask.dailyHabitEntry) 
    var tasks: [DailyTask] = []
    
    init(id: UUID = UUID(), day: Date) {
        self.id = id
        self.day = day
        self.userFeeling = ""
        self.userDescription = ""
    }
}

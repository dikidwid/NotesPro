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

extension Habit {
    func entry(for date: Date) -> DailyHabitEntry? {
        self.dailyHabitEntries.first { Calendar.current.isDate($0.day, inSameDayAs: date) }
    }

    func tasks(for date: Date) -> [DailyTask] {
        entry(for: date)?.tasks.sorted(by: { $0.taskName < $1.taskName }) ?? []
    }
    
    func isAllTaskDone(for date: Date) -> Bool {
        entry(for: date)?.tasks.filter { $0.isChecked == false }.count == 0
    }
    
    func isTaskEmpty(for date: Date) -> Bool {
        tasks(for: date).isEmpty
    }

    func totalUndoneTask(for date: Date) -> Int {
        tasks(for: date).filter { !$0.isChecked }.count
    }
}

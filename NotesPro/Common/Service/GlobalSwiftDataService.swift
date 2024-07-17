//
//  SwiftDataService.swift
//  NotesPro
//
//  Created by Arya Adyatma on 16/07/24.
//

import Foundation
import SwiftData

class GlobalSwiftDataService {
    let modelContainer: ModelContainer
    let modelContext: ModelContext
    
    @MainActor
    static let shared = GlobalSwiftDataService()
    
    @MainActor
    private init() {
        // Change isStoredInMemoryOnly to false if you would like to see the data persistance after kill/exit the app
        self.modelContainer = try! ModelContainer(
            for: Habit.self, Note.self, DailyTask.self, DailyTaskDefinition.self, DailyHabitEntry.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: false)
        )
        self.modelContext = modelContainer.mainContext
    }
}

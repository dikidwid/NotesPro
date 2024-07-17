//
//  SwiftDataManager.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 17/07/24.
//

import SwiftData
import SwiftUI

class SwiftDataManager: HabitDataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = SwiftDataManager()
    
    @MainActor
    private init() {
        // Change isStoredInMemoryOnly to false if you would like to see the data persistance after kill/exit the app
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Habit.self,
                                            configurations: config)
        
        let habits: [Habit] = DummyData.habitsDummy
        
        for habit in habits {
            container.mainContext.insert(habit)
        }

        self.modelContainer = container
        self.modelContext = modelContainer.mainContext
    }
    
    func fetchHabits() async -> Result<[Habit], ResponseError> {
        do {
            let habits = try modelContext.fetch(FetchDescriptor<Habit>(sortBy: [SortDescriptor(\Habit.title)]))
            return .success(habits)
        } catch {
            return .failure(.localStorageError(cause: "Error fetching habits on SwiftDataManager"))
        }
    }
    
    func fetchDailyHabitEntries(from date: Date) async -> Result<[DailyHabitEntry], ResponseError> {
        do {
            let dailyHabitEntries = try modelContext.fetch(FetchDescriptor<DailyHabitEntry>(predicate: #Predicate<DailyHabitEntry> { $0.day == date }, sortBy: [SortDescriptor(\.day)]))
            return .success(dailyHabitEntries)
        } catch {
            return .failure(.localStorageError(cause: "Error fetching daily habit entries on SwiftDataManager"))
        }
    }
    
}

//
//  NotesProApp.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 10/07/24.
//

import SwiftUI
import SwiftData

@main
struct NotesProApp: App {
    
    var swiftDataContainer: ModelContainer {
        do {
            let configurations = ModelConfiguration(isStoredInMemoryOnly: false)
            let container = try ModelContainer(for: Habit.self, configurations: configurations)
            
            return container
            
        } catch {
            fatalError("\(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView(coordinator: AppCoordinatorImpl(container: AppDIContainer(swiftDataContainer: swiftDataContainer)))
        }
    }
}

struct DebugSwiftDataView: View {
    
    @Query var habits: [Habit]
    
    var body: some View {
        List(habits) { habit in
            Text(habit.habitName)
        }
    }
}

struct CoordinatorView: View  {
    
    @StateObject var coordinator: AppCoordinatorImpl

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(.listHabit)
                .navigationDestination(for: Screen.self) { page in
                    coordinator.build(page)
                }
            
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.build(sheet)
                }
        }
        .environmentObject(coordinator)
    }
}


//#Preview {
//   return CoordinatorView()
//}

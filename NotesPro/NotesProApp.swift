//
//  NotesProApp.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 10/07/24.
//

import SwiftUI

@main
struct NotesProApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {

    var body: some View {
        NavigationStack {
            HabitListView()
        }
        .environmentObject(HabitViewModel(habitDataSource: SwiftDataManager.shared))
        .environmentObject(CalendarViewModel())
        .environmentObject(AddHabitViewModel())
        .environmentObject(NotesViewModel())
        .modelContainer(SwiftDataManager.shared.modelContainer)
        
//        MainView()
//            .environmentObject(addHabitViewModel)
//            .environmentObject(notesViewModel)
//            .environmentObject(habitsViewModel)
//            .modelContainer(for: swiftDataModels)
    }
}


#Preview {
   return ContentView()
}

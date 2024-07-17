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
    @ObservedObject var addHabitViewModel = AddHabitViewModel()
    @ObservedObject var notesViewModel = NotesViewModel()
    @ObservedObject var habitsViewModel = HabitsViewModel()
    
    var body: some View {
        NavigationStack {
            HabitListView(habitViewModel: HabitViewModel(habitDataSource: SwiftDataManager.shared), noteViewModel: NotesViewModel())
        }
//        MainView()
//            .environmentObject(addHabitViewModel)
//            .environmentObject(notesViewModel)
//            .environmentObject(habitsViewModel)
//            .modelContainer(for: swiftDataModels)
    }
}


#Preview {
    ContentView()
}

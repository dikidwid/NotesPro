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

@MainActor
struct ContentView: View {
    
    let getHabitUseCase = GetHabitsUseCase(repository: HabitRepositoryImpl(dataSource: SwiftDataManager.shared))

    var body: some View {
        NavigationStack {
//            HabitListView(viewModel: HabitViewModel(getHabitsUseCase: getHabitUseCase) as! (any HabitViewModelProtocol))
        }
//        .environmentObject(HabitViewModel())
//        .environmentObject(CalendarViewModel())
//        .environmentObject(AddHabitViewModel())
//        .environmentObject(NotesViewModel())
//        .modelContainer(SwiftDataManager.shared.modelContainer)
        
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

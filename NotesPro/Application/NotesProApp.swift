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
            CoordinatorView()
        }
    }
}

struct CoordinatorView: View  {
    
    @StateObject var coordinator: AppCoordinatorImpl = AppCoordinatorImpl()

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


#Preview {
   return CoordinatorView()
}

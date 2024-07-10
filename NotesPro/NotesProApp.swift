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
        MainView()
            .modelContainer(for: swiftDataModels)
    }
}


#Preview {
    ContentView()
}

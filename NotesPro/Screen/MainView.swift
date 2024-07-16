//
//  MainView.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            NotesView()
                .tabItem {
                    Label("Notes", systemImage: "book.pages")
                }
            
            HabitsView()
                .tabItem {
                    Label("Habits", systemImage: "checkmark.square")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

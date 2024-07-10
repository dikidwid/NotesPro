//
//  NotesViewModel.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import Foundation
import SwiftData

class NotesViewModel: ObservableObject {
    @Published var navigateToNewNote = false
    @Published var newNote: Note = Note(title: "", content: "")
    
    func addNote() {
        newNote = Note(title: "", content: "")
        navigateToNewNote = true
    }
    
    func deleteNotes(at offsets: IndexSet, notes: [Note], modelContext: ModelContext) {
        for index in offsets {
            modelContext.delete(notes[index])
        }
    }
    
    func saveNote(modelContext: ModelContext) {
        if !newNote.title.isEmpty && !newNote.content.isEmpty {
            modelContext.insert(newNote)
            try? modelContext.save()
        }
    }
}

//
//  NotesViewModel.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//
import Foundation
import SwiftData

class NotesViewModel: ObservableObject {
    @Published var newNoteId: UUID?
    
    func addNote(modelContext: ModelContext) -> Note {
        let newNote = Note(title: "", content: "")
        modelContext.insert(newNote)
        try? modelContext.save()
        newNoteId = newNote.id
        return newNote
    }
    
    func deleteNotes(at offsets: IndexSet, notes: [Note], modelContext: ModelContext) {
        for index in offsets {
            modelContext.delete(notes[index])
        }
    }
    
    func saveNote(modelContext: ModelContext) {
        try? modelContext.save()
    }
    
    func toggleTask(_ task: DailyTask) {
        task.isChecked.toggle()
        task.checkedDate = task.isChecked ? Date() : nil
    }
}

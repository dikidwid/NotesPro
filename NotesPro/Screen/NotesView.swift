//
//  NotesView.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import SwiftUI
import SwiftData
import Foundation
import Combine

struct NotesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var notes: [Note]
    @StateObject private var viewModel = NotesViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if notes.isEmpty {
                    ContentUnavailableView(
                        "No Notes",
                        systemImage: "note.text",
                        description: Text("Start adding notes to see them here.")
                    )
                } else {
                    List {
                        ForEach(notes) { note in
                            NavigationLink(destination: NoteEditorView(note: note)) {
                                NoteRowView(note: note)
                            }
                        }
                        .onDelete { offsets in
                            viewModel.deleteNotes(at: offsets, notes: notes, modelContext: modelContext)
                        }
                    }
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.addNote() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.navigateToNewNote) {
                NoteEditorView(note: viewModel.newNote)
            }
        }
        .environmentObject(viewModel)
    }
}

struct NoteRowView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(note.title)
                .font(.headline)
            Text(note.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NotesView()
        .modelContainer(for: swiftDataModels)
}

//
//  NoteEditorView.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import SwiftUI
import SwiftData

struct NoteEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: NotesViewModel
    @Bindable var note: Note
    @FocusState private var isFocused: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                TextField("Title", text: $note.title, axis: .vertical)
                    .lineLimit(3)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top)
                    .focused($isFocused)
                    .autocorrectionDisabled()
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $note.content)
                        .font(.body)
                        .padding(.horizontal, 12)
                        .frame(minHeight: 200)
                        .focused($isFocused)
                        .autocorrectionDisabled()
                    
                    if note.content.isEmpty {
                        Text("Content")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                            .padding(.top, 8)
                    }
                }
                
                Spacer()
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {
                        isFocused = false
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            viewModel.saveNote(modelContext: modelContext)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Note.self, configurations: config)
        
        let sampleNote = Note(title: "Sample Note", content: "This is a sample note content.")
        return NoteEditorView(note: sampleNote)
            .environmentObject(NotesViewModel())
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

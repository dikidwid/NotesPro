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
    @State private var newTaskName: String = ""
    @State private var isTasksExpanded = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Section {
                    TextField("Title", text: $note.title, axis: .vertical)
                        .lineLimit(3)
                        .font(.title)
                        .fontWeight(.bold)
                        .focused($isFocused)
                        .autocorrectionDisabled()
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                
                if !note.tasks.isEmpty {
                    TasksAccordionView(note: note, isExpanded: $isTasksExpanded, viewModel: viewModel)
                }

                Section {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $note.content)
                            .font(.body)
                            .frame(minHeight: 600)
                            .focused($isFocused)
                            .autocorrectionDisabled()
                        
                        if note.content.isEmpty {
                            Text("Content")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .padding(.leading, 5)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                
                Spacer()
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
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

struct TasksAccordionView: View {
    @Bindable var note: Note
    @Binding var isExpanded: Bool
    @ObservedObject var viewModel: NotesViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Tasks")
                            .foregroundColor(.primary)
                            .font(.headline)
                        Text("TOEFL Test Habit")
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
            }
            .padding(.horizontal)
            
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(note.tasks) { task in
                        CheckboxTaskView(task: task, viewModel: viewModel)
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct CheckboxTaskView: View {
    @Bindable var task: DailyTask
    @ObservedObject var viewModel: NotesViewModel
    
    var body: some View {
        HStack {
            Image(systemName: task.isChecked ? "checkmark.circle.fill" : "circle")
                .onTapGesture {
                    viewModel.toggleTask(task)
                }
            VStack(alignment: .leading, spacing: 4) {
                Text(task.taskName)
                    .font(.body)
                Text("08.00")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color(.systemBackground))
        Divider()
    }
}

#Preview("Basic Note") {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Note.self, configurations: config)
        
        let sampleNote = Note(title: "Learn IELTS #1", content: "This is a sample note content.")
        return NoteEditorView(note: sampleNote)
            .environmentObject(NotesViewModel())
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

#Preview("Habit Note") {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Note.self, configurations: config)
        
        let sampleNote = Note(title: "Learn IELTS #1", content: "This is a sample note content.")
        sampleNote.tasks = [
            DailyTask(taskName: "Task Title"),
            DailyTask(taskName: "Task Title"),
            DailyTask(taskName: "Task Title")
        ]
        
        return NoteEditorView(note: sampleNote)
            .environmentObject(NotesViewModel())
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

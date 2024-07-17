import SwiftUI
import SwiftData

struct NotesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var notes: [Note]
    @StateObject private var viewModel = NotesViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(searchText: $searchText)
                    .padding()
                
                List {
                    if !todayNotes.isEmpty
                    {
                        NoteSection(title: "Today", subtitle: "Tue 9 Jul", notes: todayNotes)
                    }

                    if !previousWeekNotes.isEmpty
                    {
                        NoteSection(title: "Previous 7 Days", subtitle: "", notes: previousWeekNotes)
                    }

                    if !previousMonthNotes.isEmpty
                    {
                        NoteSection(title: "Previous 30 Days", subtitle: "", notes: previousMonthNotes)
                    }
                    
                    if todayNotes.isEmpty && previousWeekNotes.isEmpty && previousMonthNotes.isEmpty {
                        ContentUnavailableView {
                            Label("No Notes", systemImage: "note.text")
                        } description: {
                            Text("New notes you create will appear here.")
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        let newNote = viewModel.addNote(modelContext: modelContext)
                        viewModel.newNoteId = newNote.id
                    }) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .navigationDestination(item: $viewModel.newNoteId) { noteId in
                if let note = notes.first(where: { $0.id == noteId }) {
                    NoteEditorView(note: note)
                }
            }
        }
        .environmentObject(viewModel)
    }
    
    var todayNotes: [Note] {
        notes.filter { Calendar.current.isDateInToday($0.createdDate) }
    }
    
    var previousWeekNotes: [Note] {
        notes.filter {
            let date = $0.createdDate
            return !Calendar.current.isDateInToday(date) &&
            date > Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        }
    }
    
    var previousMonthNotes: [Note] {
        notes.filter {
            let date = $0.createdDate
            return !Calendar.current.isDateInToday(date) &&
            date <= Calendar.current.date(byAdding: .day, value: -7, to: Date())! &&
            date > Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        }
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Search", text: $searchText)
            Image(systemName: "mic")
                .foregroundColor(.secondary)
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct NoteSection: View {
    let title: String
    let subtitle: String
    let notes: [Note]
    
    var body: some View {
        Section(header: VStack(alignment: .leading) {
            Text(title)
                .textCase(.none)
                .font(.headline)
                .foregroundColor(.primary)
            if !subtitle.isEmpty {
                Text(subtitle)
                    .textCase(.none)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }) {
            ForEach(notes) { note in
                NavigationLink(destination: NoteEditorView(note: note)) {
                    NoteRowView(note: note)
                }
            }
        }
    }
}

struct NoteRowView: View {
    let note: Note
    
    var body: some View {
        HStack(spacing: 16) {
            
            VStack(alignment: .leading, spacing: 4) {
                Text(note.title)
                    .foregroundColor(.primary)
                    .font(.headline)
                Text(note.content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Note.self, configurations: config)
        
        // Create sample notes
        let todayNote1 = Note(title: "Beli Jus", content: "Ayam 1 Ikan 3 Beras 3kg Susu")
        todayNote1.createdDate = Date()
        
        let todayNote2 = Note(title: "TOEFL Test", content: "Subtitle")
        todayNote2.createdDate = Date()
        
        let weekNote1 = Note(title: "Beli Jus", content: "Ayam 1 Ikan 3 Beras 3kg Susu")
        weekNote1.createdDate = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        
        let weekNote2 = Note(title: "Persiapan Scholarship", content: "Sertifikat")
        weekNote2.createdDate = Calendar.current.date(byAdding: .day, value: -5, to: Date())!
        
        let monthNote1 = Note(title: "Bandung 2024!", content: "Ronde Alkateri Pandan Wangi")
        monthNote1.createdDate = Calendar.current.date(byAdding: .day, value: -15, to: Date())!
        
        let monthNote2 = Note(title: "Jogja 2024!", content: "Artjog Tinitah Bakpia Tugu")
        monthNote2.createdDate = Calendar.current.date(byAdding: .day, value: -25, to: Date())!
        
        // Add notes to the container
        container.mainContext.insert(todayNote1)
        container.mainContext.insert(todayNote2)
        container.mainContext.insert(weekNote1)
        container.mainContext.insert(weekNote2)
        container.mainContext.insert(monthNote1)
        container.mainContext.insert(monthNote2)
        
        return NotesView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

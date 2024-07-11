//
//  NewGoalView.swift
//  NotesPro
//
//  Created by Jason Susanto on 11/07/24.
//

import SwiftUI
import SwiftData

struct AddGoalView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    @State private var newGoalName: String = ""
    @State private var endDateGoal: Date = Date()
    @StateObject private var viewModel = GoalsViewModel()
    
    @State private var showAddHabitView: Bool = false
    @Query private var habits: [Habit]
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 0) {
                Divider()
                Form{
                    Section {
                        HStack{
                            Text("Name")
                                .padding(.trailing, 50)
                            TextField("Enter Goal Name", text: $viewModel.goal.title)
                            
                            Button {
                                viewModel.goal.title = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                            }

                        }
                        
                        DatePicker("End Date", selection: $viewModel.goal.deadlineDate, displayedComponents: .date)
                            .datePickerStyle(DefaultDatePickerStyle())
                    }
                    
                    Section{
                        ForEach(habits) {habit in
                            HabitRow(habit: habit) {
//                                habits.removeAll { $0.id == habit.id }
                            }
                        }
                        AddRow(titleRow: "add habit") {
                            showAddHabitView.toggle()
                        }
                        .sheet(isPresented: $showAddHabitView) {
                            AddHabitView()
                                .presentationDragIndicator(.visible)
                        }
                    }
                    
                    Section{
                        HStack {
                            Spacer()
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Delete Goal")
                                    .foregroundColor(.red)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitle("New Goal", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.yellow)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        _ = viewModel.addGoal(modelContext: modelContext)
                        viewModel.saveGoal(modelContext: modelContext)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.gray)
                }
            }
        }
    }
}

struct HabitRow: View {
    var habit: Habit
    var onDelete: () -> Void
    
    @State private var showDetailView: Bool = false
    
    var body: some View {
        HStack {
            Button(action: onDelete, label: {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
            })
//            .buttonStyle(BorderlessButtonStyle())
            
            HStack{
                VStack (alignment: .leading){
                    Text(habit.title)
                    Text(habit.desc)
                        .font(.footnote)
                        .opacity(0.6)
                }
                Spacer()
                Image(systemName: "chevron.right")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showDetailView.toggle()
            }
        }
        .sheet(isPresented: $showDetailView) {
            AddHabitView()
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Note.self, configurations: config)

        return AddGoalView()
            .environmentObject(GoalsViewModel())
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

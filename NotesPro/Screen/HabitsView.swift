//
//  GoalsView.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import SwiftUI
import SwiftData

struct HabitsView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var habitsViewModel: HabitsViewModel
    @EnvironmentObject private var addHabitViewModel: AddHabitViewModel
    @Query private var habits: [Habit]
    
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                
                HStack {
                    Text("15")
                    Text("16")
                    Text("17")
                    Text("18")
                    Text("19")
                }
                .padding()
                
                List {
                    ForEach(habits) { habit in
                        Button(action: {
                            habitsViewModel.selectHabit(habit)
                            addHabitViewModel.populateFromHabit(habit)
                        }) {
                            Text(habit.title)
                                .foregroundStyle(.primary)
                        }
                    }
                    .onDelete(perform: deleteHabits)
                }
                
                Spacer()
            }
            .navigationBarTitle("Habits", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        habitsViewModel.addNewHabit()
                        addHabitViewModel.populateFromHabit(nil)
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .sheet(isPresented: $habitsViewModel.isAddHabitSheetPresented) {
                AddHabitView()
                    .environmentObject(addHabitViewModel)
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    private func deleteHabits(at offsets: IndexSet) {
        for index in offsets {
            habitsViewModel.deleteHabit(habits[index], modelContext: modelContext)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, configurations: config)
        
        let habit = Habit(title: "Test1", description: "Desc 1")
        let habit2 = Habit(title: "Test2", description: "Desc 1")
        
        container.mainContext.insert(habit)
        container.mainContext.insert(habit2)
        
        let habitsViewModel = HabitsViewModel()
        let addHabitViewModel = AddHabitViewModel()
        
        return HabitsView()
            .modelContainer(container)
            .environmentObject(habitsViewModel)
            .environmentObject(addHabitViewModel)
        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

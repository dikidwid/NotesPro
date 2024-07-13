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
    @StateObject private var viewModel = HabitsViewModel()
    @State private var isAddHabitSheetPresented = false
    @State private var newHabit: Habit?
    @Query private var habits: [Habit]
    
    var body: some View {
        NavigationStack {
            VStack{
                Divider()
                
                HStack{
                    Text("15")
                    Text("16")
                    Text("17")
                    Text("18")
                    Text("19")
                }
                .padding()
                
                ForEach(habits) { habit in
                    Text(habit.title)
                        .foregroundStyle(.red)
                }
                
                Spacer()
            }
            .navigationBarTitle("Habits", displayMode: .inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAddHabitSheetPresented.toggle()
                        let habit = viewModel.addHabit(modelContext: modelContext)
                        newHabit = habit
                    } label: {
                        Image(systemName: "plus.app")
                            .foregroundColor(.orange)
                    }

                }
            })
            .sheet(isPresented: $isAddHabitSheetPresented, content: {
                if let habit = newHabit {
                    AddHabitView(habit: habit)
                        .presentationDragIndicator(.visible)
                        .environmentObject(viewModel)
                }
            })
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

        return HabitsView()
            .modelContainer(container)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

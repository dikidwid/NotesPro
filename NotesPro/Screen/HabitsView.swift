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
    @State private var selectedHabit: Habit?
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
                    Button(action: {
                        selectedHabit = habit
                    }, label: {
                        Text(habit.title)
                            .foregroundStyle(.red)
                    })
                }
                
                Spacer()
            }
            .navigationBarTitle("Habits", displayMode: .inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        let habit = viewModel.addHabit(modelContext: modelContext)
                        selectedHabit = habit
                    } label: {
                        Image(systemName: "plus.app")
                            .foregroundColor(.orange)
                    }
                    
                }
            })
            .onChange(of: selectedHabit, { oldValue, newValue in
                if newValue != nil {
                    isAddHabitSheetPresented = true
                }
            })
            .sheet(isPresented: $isAddHabitSheetPresented, content: {
                if let habit = selectedHabit {
                    AddHabitView(habit: habit)
                        .presentationDragIndicator(.visible)
                        .environmentObject(viewModel)
                        .environmentObject(AddHabitViewModel(modelContext: modelContext))
                        .onDisappear {
                            selectedHabit = nil
                        }
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
        
        let habitsViewModel = HabitsViewModel()
        let addHabitViewModel = AddHabitViewModel(modelContext: container.mainContext)
        
        return HabitsView()
            .modelContainer(container)
            .environmentObject(habitsViewModel)
            .environmentObject(addHabitViewModel)
        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

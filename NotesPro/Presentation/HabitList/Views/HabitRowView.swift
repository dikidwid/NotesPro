//
//  HabitRowView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 01/08/24.
//

import SwiftUI

struct HabitRowView<HabitListViewModel>: View where HabitListViewModel: HabitListViewModelProtocol {
    let habit: HabitModel
    @Environment(\.colorScheme) private var isDarkMode
    @ObservedObject var habitViewModel: HabitListViewModel
    
    @EnvironmentObject var coordinator: AppCoordinatorImpl
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(habit.habitName)
                        .font(.system(.headline))
                    
                    if habit.isDefinedTaskEmpty(for: habitViewModel.selectedDate) {
                        Text("No task defined")
                            .font(.system(.subheadline))
                            .foregroundStyle(.secondary)
                    } else {
                        Text("\(habit.totalUndoneTask(for: habitViewModel.selectedDate)) tasks to do")
                            .font(.system(.subheadline))
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                HStack {
                    Label("\(habit.currentStreak)", systemImage: "flame.fill")
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.secondary)
            }
            
            Divider()
                .padding(.all, 5)
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(habit.tasks(for: habitViewModel.selectedDate)) { task in
                    CheckboxTaskView(checkboxTaskViewModel: coordinator.container.makeCheckboxTaskViewModel(task: task, 
                                                                                                            habit: habit,
                                                                                                            date: habitViewModel.selectedDate)) { task in
                        Task {
                            await habitViewModel.fetchHabits()
                        }
                    }
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(isDarkMode == .dark ? Color(.secondarySystemGroupedBackground) : .white)
        }
        .padding(.horizontal)
    }
}

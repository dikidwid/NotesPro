//
//  EditHabitViewModel.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 25/07/24.
//

import Foundation

final class EditHabitViewModel: ObservableObject {
    @Published var habit: HabitModel
    @Published var selectedTask: TaskModel?

    let updateHabitUseCase: UpdateHabitUseCase
    
    var isValidHabit: Bool {
        !habit.habitName.isEmpty && !habit.definedTasks.isEmpty
    }
    
    init(habit: HabitModel,
         updateHabitUseCase: UpdateHabitUseCase
    ) {
        self.updateHabitUseCase = updateHabitUseCase
        self.habit = habit
    }
    
    func createNewTask() {
        let newTask = TaskModel(taskName: "")
        habit.definedTasks.append(newTask)
        selectedTask = newTask
    }
    
    func updateTask(_ task: TaskModel) {
        if let index = habit.definedTasks.firstIndex(where: { $0.id == task.id }) {
            habit.definedTasks[index] = task
        }
    }
    
    func deleteTask(_ task: TaskModel) {
        habit.definedTasks.removeAll { $0.id == task.id }
    }
    
    func setSelectedTask(to task: TaskModel) {
        selectedTask = task
    }
    
    func saveHabit() {
        updateHabitUseCase.execute(for: habit)
    }
}

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

    let addTaskUseCase: AddTaskUseCase
    let updateHabitUseCase: UpdateHabitUseCase
    let deleteTaskUseCase: DeleteTaskUseCase
    
    var isValidHabit: Bool {
        !habit.habitName.isEmpty && !habit.definedTasks.isEmpty
    }
    
    init(habit: HabitModel, addTaskUseCase: AddTaskUseCase, updateHabitUseCase: UpdateHabitUseCase, deleteTaskUseCase: DeleteTaskUseCase) {
        self.addTaskUseCase = addTaskUseCase
        self.updateHabitUseCase = updateHabitUseCase
        self.deleteTaskUseCase = deleteTaskUseCase
        self.habit = habit
    }
    
    func createNewTask() {
        let newTask = TaskModel(taskName: "")
        habit.definedTasks.append(newTask)
        for habitEntryIndex in habit.dailyHabitEntries.indices {
            habit.dailyHabitEntries[habitEntryIndex].tasks.append(newTask)
        }
        selectedTask = newTask
    }
    
    #warning("Create OK but not with the Update one")
    func updateTask(_ task: TaskModel) {
        var newTask = task
        newTask.habit = habit
        addTaskUseCase.execute(newTask)
        if let index = habit.definedTasks.firstIndex(where: { $0.id == task.id }) {
            habit.definedTasks[index] = task
        }
    }
    
    func deleteTask(_ task: TaskModel) {
        deleteTaskUseCase.execute(task)
        habit.definedTasks.removeAll { $0.id == task.id }
    }
    
    func setSelectedTask(to task: TaskModel) {
        selectedTask = task
    }
    
    func saveHabitAndDismiss(with coordinator: AppCoordinatorImpl) {
        updateHabitUseCase.execute(for: habit)
        coordinator.dismissSheet()
    }
}

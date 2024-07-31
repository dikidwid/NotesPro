//
//  AppDIContainer.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 25/07/24.
//

import Foundation

class AppDIContainer {
    // MARK: - Persistent Mock Repository
    lazy var habitRepository: HabitRepository = HabitRepositoryMock.shared
    
    // MARK: - Use Cases
    func makeAddHabitUseCase() -> AddHabitUseCase {
        AddHabitUseCase(repository: habitRepository)
    }
    
    func makeGetHabitsUseCase() -> GetHabitsUseCase {
        GetHabitsUseCase(repository: habitRepository)
    }
    
    func makeGetHabitEntryUseCase() -> GetHabitEntryUseCase {
        GetHabitEntryUseCase(repository: habitRepository)
    }
    
    func makeUpdateHabitUseCase() -> UpdateHabitUseCase {
        UpdateHabitUseCase(repository: habitRepository)
    }
    
    func makeDeleteHabitUseCase() -> DeleteHabitUseCase {
        DeleteHabitUseCase(repository: habitRepository)
    }
    
    func makeAddTaskUseCase() -> AddTaskUseCase {
        AddTaskUseCase(repository: habitRepository)
    }
    
    func makeUpdateTaskUseCase() -> UpdateTaskUseCase {
        UpdateTaskUseCase(repository: habitRepository)
    }
    
    func makeDeleteTaskUseCase() -> DeleteTaskUseCase {
        DeleteTaskUseCase(repository: habitRepository)
    }
    
    func makeUpdateHabitEntryUseCase() -> UpdateHabitEntryUseCase {
        UpdateHabitEntryUseCase(repository: habitRepository)
    }

    
    // MARK: - ViewModel
    func makeHabitViewModel() -> HabitViewModelMock {
        HabitViewModelMock(getHabitsUseCase: makeGetHabitsUseCase(), 
                           updateTaskUseCase: makeUpdateTaskUseCase(),
                           updateHabitEntryNoteUseCase: makeUpdateHabitEntryUseCase())
    }
    
    func makeHabitDetailViewModel(for habit: HabitModel, with date: Date) -> HabitDetailViewModel {
        HabitDetailViewModel(for: habit,
                             on: date,
                             getHabitEntryUseCase: makeGetHabitEntryUseCase(),
                             updateHabitEntryUseCase: makeUpdateHabitEntryUseCase(),
                             deleteHabitUseCase: makeDeleteHabitUseCase())
    }
    
    func makeAddHabitViewModel(habitRepository: HabitRepository) -> AddHabitViewModell {
        AddHabitViewModell(addHabitUseCase: makeAddHabitUseCase())
    }
    
    func makeEditHabitViewModel(habit: HabitModel) -> EditHabitViewModel {
        EditHabitViewModel(habit: habit, addTaskUseCase: makeAddTaskUseCase(),
                           updateHabitUseCase: makeUpdateHabitUseCase(),
                           deleteTaskUseCase: makeDeleteTaskUseCase())
    }
    
    
    func makeAIHabitViewModel() -> AIHabitViewModel {
        AIHabitViewModel()
    }
    
    
    
    func makeCheckboxTaskViewModel(task: TaskModel) -> CheckboxTaskViewModel {
        CheckboxTaskViewModel(task: task, updateTaskUseCase: makeUpdateTaskUseCase())
    }
    
    func makeDetailTaskViewModel(task: TaskModel) -> DetailTaskViewModel {
        DetailTaskViewModel(selectedTask: task)
    }
}

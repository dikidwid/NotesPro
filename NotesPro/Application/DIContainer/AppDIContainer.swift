//
//  AppDIContainer.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 25/07/24.
//

import Foundation
import SwiftData

class AppDIContainer {
        
    init(swiftDataContainer: ModelContainer) {
        self.habitRepository = HabitRepositoryImpl(dataSource: SwiftDataManager(modelContainer: swiftDataContainer))
        self.habitEntryRepository = HabitEntryRepositoryImpl(dataSource: SwiftDataManager(modelContainer: swiftDataContainer))
        self.taskRepository = TaskRepositoryImpl(dataSource: SwiftDataManager(modelContainer: swiftDataContainer))
    }
    
    // MARK: - Persistent Mock Repository
    let habitRepository: HabitRepository
    let habitEntryRepository: HabitEntryRepository
    let taskRepository: TaskRepository
    
    // MARK: - Use Cases
    func makeAddHabitUseCase() -> AddHabitUseCase {
        AddHabitUseCase(repository: habitRepository)
    }
    
    func makeGetHabitsUseCase() -> GetHabitsUseCase {
        GetHabitsUseCase(repository: habitRepository)
    }
    
    func makeGetHabitEntryUseCase() -> GetHabitEntryUseCase {
        GetHabitEntryUseCase(repository: habitEntryRepository)
    }
    
    func makeUpdateHabitEntryUseCase() -> UpdateHabitEntryUseCase {
        UpdateHabitEntryUseCase(repository: habitEntryRepository)
    }
    
    func makeUpdateHabitUseCase() -> UpdateHabitUseCase {
        UpdateHabitUseCase(repository: habitRepository)
    }
    
    func makeDeleteHabitUseCase() -> DeleteHabitUseCase {
        DeleteHabitUseCase(repository: habitRepository)
    }

    func makeUpdateTaskUseCase() -> UpdateTaskUseCase {
        UpdateTaskUseCase(repository: taskRepository)
    }

    
    // MARK: - ViewModel
    func makeHabitViewModel() -> HabitListViewModelMock {
        HabitListViewModelMock(getHabitsUseCase: makeGetHabitsUseCase(),
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
        EditHabitViewModel(habit: habit,
                           updateHabitUseCase: makeUpdateHabitUseCase())
    }
    
    
    func makeAIHabitViewModel() -> AIHabitViewModel {
        AIHabitViewModel(aiService: makeAIService())
    }
    
    func makeAIService() -> AIService {
        AIService(identifier: AICreds.freeAICreds.rawValue,
                  useStreaming: false,
                  isConversation: false)
    }
    
    func makeCheckboxTaskViewModel(task: TaskModel, habit: HabitModel, date: Date) -> CheckboxTaskViewModel {
        CheckboxTaskViewModel(task: task, taskHabit: habit, taskDate: date, updateTaskUseCase: makeUpdateTaskUseCase())
    }
    
    func makeDetailTaskViewModel(task: TaskModel) -> DetailTaskViewModel {
        DetailTaskViewModel(selectedTask: task)
    }
}

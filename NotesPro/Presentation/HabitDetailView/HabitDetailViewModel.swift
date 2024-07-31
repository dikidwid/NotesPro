//
//  HabitDetailViewModel.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 25/07/24.
//

import Foundation

final class HabitDetailViewModel: ObservableObject {
    @Published var isShowEditHabitView: Bool = false
    @Published var isShowDeleteConfirmation: Bool = false
    @Published var entryHabit: DailyHabitEntryModel
    @Published var selectedDate: Date
    @Published var note: String = ""
    
    let getHabitEntryUseCase: GetHabitEntryUseCase
    let updateHabitEntryUseCase: UpdateHabitEntryUseCase
    let deleteHabitUseCase: DeleteHabitUseCase
    
    init(for habit: HabitModel, 
         on date: Date,
         getHabitEntryUseCase: GetHabitEntryUseCase,
         updateHabitEntryUseCase: UpdateHabitEntryUseCase, 
         deleteHabitUseCase: DeleteHabitUseCase
    ) {
        self.getHabitEntryUseCase = getHabitEntryUseCase
        self.updateHabitEntryUseCase = updateHabitEntryUseCase
        self.deleteHabitUseCase = deleteHabitUseCase
        self.selectedDate = date
        self.entryHabit = getHabitEntryUseCase.execute(for: habit, on: date)
        self.note = getHabitEntryUseCase.execute(for: habit, on: date).note
    }
    
    func refreshHabitEntry(to date: Date) {
        updateHabitEntryNote()
        self.selectedDate = date
        self.note = getHabitEntryUseCase.execute(for: entryHabit.habit, on: date).note
        self.entryHabit = getHabitEntryUseCase.execute(for: entryHabit.habit, on: date)
    }
    
    func updateHabitEntryNote() {
        updateHabitEntryUseCase.execute(habitEntry: DailyHabitEntryModel(id: entryHabit.id,
                                                                         date: entryHabit.date,
                                                                         note: note,
                                                                         habit: entryHabit.habit,
                                                                         tasks: entryHabit.tasks))
    }
    
    func updateTask(_ task: TaskModel) {
        if let index = entryHabit.tasks.firstIndex(where: {$0.id == task.id}) {
            entryHabit.tasks[index] = task
        }
    }
    
    func updateHabit() {
        entryHabit = getHabitEntryUseCase.execute(for: entryHabit.habit, on: selectedDate)
    }
    
    func deleteHabitAndPop(with coordinator: AppCoordinatorImpl) {
        coordinator.pop()
        deleteHabitUseCase.execute(for: entryHabit.habit)
    }
}

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
    @Published var entryHabit: HabitEntryModel
    @Published var selectedDate: Date
    @Published var habit: HabitModel
    
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
        self.habit = habit
        self.selectedDate = date
        self.entryHabit = getHabitEntryUseCase.execute(for: habit, on: date)
    }
    
    func refreshHabitEntry(to date: Date) {
        updateHabitEntryNote()
        self.selectedDate = date
        self.entryHabit = getHabitEntryUseCase.execute(for: habit, on: date)
        print(entryHabit.tasks)
    }
    
    func updateHabitEntryNote() {
        updateHabitEntryUseCase.execute(habitEntry: entryHabit)
    }
    
    func deleteHabitAndPop(with coordinator: AppCoordinatorImpl) {
        coordinator.pop()
        deleteHabitUseCase.execute(for: habit)
    }
    
    func updateHabit(_ updatedHabit: HabitModel) {
        habit = updatedHabit
        entryHabit = getHabitEntryUseCase.execute(for: habit, on: selectedDate)
    }
}

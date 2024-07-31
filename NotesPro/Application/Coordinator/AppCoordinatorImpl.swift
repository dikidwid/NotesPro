//
//  AppCoordinatorImpl.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 25/07/24.
//

import SwiftUI

final class AppCoordinatorImpl: AppCoordinatorProtocol {
    @Published var path: NavigationPath = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    
    let container: AppDIContainer = AppDIContainer()
    
    // MARK: - Navigation functions
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func present(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func fullScreenCover(_ fullScreenCover: FullScreenCover) {
//        self.fullScreenCover = fullScreenCover
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        sheet = nil
    }
    
    func dismissFullScreenOver() {
        fullScreenCover = nil
    }
    
    
    // MARK: - View Providers
    func createHabitListView() -> some View {
        HabitListView(habitViewModel: container.makeHabitViewModel())
    }
    
    func createHabitDetailView(for habit: HabitModel, with date: Date) -> some View {
        HabitDetailVieww(habitDetailViewModel: container.makeHabitDetailViewModel(for: habit, with: date))
    }
    
    #warning("Update the AddHabitView to not dependandt to habitVIewModel")
    func createAddHabitView() -> some View {
        AddNewHabitView(addHabitViewModel: container.makeAddHabitViewModel(habitRepository: container.habitRepository),
                        habitViewModel: container.makeHabitViewModel())
    }
    
    func createEditHabitView(for habit: HabitModel) -> some View {
        EditHabitView(editHabitViewModel: container.makeEditHabitViewModel(habit: habit))
    }
    
    func createDetailTaskView(for task: TaskModel, onSaveTapped: @escaping ((TaskModel) -> Void?)) -> some View {
        DetailTaskView(detailTaskViewModel: container.makeDetailTaskViewModel(task: task), onSaveTapped: onSaveTapped)
    }
    
    func createAIOnBoardingView() -> some View {
        AIOnboardingView(aiHabitViewModel: container.makeAIHabitViewModel())
    }

    // MARK: - Presentation Style Providers
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .listHabit:
            createHabitListView()
        case .detailHabit(let habit, let date):
            createHabitDetailView(for: habit, with: date)
        case .detailTask(let task, let onDismiss):
            createDetailTaskView(for: task, onSaveTapped: onDismiss)
        }
    }
    
    @ViewBuilder
    func build(_ sheet: Sheet) -> some View {
        switch sheet {
        case .addHabit:
            createAddHabitView()
        case .editHabit(let habit):
            createEditHabitView(for: habit)
        case .aiOnboarding:
            createAIOnBoardingView()
        }
    }
    
    @ViewBuilder
    func build(_ fullScreenCover: FullScreenCover) -> some View {
//        switch fullScreenCover {
//        default:
//            Text("gada screen fullScreenCover hehe")
//        }
    }
}

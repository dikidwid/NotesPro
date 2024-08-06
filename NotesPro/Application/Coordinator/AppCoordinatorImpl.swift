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
    
    init(container: AppDIContainer) {
        self.container = container
    }
    
    let container: AppDIContainer
        
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
        HabitDetailVieww(habitDetailViewModel: self.container.makeHabitDetailViewModel(for: habit, with: date))
    }
    
    #warning("Update the AddHabitView to not dependandt to habitVIewModel")
    func createAddHabitView(onDismiss: @escaping ((HabitModel) -> Void?)) -> some View {
        AddNewHabitView(addHabitViewModel: container.makeAddHabitViewModel(habitRepository: container.habitRepository), onDismiss: onDismiss)
    }
    
    func createEditHabitView(for habit: HabitModel, onSaveTapped: @escaping ((HabitModel) -> Void?)) -> some View {
        EditHabitView(editHabitViewModel: self.container.makeEditHabitViewModel(habit: habit), onSaveTapped: onSaveTapped)
    }
    
    func createDetailTaskView(for task: TaskModel, onSaveTapped: @escaping ((TaskModel) -> Void?)) -> some View {
        DetailTaskView(detailTaskViewModel: container.makeDetailTaskViewModel(task: task), onSaveTapped: onSaveTapped)
    }
    
    func createAIOnBoardingView(onDismiss: @escaping ((Recommendation) -> Void?)) -> some View {
        AIOnboardingView(aiHabitViewModel: container.makeAIHabitViewModel(), onDismiss: onDismiss)
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
        case .addHabit(let onDismiss):
            createAddHabitView(onDismiss: onDismiss)
        case .aiOnboarding(let onDismiss):
            createAIOnBoardingView(onDismiss: onDismiss)
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

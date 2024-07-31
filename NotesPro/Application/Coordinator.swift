////
////  Coordinator.swift
////  NotesPro
////
////  Created by Diki Dwi Diro on 25/07/24.
////
//
//import SwiftUI
//
//
//
////@MainActor
//final class Coordinator: ObservableObject {
//    @Published var path: NavigationPath = NavigationPath()
//    @Published var page: Screen = .listHabit
//    @Published var sheet: Sheet?
//    
//    let container: AppDIContainer = AppDIContainer()
//    
//    // MARK: - Navigation functions
//    func goHabitList() {
//        sheet = nil
//        path.removeLast(path.count)
//    }
//    
//    func goAddHabit() {
//        sheet = Sheet.addHabit
//    }
//    
//    func goEditHabit(_ habit: HabitModel) {
//        sheet = Sheet.editHabit(habit)
//    }
//    
//    func goDetailTask(_ task: TaskModel) {
//        path.append(Screen.detailTask(task))
//    }
//    
//    func goHabitDetail(_ habit: HabitModel, with date: Date) {
//        path.append(Screen.detailHabit(habit, date))
//    }
//    
//    func dismissSheet() {
//        sheet = nil
//    }
//    
//    func pop() {
//        path.removeLast()
//    }
//    
//    func popToRoot() {
//            path.removeLast(path.count) // path.count - 1 is not pop to SplashScreen
//        }
//        
//    
//    // MARK: - View Providers
//    @ViewBuilder
//    func createHabitListView() -> some View {
//        HabitListView(habitViewModel: HabitViewModelMock(getHabitsUseCase: container.makeGetHabitsUseCase(),
//                                                         updateTaskUseCase: container.makeUpdateTaskUseCase(), 
//                                                         updateHabitEntryNoteUseCase: container.makeUpdateHabitEntryUseCase()))
//    }
//    
//    #warning("Update the AddHabitView to not dependandt to habitVIewModel")
//    @ViewBuilder
//    func createAddHabitView() -> some View {
//        AddNewHabitView(addHabitViewModel: container.makeAddHabitViewModel(habitRepository: container.habitRepository),
//                        habitViewModel: container.makeHabitViewModel())
//    }
//    
//    func createEditHabitView(for habit: HabitModel) -> some View {
//        EditHabitView(editHabitViewModel: container.makeEditHabitViewModel(habit: habit))
//    }
//    
//    func createDetailTaskView(for task: TaskModel) -> some View {
//        DetailTaskView(addHabitViewModel: container.makeAddHabitViewModel(habitRepository: container.habitRepository),
//                       detailTaskViewModel: container.makeDetailTaskViewModel(task: task))
//    }
//    
//    @ViewBuilder
//    func createHabitDetailView(for habit: HabitModel, with date: Date) -> some View {
//        HabitDetailVieww(habitDetailViewModel: container.makeHabitDetailViewModel(for: habit, with: date))
//    }
//
//    
//    // MARK: - Navigation Style Providers
//    @ViewBuilder
//    func getPage(_ page: Screen) -> some View {
//        switch page {
//        case .listHabit:
//            createHabitListView()
//        case .detailHabit(let habit, let date):
//            createHabitDetailView(for: habit, with: date)
//        case .detailTask(let task):
//            createDetailTaskView(for: task)
//        }
//    }
//    
//    @ViewBuilder
//    func getSheet(_ sheet: Sheet) -> some View {
//        switch sheet {
//        case .addHabit:
//            createAddHabitView()
//        case .editHabit(let habit):
//            createEditHabitView(for: habit)
//        }
//    }
//}

//
//  AppCoordinatorProtocol.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 25/07/24.
//

import SwiftUI

enum Screen: Identifiable {
    case listHabit
    case detailHabit(HabitModel, Date)
    case detailTask(TaskModel, ((TaskModel) -> Void?))
    
    var id: Self { return self }
}

extension Screen: Hashable {
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        switch self {
        case .detailTask:
            hasher.combine(0)
        case .listHabit:
            hasher.combine(0)
        case .detailHabit(_, _):
            hasher.combine(0)
        }
    }

    static func == (lhs: Screen, rhs: Screen) -> Bool {
        switch(lhs, rhs) {
        case(.detailTask, .detailTask):
            return true
        default:
            return false
        }
    }
}

enum Sheet: Identifiable, Hashable {
    case addHabit
    case editHabit(HabitModel)
    case aiOnboarding
    
    var id: Self { return self }
}

enum FullScreenCover {
    
}

protocol AppCoordinatorProtocol: ObservableObject {
    var path: NavigationPath { get set }
    var sheet: Sheet? { get set }
    var fullScreenCover: FullScreenCover? { get set }
    func push(_ screen:  Screen)
    func present(_ sheet: Sheet)
    func fullScreenCover(_ fullScreenCover: FullScreenCover)
    func pop()
    func popToRoot()
    func dismissSheet()
    func dismissFullScreenOver()
}

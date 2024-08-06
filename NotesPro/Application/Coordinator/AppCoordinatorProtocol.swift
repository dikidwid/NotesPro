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

enum Sheet: Identifiable {
    case addHabit(onDismiss: ((HabitModel) -> Void?))
    case aiOnboarding(onDismiss: ((Recommendation) -> Void?))
    
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

//MARK:-- Conformance to Hashable Protocol beaase of closure on detailTask case
extension Screen: Hashable {
    // Conform to Hashable
    func hash(into hasher: inout Hasher) {
        switch self {
        case .detailTask:
            hasher.combine("detailTask")
        case .listHabit:
            hasher.combine("listHabit")
        case .detailHabit(_, _):
            hasher.combine("detailHabit")
        }
    }

    // Conform to Equatable
    static func == (lhs: Screen, rhs: Screen) -> Bool {
        switch(lhs, rhs) {
        case(.detailTask, .detailTask):
            return true
        default:
            return false
        }
    }
}

//MARK:-- Conformance to Hashable Protocol beaase of closure on aiOnboarding case
extension Sheet: Hashable {
    // Conform to Equatable
    static func == (lhs: Sheet, rhs: Sheet) -> Bool {
        switch(lhs, rhs) {
        case (.addHabit, .addHabit):
            return true
        default:
            return false
        }
    }
    
    // Conform to Hashable
    func hash(into hasher: inout Hasher) {
        switch self {
        case .addHabit:
            hasher.combine("addHabit")
        case .aiOnboarding(_):
            hasher.combine("aiOnboarding")

        }
    }
    
}

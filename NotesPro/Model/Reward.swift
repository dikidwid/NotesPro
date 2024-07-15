//
//  Reward.swift
//  NotesPro
//
//  Created by Jason Susanto on 12/07/24.
//

import Foundation
import SwiftData

@Model
final class Reward {
    var id: UUID
    var rewardName: String
    var isChecked: Bool
    var createdDate: Date
    var checkedDate: Date?

    init(rewardName: String) {
        self.id = UUID()
        self.rewardName = rewardName
        self.isChecked = false
        self.createdDate = Date()
    }
}

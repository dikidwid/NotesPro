//
//  Note.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import Foundation
import SwiftData

@Model
final class Note: Identifiable {
    var id: UUID
    var createdDate: Date
    var title: String
    var content: String
    
    init(title: String, content: String) {
        self.id = UUID()
        self.createdDate = Date()
        self.title = title
        self.content = content
    }
}

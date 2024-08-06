//
//  Message.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 01/08/24.
//

import Foundation

struct Message: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUser: Bool
    var displayedText: String
    
    init(text: String, isUser: Bool) {
        self.text = text
        self.isUser = isUser
        self.displayedText = isUser ? text : ""
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
}

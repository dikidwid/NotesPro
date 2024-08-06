//
//  LLMBlockingResponse.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 01/08/24.
//

import Foundation

// Define the blocking response model
struct LLMBlockingResponse: Decodable {
    let event: String
    let message_id: String?
    let conversation_id: String?
    let answer: String?
    let created_at: Int?
}

//
//  RecommendationsResponse.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 01/08/24.
//

import Foundation

struct RecommendationsResponse: Codable {
    let recommendations: [RecommendationResponse]
}

struct RecommendationResponse: Codable {
    let title: String
    let tasks: [String]
}

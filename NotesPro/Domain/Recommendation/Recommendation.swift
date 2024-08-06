//
//  Recommendation.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 01/08/24.
//

import Foundation

struct Recommendation: Identifiable {
    let id = UUID()
    let title: String
    let items: [String]
}

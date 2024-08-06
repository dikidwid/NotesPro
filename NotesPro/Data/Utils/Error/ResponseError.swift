//
//  ResponseError.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 17/07/24.
//

import Foundation

enum ResponseError: Error, Hashable, Identifiable, Equatable, LocalizedError {
    var id: Self { self }
    
    case networkError(cause: String)
    case localStorageError(cause: String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let cause):
            return cause
        case .localStorageError(let cause):
            return cause
        }
    }
}

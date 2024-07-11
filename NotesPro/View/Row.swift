//
//  Row.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import SwiftUI

struct AddRow: View {
    let titleRow: String
    var onAdd: () -> Void
    
    var body: some View {
        Button(action: onAdd) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
                Text(titleRow)
                    .foregroundColor(.black)
            }
        }
    }
}

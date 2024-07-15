//
//  Row.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import SwiftUI

func addButton(title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        HStack{
            Image(systemName: "plus.circle.fill")
                .foregroundColor(.green)
                .font(.title3)
                .padding(.trailing, 12)
            
            Text(title)
                .foregroundStyle(.appBlack)
        }
    }
}

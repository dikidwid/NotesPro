//
//  UserBubble.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 01/08/24.
//

import SwiftUI

struct UserBubble: View {
    let text: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(Color(.black))
                .cornerRadius(15)
                .frame(maxWidth: 280, alignment: .trailing)
        }
    }
}

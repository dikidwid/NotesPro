//
//  BotBubble.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 01/08/24.
//

import SwiftUI

struct BotBubble: View {
    @Binding var message: Message
    
    var body: some View {
        HStack {
            TypewriterTextView(message.text)
                .padding()
                .background(Color(.gray).opacity(0.1))
                .cornerRadius(15)
                .frame(maxWidth: 280, alignment: .leading)
            Spacer()
        }
    }
}

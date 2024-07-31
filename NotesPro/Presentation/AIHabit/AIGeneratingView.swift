//
//  AIGeneratingView.swift
//  NotesPro
//
//  Created by Arya Adyatma on 16/07/24.
//

import SwiftUI

struct AIGeneratingView: View {
    @State private var ellipsis = ""
    private let ellipsisStates = ["", ".", "..", "..."]
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea(edges: .top)
            
            Image(.aiOnboardingBG)
                .resizable()
                .padding(.top, 75)
            
            VStack {
                Spacer()
                
                Text("The AI is Generating Your Habits...")
                    .font(.system(.largeTitle, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.top, 35)
                
//                Text(" \(ellipsis) ")
//                    .foregroundStyle(.accent)
//                    .font(.system(.largeTitle, weight: .bold))

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .onAppear {
                startEllipsisAnimation()
            }
        }
    }
    
    private func startEllipsisAnimation() {
        var currentIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            ellipsis = ellipsisStates[currentIndex]
            currentIndex = (currentIndex + 1) % ellipsisStates.count
        }
    }
}

#Preview {
    AIGeneratingView()
}

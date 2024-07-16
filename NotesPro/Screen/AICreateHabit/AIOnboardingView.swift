//
//  AIOnboardingView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 16/07/24.
//

import SwiftUI

struct AIOnboardingView: View {
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea(edges: .top)
            
            Image(.aiOnboardingBG)
                .resizable()
                .padding(.top, 75)
            
            VStack(alignment: .leading) {
                Spacer()
                
                Text("Hey,\nI'm ready to\nhelp you here!")
                    .font(.system(.largeTitle, weight: .bold))
                    .padding(.bottom, 35)
                    .padding(.top, 100)
                
                Text("AI will help you generated a few\ntasks from your prompt")
                    .font(.system(.body))
            
                Spacer()
                
                Button {
                    
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .overlay {
                            Text("I'm Ready")
                                .font(.system(.headline))
                                .foregroundStyle(.black)
                        }
                        .frame(height: 44)
                }
                .padding(.bottom, 7)
                
                Text("AI will only give you some suggestions. The decision is still yours to make!")
                    .font(.system(.caption))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}

#Preview {
    AIOnboardingView()
}

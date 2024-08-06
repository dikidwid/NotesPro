//
//  RecommendationCard.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 01/08/24.
//

import SwiftUI

struct RecommendationCard: View {
    let recommendation: Recommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(recommendation.title)
                    .font(.headline)
                    .padding(.vertical, 10)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.accentColor)
            }
            .padding(.horizontal)
            
            ForEach(recommendation.items, id: \.self) { item in
                Text(item)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                Divider()
                    .padding(.leading)
            }
        }
        .background(Color(.gray).opacity(0.1))
        .cornerRadius(10)
    }
}

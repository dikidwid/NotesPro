////
////  AIRecommendationVIew.swift
////  NotesPro
////
////  Created by Arya Adyatma on 16/07/24.
////
//
//import SwiftUI
//
//struct Recommendation: Identifiable {
//    let id = UUID()
//    let habitName: String
//    let items: [String]
//}
//
//struct RecommendationCard: View {
//    let recommendation: Recommendation
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            HStack {
//                Text(recommendation.title)
//                    .font(.headline)
//                    .padding(.vertical, 10)
//                Spacer()
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.accentColor)
//            }
//            .padding(.horizontal)
//            
//            ForEach(recommendation.items, id: \.self) { item in
//                Text(item)
//                    .padding(.vertical, 10)
//                    .padding(.horizontal)
//                Divider()
//                    .padding(.leading)
//            }
//        }
//        .background(Color(UIColor.secondarySystemGroupedBackground))
//        .cornerRadius(10)
//    }
//}
//
//struct AIRecommendationVIew: View {
//    let recommendations = [
//        Recommendation(title: "Recommendation 1", items: ["Search for new book", "Read book for 5 minutes"]),
//        Recommendation(title: "Recommendation 2", items: ["Search for new articles", "Read articles for 10 minutes"]),
//        Recommendation(title: "Recommendation 3", items: ["Buy new book", "Read book for 15 minutes"])
//    ]
//    
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                ForEach(recommendations) { recommendation in
//                    RecommendationCard(recommendation: recommendation)
//                }
//            }
//            .padding()
//        }
//        .background(Color(UIColor.systemGroupedBackground))
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        AIRecommendationVIew()
//    }
//}

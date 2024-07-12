//
//  GoalsView.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import SwiftUI

struct HabitsView: View {
    
    @State var goToNextPage = false
    
    var body: some View {
        NavigationStack {
            VStack{
                Divider()
                
                HStack{
                    Text("15")
                    Text("16")
                    Text("17")
                    Text("18")
                    Text("19")
                }
                
                Spacer()
            }
            .navigationBarTitle("Habits", displayMode: .inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        goToNextPage.toggle()
                    } label: {
                        Image(systemName: "plus.app")
                            .foregroundColor(.orange)
                    }

                }
            })
            .sheet(isPresented: $goToNextPage, content: {
                AddHabitView()
                    .presentationDragIndicator(.visible)
            })
        }
    }
}

#Preview {
    HabitsView()
}

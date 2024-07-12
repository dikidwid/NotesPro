//
//  AddHabitView.swift
//  NotesPro
//
//  Created by Jason Susanto on 12/07/24.
//

import SwiftUI

struct AddHabitView: View {
    
    
    
    var body: some View {
        NavigationStack{
            VStack(spacing:0) {
                Divider()
                
                Form {
                    Section {
                        Text("Habit Name")
                    } header: {
                        Text("Habit")
                    }
                    
                    Section {
                        HStack {
                            Button {
                                print("action")
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title3)
                            }
                            .padding(.trailing, 12)

                            
                            HStack{
                                VStack (alignment: .leading){
                                    Text("Read the book for 5 minutes")
                                    Text("Everyday on 08.00 PM")
                                        .font(.footnote)
                                        .opacity(0.6)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .opacity(0.3)
                            }
                            .contentShape(Rectangle())
                        }
                        
                        HStack {
                            Button {
                                print("action")
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.title3)
                            }
                            .padding(.trailing, 12)

                            
                            Text("Add Task")
                        }
                        
                    } header: {
                        Text("Tasks")
                    }
                    
                    
                    Section {
                        HStack {
                            Button {
                                print("action")
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title3)
                            }
                            .padding(.trailing, 12)

                            
                            Text("Enjoy a cup of tea after reading")
                        }
                    } header: {
                        Text("Rewards")
                    }
                    
                    Section {
                        HStack {
                            Button {
                                print("action")
                            } label: {
                                HStack(spacing: 0){
                                    Text("Generate Habits with AI ")
                                    Image(systemName: "sparkles")
                                }
                                .foregroundColor(.orange)
                            }
                            .padding(.trailing, 12)
                        }
                    } header: {
                        Text("or use Apple Intelligence habit Generator ")
                    }
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        print("yay")
                    }, label: {
                        Text("Cancel")
                    })
                    .foregroundColor(.orange)
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        print("yay")
                    }, label: {
                        Text("Add")
                    })
                    .foregroundColor(.orange)
                }
            })
        }
    }
}

#Preview {
    AddHabitView()
}

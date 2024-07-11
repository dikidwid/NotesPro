////
////  DetailHabitView.swift
////  NotesPro
////
////  Created by Jason Susanto on 12/07/24.
////
//
////
////  DetailHabitView.swift
////  NotesPro
////
////  Created by Jason Susanto on 11/07/24.
////
//
//import SwiftUI
//import SwiftData
//
//struct DetailHabitView: View {
//    
//    @Environment(\.modelContext) private var modelContext
//    @Environment(\.presentationMode) var presentationMode
//    
//    @State private var newTaskName: String = ""
//    @State private var tasks: [DailyTaskDefinition] = []
//    @StateObject private var viewModel = HabitsViewModel()
//    var habit: Habit
//
//    var body: some View {
//        NavigationStack {
//            VStack (spacing: 0) {
//                Divider()
//                Form {
//                    Section {
//                        HStack {
//                            Text("Name")
//                                .padding(.trailing, 50)
//                            TextField("Enter Habit Name", text: $habit.title)
//                            
//                            Button {
//                                viewModel.habit.title = ""
//                            } label: {
//                                Image(systemName: "xmark.circle.fill")
//                            }
//                        }
//                    }
//                    
//                    Section {
//                        ForEach(tasks) { task in
//                            TaskRow(task: task) {
//                                tasks.removeAll { $0.id == task.id }
//                            }
//                        }
//                        AddRow(titleRow: "Add Task") {
//                            let newTask = DailyTaskDefinition(taskName: newTaskName)
//                            tasks.append(newTask)
//                        }
//                    }
//                    
//                    Section {
//                        HStack {
//                            Spacer()
//                            Button(action: {
//                                presentationMode.wrappedValue.dismiss()
//                            }) {
//                                Text("Delete Habit")
//                                    .foregroundColor(.red)
//                            }
//                            Spacer()
//                        }
//                    }
//                }
//            }
//            .navigationBarTitle("New Habit", displayMode: .inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                    .foregroundColor(.yellow)
//                }
//                
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Done") {
//                        _ = viewModel.addHabit(modelContext: modelContext)
//                        viewModel.saveHabit(modelContext: modelContext)
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                    .foregroundColor(.gray)
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: Note.self, configurations: config)
//
//        let newHabit = Habit(title: "Sample Habit", description: "Sample Description")
//        
//        return DetailHabitView(habit: newHabit)
//            .environmentObject(HabitsViewModel())
//            .modelContainer(container)
//    } catch {
//        return Text("Failed to create preview: \(error.localizedDescription)")
//    }
//}
//

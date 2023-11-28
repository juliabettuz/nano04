import SwiftUI

struct EditRemindersView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var reminder: FetchedResults<Reminders>.Element
    
    @State private var name: String
    @State private var isDone: Bool
    
    init(reminder: FetchedResults<Reminders>.Element) {
        self.reminder = reminder
        _name = State(initialValue: reminder.name ?? "")
        _isDone = State(initialValue: reminder.isDone)
    }
    
    var body: some View {
        ZStack {
            Color("ColorBackground")
                .edgesIgnoringSafeArea(.all)
            
            VStack (alignment: .leading) {
                
                Text("Editar ação")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Form {
                    
                    Section (header: Text("O que checar")) {
                        TextField("Name", text: $name)
                            .frame(width: 320, height: 50)
                        
                        
                    }
                    
                    HStack {
                        Spacer()
                        Button("Salvar alterações") {
                            DataController().editReminders(reminders: reminder, name: name, isDone: isDone, context: managedObjContext)
                            dismiss()
                        }
                        Spacer()
                    }
                }
                .background(Color("ColorBackground"))
                .scrollContentBackground(.hidden)
                .onAppear {
                    // Set the initial state when the view appears
                    name = reminder.name ?? ""
                    //            isDone = reminder.isDone
                }
                //        .navigationTitle("Editar ação")
            }
        }
    }
}



////
////  EditRemindersView.swift
////  Nano04
////
////  Created by Julia Bettuz on 04/10/23.
////
//
//import SwiftUI
//
//struct EditRemindersView: View {
//    @Environment(\.managedObjectContext) var managedObjContext
//    @Environment(\.dismiss) var dismiss
//    
//    var reminder: FetchedResults<Reminders>.Element
//    
//    @State private var name = ""
//    
//    
//    var body: some View {
//        Form {
//            Section{
//                TextField("\(reminder.name!)", text: $name)
//                    .onAppear {
//                        name = reminder.name!
//                    }
//                
//                HStack {
//                Spacer ()
//                    Button("Salvar") {
//                        DataController().editReminders(reminders: reminder, name: name, context: managedObjContext)
//                        dismiss()
//                    }
//                    Spacer()
//                    
//                    }
//            }
//        }
//    }
//}
//
////#Preview {
////    EditRemindersView()
////}

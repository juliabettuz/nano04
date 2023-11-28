//
//  AddRemindersView.swift
//  Nano04
//
//  Created by Julia Bettuz on 03/10/23.
//

import SwiftUI

struct AddRemindersView: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State var name = ""
    
    @State private var selectedDuration = 1
  
    
    var body: some View {
        ZStack {
            Color("ColorBackground")
                .edgesIgnoringSafeArea(.all)
            
        VStack (alignment: .leading) {
            Text("Adicionar ação")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            
            Form {
                Section(header: Text("O que checar")) {
                    TextField("Ex.: Fechei a porta?", text: $name)
                        .frame(width: 320, height: 50)
                }
                //            Picker("Reset Duration", selection: $selectedDuration) {
                //                            ForEach(1..<25) { hour in
                //                                Text("\(hour) \(hour == 1 ? "hour" : "hours")")
                //                            }
                //                        }
                
                HStack {
                    Spacer ()
                    Button("Salvar") {
                        DataController().addReminder(name: name,
                                                     context: managedObjContext)
                        dismiss()
                        
                        let durationInSeconds = selectedDuration * 60 * 60
                        print("Selected Duration in Seconds: \(durationInSeconds)")
                        
                        let reminderStruct = ReminderStruct(reminderName: name, reminderState: false)
                        let data = try? JSONEncoder().encode(reminderStruct)
                        
                        if let suiteDefaults = UserDefaults(suiteName: "group.Jules.Nano04") {
                            suiteDefaults.set(data, forKey: "reminderStruct")
                        }
                    }
                    
                    Spacer()
                    
                }
                
                
                //            }
            }
            .background(Color("ColorBackground"))
            .scrollContentBackground(.hidden)

            
        }
        
    }
        
    }
}

#Preview {
    AddRemindersView()
}

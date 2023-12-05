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
    
    @State private var selectedDuration = 23
    
    
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
                    
                    Section(header: Text("Quando resetar o lembrete?")) {
                        Picker("", selection: $selectedDuration) {
                            ForEach(1..<25) { hour in
                                Text("\(hour) \(hour == 1 ? "hora" : "horas")").tag(hour)
                            }
                        }.pickerStyle(.wheel)
                            .frame(width: 320, height: 150)
                    }
                    
                    HStack {
                        Spacer ()
                        Button("Salvar") {
                            DataController().addReminder(name: name, hoursToReset: selectedDuration, context: managedObjContext)
                            dismiss()
                            
                            let durationInSeconds = selectedDuration * 60 * 60
                            print("Selected Duration in Seconds: \(durationInSeconds)")
                            
                            let reminderStruct = ReminderStruct(reminderName: name, reminderState: false, reminderDateString: Date().ISO8601Format())
                            ReminderStruct.save(reminderStruct)
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

struct JustToView: View {
    @State var selectedDuration = 1
    
    var body: some View {
        Picker("Reset Duration", selection: $selectedDuration) {
            ForEach(1..<25) { hour in
                Text("\(hour) \(hour == 1 ? "hour" : "hours")").tag(hour)
            }
        }.pickerStyle(.menu)
    }
}

#Preview {
//    AddRemindersView()
    JustToView()
}

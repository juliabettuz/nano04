import SwiftUI
import WidgetKit
import Combine
import UserNotifications

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var reminders: FetchedResults<Reminders>
    @State private var showingAddView = false
    @Environment(\.scenePhase) var scenePhase
    @State private var selectedDuration = 1
    @State var dummy = 0
    
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    @State var timerDate = Date()
    
    var body: some View {
        NavigationStack {
            HStack {
                Spacer()
                EditButton()
                    .padding(.horizontal, 24)
                
            }
//            VStack (alignment: .trailing) {
//                EditButton()
////                    .padding(.horizontal, 16)
//                    .multilineTextAlignment(.trailing)
//            }
//            .frame(alignment: .trailing)
            
            VStack(alignment: .leading) {
                
                
                List {
                    ForEach(reminders) { reminder in
                        ZStack {
                                                    Color(reminder.isDone ? Color("VerdeDone") : Color("CinzaNotDone")) // Set background color based on toggle
                                                        .cornerRadius(16) // Optional: Add corner radius for a rounded appearance

                            NavigationLink(destination: EditRemindersView(reminder: reminder, selectedDuration: $selectedDuration)) {
                            Text(reminder.name!)
                                .bold()
                            
                            Spacer()
                            
                            VStack {
                                Toggle("", isOn: Binding (
                                    get: { reminder.isDone },
                                    set: { newValue in
                                        WidgetCenter.shared.reloadAllTimelines()
                                        // Update the boolean attribute and date when the toggle changes
                                        DataController().editReminders(reminders: reminder,
                                                                       name: reminder.name ?? "", hoursToReset: Int(reminder.hoursToReset),
                                                                       isDone: newValue,
                                                                       context: managedObjContext)
                                        
                                        let reminderStruct = ReminderStruct(reminderName: reminder.name ?? "", reminderState: newValue, reminderDateString: reminder.date!.ISO8601Format())
                                        
                                        ReminderStruct.save(reminderStruct)
                                    }
                                    
                                ))
                               
                                .toggleStyle(SwitchToggleStyle(tint: .black))
                                
                                // Conditionally include or exclude the date display
                                if reminder.isDone {
                                    VStack {
                                        //Text(reminder.date!, style: .relative)
                                        Text("Feito \(calcTimeSince(date: reminder.date!, from: timerDate))")
                                        
                                        Text("Data \(reminder.date!)")
                        
                                    }
                                } else {
                                    Text("Não feito hoje")
                                }
                                
                                
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                            
                        }
                        
//                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: -16))
                        
                    }
                    .onDelete(perform: deleteFood)
                }
               
                .listStyle(.plain)
                .navigationTitle("Fiz ou não fiz?")
                .onReceive(timer) { input in
                    timerDate = input
                }
                .toolbar {
//                    ToolbarItem(placement: .navigation) {
//                        EditButton()
//                    }

                    ToolbarItem(placement: .bottomBar) {
                        Spacer()
                    }

                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            showingAddView.toggle()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 40))
                                .padding(.bottom, 20)
//                            Label("Add reminder", systemImage: "plus.circle.fill")
//                                .font(.largeTitle)
                        }
                    }
                }
                .sheet(isPresented: $showingAddView) {
                    AddRemindersView()
                }
            }
            .navigationViewStyle(.stack)
        }
        .onChange(of: scenePhase) { (_,newPhase) in
                        if newPhase == .active {
                            updateWithWidgetData()
                        }
                    }
        .onAppear {
            updateWithWidgetData()
        }
    }
    
    private func updateWithWidgetData() {
        if let widgetReminder = loadReminder() {
            for reminder in reminders {
                if reminder.name == widgetReminder.reminderName {
                    let date = ISO8601DateFormatter().date(from: widgetReminder.reminderDateString) ?? Date()
                    DataController().editReminders(reminders: reminder,
                                                   name: reminder.name ?? "Não carregou", hoursToReset: Int(reminder.hoursToReset),
                                                   date: date,
                                                   isDone: widgetReminder.reminderState,
                                                   context: managedObjContext)
                }
                //            if let dateToggledDone = reminder.dateToggledDone,
                //               Date().timeIntervalSince(dateToggledDone) >= 22 * 60 * 60 {
                //                // If the toggle has been on for 23 hours or more, set it back to "Not done"
                //                DataController().editReminders(reminders: reminder,
                //                                               name: reminder.name ?? "Não carregou",
                //                                               isDone: false,
                //                                               context: managedObjContext)
                //            }
            }
        }
    }
    
    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.map { reminders[$0] }.forEach(managedObjContext.delete)
            
            let reminder = reminders[0]
            let reminderStruct = ReminderStruct(reminderName: reminder.name!, reminderState: reminder.isDone, reminderDateString: reminder.date!.ISO8601Format())
            
            ReminderStruct.save(reminderStruct)
            DataController().save(context: managedObjContext)
        }
    }
    
    func loadReminder () -> ReminderStruct? {
        return ReminderStruct.load()
    }
}


////
////  ContentView.swift
////  Nano04
////
////  Created by Julia Bettuz on 03/10/23.
////
//
//import SwiftUI
//import CoreData
//
//struct ContentView: View {
//    
//    @Environment(\.managedObjectContext) var managedObjContext
//    
//    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var reminders: FetchedResults<Reminders>
//    
//    @State private var showingAddView = false
//    
//    @State private var isDone = false
//    @State private var text = "Not done"
//    
//    func changeText(_ input: String) -> String {
//        
//        if isDone {
//            text = "Done"
//        } else {
//            text = "Not done"
//        }
//        
//        return text
//    }
//    
//    var body: some View {
//        NavigationStack {
//            VStack(alignment: .leading) {
//                List {
//                    ForEach(reminders) { reminder in
//                        NavigationLink(destination: EditRemindersView(reminder: reminder)) {
//                            
//                            Text(reminder.name!)
//                                    .bold()
//                            
//                                Spacer()
//                                
//                            VStack {
//                                Toggle("", isOn: Binding(
//                                               get: { reminder.isDone },
//                                               set: { newValue in
//                                                   // Update the boolean attribute and date when the toggle changes
//                                                   DataController().editReminders(reminders: reminder,
//                                                                                   name: reminder.name ?? "",
//                                                                                   isDone: newValue,
//                                                                                   context: managedObjContext)
//                                               }
//                                           ))
//                                           
//                                           // Conditionally include or exclude the date display
//                                           if reminder.isDone {
//                                               Text("Date: \(calcTimeSince(date: reminder.date!))")
//                                           } else {
//                                               Text("Not done today")
//                                           }
//                            }
//                               
//                        }
//    
//                        
//                    }
//                    
//                    .onDelete(perform: deleteFood)
//                    
//                }
//                .listStyle(.plain)
//                .navigationTitle ("Did I?")
//                .toolbar {
//                    ToolbarItem(placement: .bottomBar) {
//                        Button{
//                            showingAddView.toggle()
//                        } label: {
//                            Label("Add reminder", systemImage: "plus")
//                        }
//                    }
////                    Spacer()
//                    
//                    ToolbarItem(placement: .bottomBar) {
//                        EditButton()
//                    }
//                }
//                .sheet(isPresented: $showingAddView){
//                    AddRemindersView()
//                }
//            }
//            .navigationViewStyle(.stack)
//        }
//    }
//    private func deleteFood(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { reminders[$0] }.forEach(managedObjContext.delete)
//            
//            DataController().save(context: managedObjContext)
//                
//            }
//        }
//    }
//
//
////#Preview {
////    ContentView()
////}
//
//
//
//
//////
//////  ContentView.swift
//////  SampleCoreData
//////
//////  Created by Federico on 18/02/2022.
//////
////
////import SwiftUI
////import CoreData
////
////struct ContentView: View {
////    @Environment(\.managedObjectContext) var managedObjContext
////    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var reminders: FetchedResults<Reminders>
////    
////    @State private var showingAddView = false
////    
////    var body: some View {
////        NavigationView {
////            VStack(alignment: .leading) {
////                List {
////                    ForEach(reminders) { reminder in
////                        NavigationLink(destination: Text("blablabla")) {
////                            HStack {
////                                VStack(alignment: .leading, spacing: 6) {
////                                    Text(reminders.name?)
////                                        .bold()
////        
////                                }
////                                Spacer()
//////                                Text(calcTimeSince(date: reminders.date!))
//////                                    .foregroundColor(.gray)
//////                                    .italic()
////                            }
////                        }
////                    }
////                    .onDelete(perform: deleteReminders)
////                }
////                .listStyle(.plain)
////            }
////            .navigationTitle("iCalories")
////            .toolbar {
////                ToolbarItem(placement: .navigationBarTrailing) {
////                    Button {
////                        showingAddView.toggle()
////                    } label: {
////                        Label("Add food", systemImage: "plus.circle")
////                    }
////                }
////                ToolbarItem(placement: .navigationBarLeading) {
////                    EditButton()
////                }
////            }
//////            .sheet(isPresented: $showingAddView) {
//////                AddFoodView()
////            }
////        }
//////        .navigationViewStyle(.stack) // Removes sidebar on iPad
////    
////    
////    // Deletes food at the current offset
////    private func deleteReminders(offsets: IndexSet) {
////        withAnimation {
////            offsets.map { reminders[$0] }
////            .forEach(managedObjContext.delete)
////            
////            // Saves to our database
////            DataController().save(context: managedObjContext)
////        }
////    }
////    
////}
////
////
////struct ContentView_Previews: PreviewProvider {
////    static var previews: some View {
////        ContentView()
////    }
////}

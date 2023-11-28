import SwiftUI
import WidgetKit

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var reminders: FetchedResults<Reminders>
    @State private var showingAddView = false
    @Environment(\.scenePhase) var scenePhase
    
    
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

                        NavigationLink(destination: EditRemindersView(reminder: reminder)) {
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
                                                                       name: reminder.name ?? "",
                                                                       isDone: newValue,
                                                                       context: managedObjContext)
                                        
                                        let reminderStruct = ReminderStruct(reminderName: reminder.name ?? "", reminderState: newValue)
                                        let data = try? JSONEncoder().encode(reminderStruct)
                                        
                                        // Use UserDefaults com o suiteName
                                        if let suiteDefaults = UserDefaults(suiteName: "group.Jules.Nano04") {
                                            suiteDefaults.set(data, forKey: "reminderStruct")
                                        }
                                        
                                    }
            
                                    
                                ))
                               
                                .toggleStyle(SwitchToggleStyle(tint: .black))
                                
                                // Conditionally include or exclude the date display
                                if reminder.isDone {
                                    Text("Feito \(calcTimeSince(date: reminder.date!))")
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
                            updateRemindersNew()
                        }
                    }
        .onAppear {
            updateRemindersNew()
        }
    }
    
    private func updateRemindersNew() {
        let reminderStruct = loadReminder()
        
        for reminder in reminders {
            if let lastReminder = reminderStruct, reminder.name == lastReminder.reminderName {
                DataController().editReminders(reminders: reminder,
                                               name: reminder.name ?? "Não carregou",
                                               isDone: lastReminder.reminderState,
                                               context: managedObjContext)
            }
            if let dateToggledDone = reminder.dateToggledDone,
               Date().timeIntervalSince(dateToggledDone) >= 22 * 60 * 60 {
                // If the toggle has been on for 23 hours or more, set it back to "Not done"
                DataController().editReminders(reminders: reminder,
                                               name: reminder.name ?? "Não carregou",
                                               isDone: false,
                                               context: managedObjContext)
            }
        }
    }
    
    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.map { reminders[$0] }.forEach(managedObjContext.delete)
            
            let reminderStruct = ReminderStruct(reminderName: reminders[0].name ?? "", reminderState: reminders[0].isDone)
            let data = try? JSONEncoder().encode(reminderStruct)
            
            // Use UserDefaults com o suiteName
            if let suiteDefaults = UserDefaults(suiteName: "group.Jules.Nano04") {
                suiteDefaults.set(data, forKey: "reminderStruct")
            }
            DataController().save(context: managedObjContext)
            
            
        }
    }
    
    func loadReminder () -> ReminderStruct? {
        if let data = UserDefaults(suiteName: "group.Jules.Nano04")?.data(forKey: "reminderStruct") {
            if let loadedReminder = try? JSONDecoder().decode(ReminderStruct.self, from: data) {
                return loadedReminder
            }
        }
        
        return nil
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

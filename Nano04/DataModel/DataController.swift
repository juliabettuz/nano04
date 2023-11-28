//
//  DataController.swift
//  Nano04
//
//  Created by Julia Bettuz on 03/10/23.
//

import Foundation
import CoreData

class DataController : ObservableObject {
    
    let container = NSPersistentContainer (name: "RemindersModel")
    
    init() {
        
            container.loadPersistentStores { desc, error in
                if let error = error {
                    print("Failed to load the data \(error.localizedDescription)")
                }
                
            }
    }
    
    func save(context: NSManagedObjectContext) {
    do {
    try context.save ( )
    print ("Data saved!!! WUHU!!!")
    } catch {
    print("We could not save the data...")
    }
    }
    
    func addReminder(name: String, context: NSManagedObjectContext) {
        let reminders = Reminders (context: context)
        reminders.id = UUID()
        reminders.date = Date()
        reminders.name = name
//        reminders.toggle = Boolean()
        
        save (context: context)
        
    }
    
    func editReminders(reminders: Reminders, name: String, isDone: Bool, context: NSManagedObjectContext) {
           if isDone {
               // Update the date only when the toggle is turned on
               reminders.date = Date()
           }
           reminders.name = name
           reminders.isDone = isDone

           save(context: context)
        
    }
          
}

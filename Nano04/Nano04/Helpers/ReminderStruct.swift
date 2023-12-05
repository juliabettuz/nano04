//
//  RemindersStruct.swift
//  Nano04
///Users/juliabettuz/Downloads/Documentos/Nano 04 Pasta/Nano04/Nano04/Helpers/RemindersStruct.swift
//  Created by Julia Bettuz on 09/10/23.
//

import Foundation

struct ReminderStruct: Codable, Sendable {
    var reminderName: String
    var reminderState: Bool
    var reminderDateString: String
    
    init(reminderName: String, reminderState: Bool) {
        self.reminderName = reminderName
        self.reminderState = reminderState
        self.reminderDateString = Date().ISO8601Format()
    }
    
    init(reminderName: String, reminderState: Bool, reminderDateString: String) {
        self.reminderName = reminderName
        self.reminderState = reminderState
        self.reminderDateString = reminderDateString
    }
    
    static func load() -> ReminderStruct? {
        if let data = UserDefaults(suiteName: "group.Jules.Nano04")?.data(forKey: "reminderStruct") {
            if let loadedReminder = try? JSONDecoder().decode(ReminderStruct.self, from: data) {
                return loadedReminder
            }
        }
        
        return nil
    }
    
    static func save(_ reminderStruct: ReminderStruct) {
        let data = try? JSONEncoder().encode(reminderStruct)
        
        // Use UserDefaults com o suiteName
        if let suiteDefaults = UserDefaults(suiteName: "group.Jules.Nano04") {
            suiteDefaults.set(data, forKey: "reminderStruct")
        }
    }
}

//
//  ToggleIntent.swift
//  Nano04
//
//  Created by Julia Bettuz on 06/10/23.
//

import Foundation
import SwiftUI
import AppIntents

struct ToggleIntent: AppIntent {

    
    static var title: LocalizedStringResource = "idk what im doing"
    
    @Parameter(title: "name")
    var reminderName: String
    
    @Parameter(title: "toggle")
    var reminderToggle: Bool
    
    
    init() {

    }

    init(reminderName: String, reminderToggle: Bool) {
        self.reminderName = reminderName
        self.reminderToggle = reminderToggle
    
    }
    
    func perform() async throws -> some IntentResult {
        let reminderStruct = ReminderStruct(reminderName: reminderName, reminderState: reminderToggle)
        let data = try? JSONEncoder().encode(reminderStruct)
        
        // Use UserDefaults com o suiteName
        if let suiteDefaults = UserDefaults(suiteName: "group.Jules.Nano04") {
            suiteDefaults.set(data, forKey: "reminderStruct")
        }
       
        return .result()
    }

}



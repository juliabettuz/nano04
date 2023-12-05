//
//  Nano04App.swift
//  Nano04
//
//  Created by Julia Bettuz on 03/10/23.
//

import SwiftUI

@main
struct Nano04App: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment (\ .managedObjectContext, dataController.container.viewContext)
            
        }
    }
}

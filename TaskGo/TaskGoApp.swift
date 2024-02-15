//
//  TaskGoApp.swift
//  TaskGo
//
//  Created by Amin on 15/02/2024.
//

import SwiftUI

@main
struct TaskGoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

//
//  csc680_final_projectApp.swift
//  csc680-final-project
//
//  Created by Fernando Abel Malca Luque on 4/28/25.
//

import SwiftUI

@main
struct csc680_final_projectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

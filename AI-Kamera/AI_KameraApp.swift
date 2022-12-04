//
//  AI_KameraApp.swift
//  AI-Kamera
//
//  Created by Oskari Saarinen on 4.12.2022.
//

import SwiftUI

@main
struct AI_KameraApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

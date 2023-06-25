//
//  SimulatorSwiftUIApp.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 25.06.2023.
//

import SwiftUI

@main
struct SimulatorSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

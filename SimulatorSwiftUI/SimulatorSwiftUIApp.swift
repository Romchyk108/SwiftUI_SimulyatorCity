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
    @StateObject var dashboardModel = DashboardModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dashboardModel.dashboardManager)
        }
    }
}

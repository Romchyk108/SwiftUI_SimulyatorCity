//
//  DashboardModel.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 25.06.2023.
//

import Foundation

final class DashboardModel: ObservableObject {
    @Published var dashboardManager: DashboardManager = DashboardManager()
}

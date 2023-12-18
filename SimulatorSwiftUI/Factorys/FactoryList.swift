//
//  FactoryList.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 13.12.2023.
//

import SwiftUI

struct FactoryList: View {
    @EnvironmentObject var dashboardManager: DashboardManager
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(dashboardManager.factories.indices, id: \.self) { index in
                        NavigationLink {
                            FactoryDetailView(factory: dashboardManager.factories[index])
                        } label: {
                            FactoryViewRow(factory: $dashboardManager.factories[index])
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Factories")
    }
}

struct FactoryList_Previews: PreviewProvider {
    static let dashBoard = DashboardManager()
    static var previews: some View {
        FactoryList()
            .environmentObject(dashBoard)
    }
}

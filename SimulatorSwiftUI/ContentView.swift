//
//  ContentView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 25.06.2023.
//

import SwiftUI
import CoreData

var mainRows: [MainRow] = [MainRow(id: 0, title: "Generating Energy", image: "generateEnergy", description: "Some description1"),
                           MainRow(id: 1, title: "Hauses", image: "mainRowHause", description: "Some description2"),
                           MainRow(id: 2, title: "Engineering", image: "engineering", description: "Some description3")]

struct ContentView: View {
    @EnvironmentObject var dashboardManager: DashboardManager
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                DashboardView(board: $dashboardManager.dashboard)
                    .environmentObject(dashboardManager)
                
                NavigationStack {
                    List(mainRows) { row in
                        NavigationLink {
                            if row.id == 0 {
                                GeneratingEnergyList()
                                    .environmentObject(dashboardManager.energyManager)
                            } else if row.id == 1 {
                                HousesList()
                                    .environmentObject(dashboardManager.houseManager)
                            }
                            
                        } label: {
                            MainRowView(mainRow: row)
                        }
                    }
                    .navigationTitle("Main")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @StateObject var modelData = DashboardModel()
    
    static var previews: some View {
        ContentView()
            .environmentObject(DashboardModel().dashboardManager)
    }
}

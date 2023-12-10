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

func localizedString(_ text: String) -> String {
    NSLocalizedString(text, comment: "")
}

struct ContentView: View {
    @EnvironmentObject var dashboardManager: DashboardManager
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                DashboardView()//board: $dashboardManager.dashboard)
                    .environmentObject(dashboardManager)
                
                NavigationStack {
                    List(mainRows) { row in
                        NavigationLink {
                            switch row.id {
                            case 0:
                                GeneratingEnergyList(managers: $dashboardManager.energySources)
                                    .environmentObject(dashboardManager)
                            case 1:
                                HousesList(houseManagers: $dashboardManager.houses)
                            case 2:
                                EngineeringView()
                            default:
                                EngineeringView()
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
    static var previews: some View {
        ContentView()
            .environmentObject(DashboardModel().dashboardManager)
    }
}

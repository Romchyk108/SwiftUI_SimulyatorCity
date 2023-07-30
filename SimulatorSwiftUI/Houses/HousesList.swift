//
//  HousesList.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 16.07.2023.
//

import SwiftUI

struct HousesList: View {
    @EnvironmentObject var manager: HouseManager
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(manager.houses, id: \.self.id) { house in
                        NavigationLink {
                            HouseDetailView()
                                .environmentObject(house)
                                .environmentObject(manager)
                        } label: {
                            HouseRow()
                                .environmentObject(house)
                        }
                    }

//                    PieChartView()
//                        .environmentObject(manager)
//                        .frame(width: 300, height: 300)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Houses")
    }
}

struct HousesList_Previews: PreviewProvider {
    static let manager = HouseManager()
    static var previews: some View {
        HousesList()
            .environmentObject(manager)
    }
}

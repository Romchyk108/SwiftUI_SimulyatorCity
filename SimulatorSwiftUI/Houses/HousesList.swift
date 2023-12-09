//
//  HousesList.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 16.07.2023.
//

import SwiftUI

struct HousesList: View {
    @Binding var houseManagers: [HouseManager]
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(houseManagers.indices, id: \.self) { index in
                        NavigationLink {
                            HouseDetailView(houseManager: $houseManagers[index])
                        } label: {
                            HouseRow(manager: $houseManagers[index])
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Houses")
    }
}

struct HousesList_Previews: PreviewProvider {
    static var previews: some View {
        HousesList(houseManagers: .constant(HouseManager.houseManagers))
//            .environmentObject(manager)
    }
}

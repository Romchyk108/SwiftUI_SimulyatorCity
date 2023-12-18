//
//  HousesList.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 16.07.2023.
//

import SwiftUI

struct HousesList: View {
    @ObservedObject var houseModel: HouseModel
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(houseModel.houses.indices, id: \.self) { index in
                        NavigationLink {
                            HouseDetailView(house: houseModel.houses[index])
                        } label: {
                            HouseRow(house: houseModel.houses[index])
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Houses")
    }
}

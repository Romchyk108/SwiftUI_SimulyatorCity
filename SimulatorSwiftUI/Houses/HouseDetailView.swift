//
//  HouseDetailView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 16.07.2023.
//

import SwiftUI

struct HouseDetailView: View {
    @EnvironmentObject var house: HouseModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct HouseDetailView_Previews: PreviewProvider {
    static let house = ExpensiveHouse()
    static var previews: some View {
        HouseDetailView()
            .environmentObject(house)
    }
}

//
//  HouseManager.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 16.07.2023.
//

import Foundation

class HouseManager: ObservableObject {
    @Published var houses: [HouseModel]
    
    init() {
        self.houses = [CheapHouse(), MiddleHouse(), ExpensiveHouse(), TownHouse(), Storey9House(), Storey25House()]
    }
}

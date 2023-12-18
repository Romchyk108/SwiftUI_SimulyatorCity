//
//  HouseManager.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 16.07.2023.
//

import Foundation

protocol SESOnHouseDelegate: AnyObject {
    func getAvailablePlacesForSES() -> Int
}

class HouseModel: ObservableObject {
    var cheapHouse = House(id: 0, title: "Cheap House", icon: "cheapHouse", color: .brown, price: 30000, comfortLevel: 2, timeForBuild: 24, numberCanLiveHere: 3, generalSquare: 50, numberForSes: 1)
    var averageHouse = House(id: 1, title: "Average House", icon: "middleHouse", color: .cyan, price: 60000, comfortLevel: 4, timeForBuild: 24, numberCanLiveHere: 5, generalSquare: 100, numberForSes: 2)
    var expensive = House(id: 2, title: "Expensive House", icon: "expensiveHouse", color: .green, price: 120000, comfortLevel: 5, timeForBuild: 24, numberCanLiveHere: 6, generalSquare: 180, numberForSes: 3)
    var townHouse = House(id: 3, title: "Townhouse", icon: "townHouse", color: .blue, price: 150000, comfortLevel: 3, timeForBuild: 27, numberCanLiveHere: 15, generalSquare: 300, numberForSes: 9)
    var storey9 = House(id: 4, title: "9-storey building (36 apartments)", icon: "9-storyBuilding", color: .indigo , price: 60000, comfortLevel: 3, timeForBuild: 24, numberCanLiveHere: 110, generalSquare: 2160, numberForSes: 4)
    var storey25 = House(id: 5, title: "25-storey building (150 apartments)", icon: "25-storyBuilding", color: .pink , price: 350000, comfortLevel: 4, timeForBuild: 24, numberCanLiveHere: 600, generalSquare: 15000, numberForSes: 8)
    
    var houses: [House]
    
    init() {
        houses = [self.cheapHouse, averageHouse, expensive, townHouse, storey9, storey25]
    }
}

extension HouseModel: SESOnHouseDelegate {
    func getAvailablePlacesForSES() -> Int {
        houses.reduce(0, { $0 + ($1.numberForSES * $1.count) })
    }
}


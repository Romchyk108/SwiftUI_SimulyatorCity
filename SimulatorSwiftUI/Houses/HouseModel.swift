//
//  HouseModel.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 16.07.2023.
//

import Foundation
import SwiftUI

class HouseModel: Identifiable, ObservableObject {
    let id: Int
    let title: String
    let icon: String
    let color: Color
    var price: Int
    let comfortLevel: Int
    let timeForBuild: Int
    var squarePerPerson: Double {
        generalSquare / Double(numberWhoLiveHere)
    }
    let generalSquare: Double
    var numberForSES: Int = 1
    @Published var count: Int = 0
    @Published var numberForBuilding: Int = 0
    @Published var numberCanLiveHere: Int
    @Published var numberWhoLiveHere: Int = 0
    @Published var consumeElectricity: Double = 0
    
    init(id: Int, title: String, icon: String, color: Color, price: Int, comfortLevel: Int, timeForBuild: Int, numberCanLiveHere: Int, generalSquare: Double) {
        self.id = id
        self.title = title
        self.icon = icon
        self.color = color
        self.price = price
        self.comfortLevel = comfortLevel
        self.timeForBuild = timeForBuild
        self.numberCanLiveHere = numberCanLiveHere
        self.generalSquare = generalSquare
    }
}

final class CheapHouse: HouseModel {
    init() {
        super.init(id: 0, title: "Cheap House", icon: "cheapHouse", color: .brown, price: 30000, comfortLevel: 2, timeForBuild: 24 , numberCanLiveHere: 3, generalSquare: 50)
    }
}

final class MiddleHouse: HouseModel {
    init() {
        super.init(id: 1, title: "Average House", icon: "middleHouse", color: .cyan, price: 60000, comfortLevel: 4, timeForBuild: 24, numberCanLiveHere: 4, generalSquare: 100)
    }
}

final class ExpensiveHouse: HouseModel {
    init() {
        super.init(id: 2, title: "Expensive House", icon: "expensiveHouse", color: .green, price: 120000, comfortLevel: 5, timeForBuild: 24, numberCanLiveHere: 6, generalSquare: 180)
    }
}

final class TownHouse: HouseModel {
    init() {
        super.init(id: 3, title: "Townhouse (5 apartments)", icon: "townHouse", color: .mint, price: 160000, comfortLevel: 3, timeForBuild: 24, numberCanLiveHere: 15, generalSquare: 300)
    }
}

final class Storey9House: HouseModel {
    init() {
        super.init(id: 4, title: "9-storey building (36 apartments)", icon: "9-storyBuilding", color: .indigo , price: 600000, comfortLevel: 3, timeForBuild: 24, numberCanLiveHere: 108, generalSquare: 1440)
    }
}

final class Storey25House: HouseModel {
    init() {
        super.init(id: 5, title: "25-storey building (150 apartments)", icon: "25-storyBuilding", color: .pink , price: 3500000, comfortLevel: 4, timeForBuild: 24, numberCanLiveHere: 600, generalSquare: 10500)
    }
}

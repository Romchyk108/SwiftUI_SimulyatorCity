//
//  HouseManager.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 16.07.2023.
//

import Foundation

class HouseManager: CreatorTimeLine {
    var house: HouseModel
    var existingSES: Int = 0
    var count: Int = 0
    var numberForBuilding: Int = 0
    var finishTime = [Double]()
    var numberWhoLiveHere: Int = 0
    var errorMessage = ""
    var consumeElectricity: Double {
        return Double(house.comfortLevel * numberWhoLiveHere / 5) + Double(house.generalSquare * numberWhoLiveHere / house.numberCanLiveHere) * 0.04
    }
    
    var disableButton: Bool {
        errorMessage = localizedString("You have enough money.")
        return house.price >= Money.shared.money
    }
    
    var buildingProcess: Double {
        guard let time = finishTime.first else { return 0.0 }
        return 1.0 - ((1.0 / Double(house.timeForBuild)) * ((time - DashboardManager.currentTime) / 3600))
    }
    
    init(house: HouseModel) {
        self.house = house
    }
    
    func checkTime() {
        finishBuilding()
    }
    
    func tappedPlus(house: HouseManager) {
        Money.shared.money -= house.house.price
        numberForBuilding += 1
        predictFinishTime(finishTime.last ?? DashboardManager.currentTime)
    }
    
    func setUpPeopleInTheirHouse(people: inout Int) -> Int {
        let potentialResidents = house.numberCanLiveHere * count - numberWhoLiveHere
        guard potentialResidents > 0 else { return people }
        if people > 0 {
            numberWhoLiveHere += potentialResidents >= people ? people : potentialResidents
            people -= potentialResidents >= people ? potentialResidents : potentialResidents % people
        }
        return people
    }
    
    private func predictFinishTime(_ since: Double) {
        finishTime.append(since + Double(house.timeForBuild * 3600))
    }

    private func finishBuilding() {
        if let currentFinishTime = finishTime.first, currentFinishTime <= DashboardManager.currentTime {
            self.numberForBuilding -= 1
            self.finishTime.removeFirst()
            self.count += 1
        }
    }
}

extension HouseManager {
    static var houseManagers = [
        HouseManager(house: HouseModel(id: 0, title: "Cheap House", icon: "cheapHouse", color: .brown, price: 30000, comfortLevel: 2, timeForBuild: 24, numberCanLiveHere: 3, generalSquare: 50, numberForSes: 1)),
        HouseManager(house: HouseModel(id: 1, title: "Average House", icon: "middleHouse", color: .cyan, price: 60000, comfortLevel: 4, timeForBuild: 24, numberCanLiveHere: 5, generalSquare: 100, numberForSes: 2)),
        HouseManager(house: HouseModel(id: 2, title: "Expensive House", icon: "expensiveHouse", color: .green, price: 120000, comfortLevel: 5, timeForBuild: 24, numberCanLiveHere: 6, generalSquare: 180, numberForSes: 3)),
        HouseManager(house: HouseModel(id: 3, title: "Townhouse (5 apartments)", icon: "townHouse", color: .mint, price: 160000, comfortLevel: 3, timeForBuild: 24, numberCanLiveHere: 15, generalSquare: 300, numberForSes: 2)),
        HouseManager(house: HouseModel(id: 4, title: "9-storey building (36 apartments)", icon: "9-storyBuilding", color: .indigo , price: 60000, comfortLevel: 3, timeForBuild: 24, numberCanLiveHere: 110, generalSquare: 2160, numberForSes: 4)),
        HouseManager(house: HouseModel(id: 5, title: "25-storey building (150 apartments)", icon: "25-storyBuilding", color: .pink , price: 350000, comfortLevel: 4, timeForBuild: 24, numberCanLiveHere: 600, generalSquare: 15000, numberForSes: 8))
    ]
    
    static func addSES() {
        let houses = Self.houseManagers.filter { house in
            house.count != 0 && house.house.numberForSES > house.existingSES
        }
        houses.first?.existingSES += 1
    }
}


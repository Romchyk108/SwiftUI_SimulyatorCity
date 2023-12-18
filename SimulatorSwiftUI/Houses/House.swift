//
//  House.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 16.07.2023.
//

import Foundation
import SwiftUI

class House: ObservableObject, Identifiable, CreatorTimeLine {
    static func addSES(houses: [House]) {
        if let filteredHouses = houses.first(where: { house in
            house.count != 0 && house.numberForSES > house.existingSES
        }) {
            filteredHouses.existingSES += 1
        }
    }
    
    let id: Int
    let title: String
    let icon: String
    let color: Color
    var price: Int
    let comfortLevel: Int
    let timeForBuild: Int
    let generalSquare: Int
    let numberForSES: Int
    var numberCanLiveHere: Int
    
    @Published var existingSES: Int = 0
    @Published var count: Int = 0
    @Published var numberForBuilding: Int = 0
    @Published var finishTime = [Double]()
    @Published var numberWhoLiveHere: Int = 0
    @Published var buildingProcess: Double = 0.0
    var errorMessage = ""
    var consumeElectricity: Double {
        return Double(comfortLevel * numberWhoLiveHere / 5) + Double(generalSquare * numberWhoLiveHere / numberCanLiveHere) * 0.04
    }
    
    var disableButton: Bool {
        errorMessage = localizedString("You have enough money.")
        return price >= Money.shared.money
    }
    
    init(id: Int, title: String, icon: String, color: Color, price: Int, comfortLevel: Int, timeForBuild: Int, numberCanLiveHere: Int, generalSquare: Int, numberForSes: Int) {
        self.id = id
        self.title = title
        self.icon = icon
        self.color = color
        self.price = price
        self.comfortLevel = comfortLevel
        self.timeForBuild = timeForBuild
        self.numberCanLiveHere = numberCanLiveHere
        self.generalSquare = generalSquare
        self.numberForSES = numberForSes
    }
    
    func checkTime() {
        calculateBuildingProcess()
        finishBuilding()
    }
    
    func tappedPlus() {
        Money.shared.money -= price
        numberForBuilding += 1
        predictFinishTime(finishTime.last ?? DashboardManager.currentTime)
    }
    
    func setUpPeopleInTheirHouse(people: inout Int) -> Int {
        let potentialResidents = numberCanLiveHere * count - numberWhoLiveHere
        guard potentialResidents > 0 else { return people }
        if people > 0 {
            numberWhoLiveHere += potentialResidents >= people ? people : potentialResidents
            people -= potentialResidents >= people ? potentialResidents : potentialResidents % people
        }
        return people
    }
    
    private func predictFinishTime(_ since: Double) {
        finishTime.append(since + Double(timeForBuild * 3600))
    }

    private func finishBuilding() {
        if let currentFinishTime = finishTime.first, currentFinishTime <= DashboardManager.currentTime {
            self.numberForBuilding -= 1
            self.finishTime.removeFirst()
            self.count += 1
        }
    }
    
    private func calculateBuildingProcess() {
        guard let time = finishTime.first else { return }
        buildingProcess = 1.0 - ((1.0 / Double(timeForBuild)) * ((time - DashboardManager.currentTime) / 3600))
    }
}

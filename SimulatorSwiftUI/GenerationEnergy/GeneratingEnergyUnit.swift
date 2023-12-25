//
//  GeneratingEnergyUnit.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 27.06.2023.
//

import Foundation
import SwiftUI

class GeneratingEnergyUnit: ObservableObject, Identifiable, CreatorTimeLine, CalculatorProcess {
    let id: Int
    let title: String
    let image: String
    let color: Color
    let price: Int
    let timeForBuilding: Int
    let powerPerUnit: Double
    let workerPerUnit: Double
    let description: String
    let dependentOnWeather: Bool
    
    @Published var count: Int = 0
    @Published var numberForBuild: Int = 0
    @Published var finishTime = [Double]()
    @Published var totalPower: Double = 0.0
    @Published var totalWorkers: Int = 0
    @Published var buildingProcess: Double = 0.0
    
    var buildingTeam = 1
    var errorMessage: String = ""
    var autoAdding: Bool = false
    
    var coefficientDependentWeather: Double = 1.0 {
        didSet {
            self.totalPower = Double(count) * powerPerUnit * coefficientDependentWeather
            self.totalWorkers = Int((Double(count) * workerPerUnit).rounded(.up))
        }
    }
    
    weak var delegate: SESOnHouseDelegate?
    
    init(id: Int, title: String, image: String, color: Color, price: Int, timeForBuilding: Int, powerPerUnit: Double, workerPerUnit: Double, description: String, dependentOnWeather: Bool = false) {
        self.id = id
        self.title = title
        self.image = image
        self.color = color
        self.price = price
        self.timeForBuilding = timeForBuilding
        self.powerPerUnit = powerPerUnit
        self.workerPerUnit = workerPerUnit
        self.description = description
        self.dependentOnWeather = dependentOnWeather
    }
    
    func canTappedPlus() -> Bool {
        guard price <= Money.shared.money else {
            errorMessage = localizedString("You have enough money.")
            return false
        }
        guard id == 0, let amountNumberForSES = delegate?.getAvailablePlacesForSES() else {
            return true
        }
        errorMessage = localizedString("You have enough houses.")
        return count + numberForBuild < amountNumberForSES
    }
    
    func tappedPlus() {
        let nextTimeForBuild = finishTime.last
        Money.shared.money -= price
        numberForBuild += 1
        predictFinishBuild(since: nextTimeForBuild ?? DashboardManager.currentTime)
    }
    
    func checkTime() {
        self.buildingProcess = calculateProcess(array: finishTime, period: timeForBuilding)
        finishBuild()
        if autoAdding, canTappedPlus(), finishTime.isEmpty {
            tappedPlus()
        }
    }
    
    private func getProgressValue() -> Double {
        guard let time = finishTime.first else { return 0.0 }
        return 1.0 - ((1.0 / Double(timeForBuilding)) * ((time - DashboardManager.currentTime) / 3600))
    }
    
    private func predictFinishBuild(since: Double) {
        finishTime.append(since + Double(timeForBuilding) * 3600)
    }
    
    private func finishBuild() {
        if let currentFinishTime = finishTime.first, currentFinishTime <= DashboardManager.currentTime {
            self.numberForBuild -= 1
            self.finishTime.removeFirst()
            self.count += 1
        }
        if !dependentOnWeather {
            self.totalPower = Double(count) * powerPerUnit * coefficientDependentWeather
            self.totalWorkers = Int((Double(count) * workerPerUnit).rounded(.up))
        }
    }
}

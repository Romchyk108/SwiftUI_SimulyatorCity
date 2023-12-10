//
//  GeneratingEnergyManager.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 29.06.2023.
//

import Foundation

protocol CreatorTimeLine {
    func createTimeLine(time: Double) -> String
}

class GeneratingEnergyManager: ObservableObject {
    static var energyManagers = [
        GeneratingEnergyManager(model: GeneratingEnergyModel(id: 0, title: localizedString("SES on the roof of house"), image: "solarPanelOnTheRoof", color: .green, price: 5000, timeForBuilding: 18, powerPerUnit: 5.0, workerPerUnit: 0.35, description: localizedString("Description ses roof"), dependentOnWeather: true)),
        GeneratingEnergyManager(model: GeneratingEnergyModel(id: 1, title: localizedString("SES on the Ground"), image: "solarPanelOnGround", color: .init(red: 0, green: 245, blue: 0), price: 10000, timeForBuilding: 40, powerPerUnit: 10.0, workerPerUnit: 0.2, description: localizedString("Description ses on the ground"), dependentOnWeather: true)),
        GeneratingEnergyManager(model: GeneratingEnergyModel(id: 2, title: localizedString("Wind Power Plant"), image: "windEnergy", color: .cyan , price: 25000, timeForBuilding: 30, powerPerUnit: 20.0, workerPerUnit: 0.4, description: localizedString("Description wind power plant"), dependentOnWeather: true)),
        GeneratingEnergyManager(model: GeneratingEnergyModel(id: 3, title: localizedString("Biogas Power Plant"), image: "biogas", color: .yellow, price: 50000, timeForBuilding: 14, powerPerUnit: 25.0, workerPerUnit: 5, description: localizedString("Description biogas power plant"))),
        GeneratingEnergyManager(model: GeneratingEnergyModel(id: 4, title: localizedString("Small HES"), image: "smallHydro", color: .mint, price: 150000, timeForBuilding: 44, powerPerUnit: 100.0, workerPerUnit: 15, description: localizedString("Description small Hydro power plant"))),
        GeneratingEnergyManager(model: GeneratingEnergyModel(id: 5, title: localizedString("HES"), image: "ГЕС", color: .blue, price: 125000, timeForBuilding: 250, powerPerUnit: 2500.0, workerPerUnit: 70, description: localizedString("Description Hydro power plant"))),
        GeneratingEnergyManager(model: GeneratingEnergyModel(id: 6, title: localizedString("TPP"), image: "ТЕС", color: .indigo, price: 25000, timeForBuilding: 200, powerPerUnit: 3500.0, workerPerUnit: 120, description: localizedString("Description Thermal power plant"))),
        GeneratingEnergyManager(model: GeneratingEnergyModel(id: 7, title: localizedString("NPP"), image: "АЕС", color: .red, price: 95000, timeForBuilding: 50, powerPerUnit: 100000.0, workerPerUnit: 530, description: localizedString("Description Nuclear power plant")))
    ]
    
    let energyModel: GeneratingEnergyModel
    @Published var count: Int = 0
    @Published var numberForBuild: Int = 0
    @Published var finishTime = [Double]()
    @Published var totalPower: Double = 0.0
    @Published var totalWorkers: Int = 0
    
    var buildingTeam = 1
    var errorMessage: String = ""
    var autoAdding: Bool = false
    
    var coefficientDependentWeather: Double = 1.0 {
        didSet {
            self.totalPower = Double(count) * energyModel.powerPerUnit * coefficientDependentWeather
            self.totalWorkers = Int((Double(count) * energyModel.workerPerUnit).rounded(.up))
        }
    }
    
    init(model: GeneratingEnergyModel) {
        self.energyModel = model
    }
    
    func getProgressValue(for unit: GeneratingEnergyManager) -> Double {
        guard let time = unit.finishTime.first else { return 0.0 }
        return 1.0 - ((1.0 / unit.energyModel.timeForBuilding) * ((time - DashboardManager.currentTime) / 3600))
    }
    
    func canTappedPlus(_ manager: GeneratingEnergyManager) -> Bool {
        guard manager.energyModel.price <= Money.shared.money else {
            errorMessage = localizedString("You have enough money.")
            return false
        }
        guard manager.energyModel.id == 0 else {
            return true
        }
        let amountNumberForSES = HouseManager.houseManagers.reduce(0) { partialResult, manager in
            partialResult + ((manager.house.numberForSES) * manager.count)
        }
        errorMessage = localizedString("You have enough houses.")
        return manager.count + manager.numberForBuild < amountNumberForSES
    }
    
    func tappedPlus(unit: GeneratingEnergyManager) {
        let nextTimeForBuild = finishTime.last
        Money.shared.money -= unit.energyModel.price
        numberForBuild += 1
        unit.predictFinishBuild(since: nextTimeForBuild ?? DashboardManager.currentTime)
    }
    
    func checkTime() {
        finishBuild()
        if autoAdding, canTappedPlus(self), finishTime.isEmpty {
            tappedPlus(unit: self)
        }
    }
    
    private func predictFinishBuild(since: Double) {
        finishTime.append(since + energyModel.timeForBuilding * 3600)
    }
    
    private func finishBuild() {
        if let currentFinishTime = finishTime.first, currentFinishTime <= DashboardManager.currentTime {
            self.numberForBuild -= 1
            self.finishTime.removeFirst()
            self.count += 1
        }
        if !energyModel.dependentOnWeather {
            self.totalPower = Double(count) * energyModel.powerPerUnit * coefficientDependentWeather
            self.totalWorkers = Int((Double(count) * energyModel.workerPerUnit).rounded(.up))
        }
    }
    
    static func calculateEnergy(weather: DashboardManager.Weather) -> Double {
        let dependentOnWeatherSourceEnergy = Self.energyManagers.filter({ $0.energyModel.dependentOnWeather })
        guard !dependentOnWeatherSourceEnergy.isEmpty else { return 0.0}
        switch weather {
        case .sunny:
            dependentOnWeatherSourceEnergy[0].coefficientDependentWeather = 1
            dependentOnWeatherSourceEnergy[1].coefficientDependentWeather = 1
            dependentOnWeatherSourceEnergy[2].coefficientDependentWeather = 0.2
        case .sunrise:
            dependentOnWeatherSourceEnergy[0].coefficientDependentWeather = 0.1
            dependentOnWeatherSourceEnergy[1].coefficientDependentWeather = 0.1
            dependentOnWeatherSourceEnergy[2].coefficientDependentWeather = 0.1
        case .sunset:
            dependentOnWeatherSourceEnergy[0].coefficientDependentWeather = 0.15
            dependentOnWeatherSourceEnergy[1].coefficientDependentWeather = 0.15
            dependentOnWeatherSourceEnergy[2].coefficientDependentWeather = 0.15
        case .sunnyAndCloudy:
            dependentOnWeatherSourceEnergy[0].coefficientDependentWeather = 0.75
            dependentOnWeatherSourceEnergy[1].coefficientDependentWeather = 0.75
            dependentOnWeatherSourceEnergy[2].coefficientDependentWeather = 0.3
        case .cloudy:
            dependentOnWeatherSourceEnergy[0].coefficientDependentWeather = 0.4
            dependentOnWeatherSourceEnergy[1].coefficientDependentWeather = 0.4
            dependentOnWeatherSourceEnergy[2].coefficientDependentWeather = 0.6
        case .windyNight:
            dependentOnWeatherSourceEnergy[0].coefficientDependentWeather = 0.0
            dependentOnWeatherSourceEnergy[1].coefficientDependentWeather = 0.0
            dependentOnWeatherSourceEnergy[2].coefficientDependentWeather = 1.1
        case .rainy:
            dependentOnWeatherSourceEnergy[0].coefficientDependentWeather = 0.2
            dependentOnWeatherSourceEnergy[1].coefficientDependentWeather = 0.2
            dependentOnWeatherSourceEnergy[2].coefficientDependentWeather = 0.6
        case .heavyRain:
            dependentOnWeatherSourceEnergy[0].coefficientDependentWeather = 0.1
            dependentOnWeatherSourceEnergy[1].coefficientDependentWeather = 0.1
            dependentOnWeatherSourceEnergy[2].coefficientDependentWeather = 0.85
        case .thunderstorm:
            dependentOnWeatherSourceEnergy[0].coefficientDependentWeather = 0.1
            dependentOnWeatherSourceEnergy[1].coefficientDependentWeather = 0.1
            dependentOnWeatherSourceEnergy[2].coefficientDependentWeather = 0.9
        case .moon:
            dependentOnWeatherSourceEnergy[0].coefficientDependentWeather = 0.0
            dependentOnWeatherSourceEnergy[1].coefficientDependentWeather = 0.0
            dependentOnWeatherSourceEnergy[2].coefficientDependentWeather = 0.2
        case .cloudyMoon:
            dependentOnWeatherSourceEnergy[0].coefficientDependentWeather = 0.0
            dependentOnWeatherSourceEnergy[1].coefficientDependentWeather = 0.0
            dependentOnWeatherSourceEnergy[2].coefficientDependentWeather = 0.3
        case .rainyMoon:
            dependentOnWeatherSourceEnergy[0].coefficientDependentWeather = 0.0
            dependentOnWeatherSourceEnergy[1].coefficientDependentWeather = 0.0
            dependentOnWeatherSourceEnergy[2].coefficientDependentWeather = 0.4
        }
        let summeryGenerating = Self.energyManagers.map{ $0.totalPower }.reduce(0, +)
        return summeryGenerating
    }
}

extension GeneratingEnergyManager: CreatorTimeLine { }

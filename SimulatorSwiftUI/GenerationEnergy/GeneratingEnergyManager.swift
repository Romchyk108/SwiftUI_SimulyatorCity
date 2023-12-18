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
    @Published var energyUnits = [
        GeneratingEnergyUnit(id: 0, title: localizedString("SES on the roof of house"), image: "solarPanelOnTheRoof", color: .green, price: 5000, timeForBuilding: 18, powerPerUnit: 5.0, workerPerUnit: 0.35, description: localizedString("Description ses roof"), dependentOnWeather: true),
        GeneratingEnergyUnit(id: 1, title: localizedString("SES on the Ground"), image: "solarPanelOnGround", color: .init(red: 0, green: 245, blue: 0), price: 10000, timeForBuilding: 40, powerPerUnit: 10.0, workerPerUnit: 0.2, description: localizedString("Description ses on the ground"), dependentOnWeather: true),
        GeneratingEnergyUnit(id: 2, title: localizedString("Wind Power Plant"), image: "windEnergy", color: .cyan , price: 25000, timeForBuilding: 30, powerPerUnit: 20.0, workerPerUnit: 0.4, description: localizedString("Description wind power plant"), dependentOnWeather: true),
        GeneratingEnergyUnit(id: 3, title: localizedString("Biogas Power Plant"), image: "biogas", color: .yellow, price: 50000, timeForBuilding: 14, powerPerUnit: 25.0, workerPerUnit: 5, description: localizedString("Description biogas power plant")),
        GeneratingEnergyUnit(id: 4, title: localizedString("Small HES"), image: "smallHydro", color: .mint, price: 150000, timeForBuilding: 44, powerPerUnit: 100.0, workerPerUnit: 15, description: localizedString("Description small Hydro power plant")),
        GeneratingEnergyUnit(id: 5, title: localizedString("HES"), image: "ГЕС", color: .blue, price: 125000, timeForBuilding: 250, powerPerUnit: 2500.0, workerPerUnit: 70, description: localizedString("Description Hydro power plant")),
        GeneratingEnergyUnit(id: 6, title: localizedString("TPP"), image: "ТЕС", color: .indigo, price: 25000, timeForBuilding: 200, powerPerUnit: 3500.0, workerPerUnit: 120, description: localizedString("Description Thermal power plant")),
        GeneratingEnergyUnit(id: 7, title: localizedString("NPP"), image: "АЕС", color: .red, price: 95000, timeForBuilding: 50, powerPerUnit: 100000.0, workerPerUnit: 530, description: localizedString("Description Nuclear power plant"))
    ]
    
    func calculateEnergy(weather: DashboardManager.Weather) -> Double {
        let dependentOnWeatherSourceEnergy = energyUnits.filter({ $0.dependentOnWeather })
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
        let summeryGenerating = energyUnits.map{ $0.totalPower }.reduce(0, +)
        return summeryGenerating
    }
}

extension GeneratingEnergyManager: CreatorTimeLine { }

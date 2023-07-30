//
//  GeneratingEnergyManager.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 29.06.2023.
//

import Foundation

protocol EnergyManagerDelegate: AnyObject {
    func tappedPlus(unit: GeneratingEnergy)
}

class GeneratingEnergyManager: ObservableObject, EnergyManagerDelegate {
    @Published var sesRoof: SesRoof
    @Published var sesGround: SesGround
    @Published var wes: WindPowerPlant
    @Published var bpp: BiogasPowerPlant
    @Published var smallhpp: SmallHydroPowerPlant
    @Published var hpp: HydroPowerPlant
    @Published var tpp: ThermalPowerPlant
    @Published var npp: NuclearPowerPlant
    
    @Published var units: [GeneratingEnergy]
    
    var buildingTeam = 1
    typealias queueCell = (Int, Double)
    var queueBuild: [queueCell] = []
    
    init(sesRoof: SesRoof, sesGround: SesGround, wes: WindPowerPlant, bpp: BiogasPowerPlant, smallhpp: SmallHydroPowerPlant, hpp: HydroPowerPlant, tpp: ThermalPowerPlant, npp: NuclearPowerPlant) {
        self.sesRoof = sesRoof
        self.sesGround = sesGround
        self.wes = wes
        self.bpp = bpp
        self.smallhpp = smallhpp
        self.hpp = hpp
        self.tpp = tpp
        self.npp = npp
        self.units = [sesRoof, sesGround, wes, bpp, smallhpp, hpp, tpp, npp]
        units.forEach { unit in
            unit.delegate = self
        }
    }
    
    func tappedPlus(unit: GeneratingEnergy) {
        guard unit.price <= Money.shared.money else {
            print("Don't enough money for \(unit.title)")
            return
        }
        Money.shared.money -= unit.price
        let finishTime = unit.predictFinishBuild(since: DashboardManager.currentTime)
        unit.addForBuild(finishTime: finishTime)
        self.queueBuild.append(queueCell(unit.id, unit.finishTime.last ?? 0.0))
    }
    
    func checkTime(time: Double) {
        if !queueBuild.filter({ $0.1 <= time }).isEmpty {
            queueBuild.filter({ $0.1 <= time }).forEach {
                self.units[$0.0].finishBuild()
            }
            queueBuild.removeAll(where: { $0.1 <= time })
        }
    }
    
    func calculateEnergy(weather: DashboardManager.Weather) -> Double {
        let dependentOnWeatherSourceEnergy = units.filter({ $0.dependentOnWeather })
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
        let summeryGenerating = units.map{ $0.totalPower }.reduce(0, +)
        return summeryGenerating
    }
    
    func createTimeLine(time: Double) -> String {
        let calendar = Calendar.current
        let time = Date(timeIntervalSince1970: time)
        let year = calendar.component(.year, from: time)
        let month = calendar.component(.month, from: time)
        let day = calendar.component(.day, from: time)
        let hour = calendar.component(.hour, from: time)
        return "\(year).\(month).\(day) / \(hour)"
    }
}

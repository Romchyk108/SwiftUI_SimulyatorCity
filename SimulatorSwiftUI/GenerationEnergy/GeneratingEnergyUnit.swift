//
//  GeneratingEnergyUnit.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 27.06.2023.
//

import Foundation
import SwiftUI

class GeneratingEnergy: Identifiable, ObservableObject {
    var id: Int
    var title: String
    var image: String
    let color: Color
    var price: Int
    @Published var count: Int = 0
    @Published var numberForBuild: Int = 0
    var timeForBuilding: Double
    var finishTime = [Double]()
    var powerPerUnit: Double
    @Published var totalPower: Double = 0.0
    var workerPerUnit: Double
    @Published var totalWorkers: Int = 0
    var description: String
    var dependentOnWeather: Bool = false
    var coefficientDependentWeather: Double = 1.0 {
        didSet {
            self.totalPower = Double(count) * powerPerUnit * coefficientDependentWeather
            self.totalWorkers = Int((Double(count) * workerPerUnit).rounded(.up))
        }
    }
    weak var delegate: EnergyManagerDelegate?
    
    init(id: Int, title: String, image: String, color: Color, price: Int, timeForBuilding: Double, powerPerUnit: Double, workerPerUnit: Double, description: String) {
        self.id = id
        self.title = title
        self.image = image
        self.color = color
        self.price = price
        self.timeForBuilding = timeForBuilding
        self.powerPerUnit = powerPerUnit
        self.workerPerUnit = workerPerUnit
        self.description = description
    }
    
    func addForBuild(finishTime: Double) {
        self.numberForBuild += 1
        self.finishTime.append(finishTime)
    }
    
    func finishBuild() {
        self.numberForBuild -= 1
        self.finishTime.removeFirst()
        self.count += 1
        if !dependentOnWeather {
            self.totalPower = Double(count) * powerPerUnit * coefficientDependentWeather
            self.totalWorkers = Int((Double(count) * workerPerUnit).rounded(.up))
        }
    }
    
    func touchPlusButton() {
        delegate?.tappedPlus(unit: self)
    }
    
    func predictFinishBuild(since: Double) -> Double {
        return since + timeForBuilding * 3600
    }
}

class SesRoof: GeneratingEnergy {
    init() {
        super.init(id: 0, title: "SES on the roof of house", image: "solarPanelOnTheRoof", color: .green, price: 5000, timeForBuilding: 18, powerPerUnit: 5.0, workerPerUnit: 0.35, description: "description - SES Roof")
        self.dependentOnWeather = true
    }
}

class SesGround: GeneratingEnergy {
    init() {
        super.init(id: 1, title: "SES on the Ground", image: "solarPanelOnGround", color: .init(red: 0, green: 245, blue: 0), price: 10000, timeForBuilding: 40, powerPerUnit: 10.0, workerPerUnit: 0.2, description: "Description SES on the ground")
        self.dependentOnWeather = true
    }
}

class WindPowerPlant: GeneratingEnergy {
    init() {
        super.init(id: 2, title: "Wind Power Plant", image: "windEnergy", color: .cyan , price: 25000, timeForBuilding: 30, powerPerUnit: 20.0, workerPerUnit: 0.4, description: "Description wind power plant")
        self.dependentOnWeather = true
    }
}

class BiogasPowerPlant: GeneratingEnergy {
    init() {
        super.init(id: 3, title: "Biogas Power Plant", image: "biogas", color: .yellow, price: 50000, timeForBuilding: 34, powerPerUnit: 25.0, workerPerUnit: 5, description: "Description biogas power plant")
    }
}

class SmallHydroPowerPlant: GeneratingEnergy {
    init() {
        super.init(id: 4, title: "Small HES", image: "smallHydro", color: .mint, price: 150000, timeForBuilding: 44, powerPerUnit: 100.0, workerPerUnit: 15, description: "Description small Hydro power plant")
    }
}

class HydroPowerPlant: GeneratingEnergy {
    init() {
        super.init(id: 5, title: "HES", image: "ГЕС", color: .blue, price: 1250000, timeForBuilding: 250 * 24, powerPerUnit: 2500.0, workerPerUnit: 70, description: "Description Hydro power plant")
    }
}

class ThermalPowerPlant: GeneratingEnergy {
    init() {
        super.init(id: 6, title: "TPP", image: "ТЕС", color: .indigo, price: 2500000, timeForBuilding: 200 * 24, powerPerUnit: 3500.0, workerPerUnit: 120, description: "Description Thermal power plant")
    }
}

class NuclearPowerPlant: GeneratingEnergy {
    init() {
        super.init(id: 7, title: "NPP", image: "АЕС", color: .red, price: 5000000, timeForBuilding: 500 * 24, powerPerUnit: 10000.0, workerPerUnit: 530, description: "Description Nuclear power plant")
    }
}


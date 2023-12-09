//
//  GeneratingEnergyUnit.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 27.06.2023.
//

import Foundation
import SwiftUI

struct GeneratingEnergyModel: Identifiable {
    let id: Int
    let title: String
    let image: String
    let color: Color
    let price: Int
    let timeForBuilding: Double
    let powerPerUnit: Double
    let workerPerUnit: Double
    let description: String
    let dependentOnWeather: Bool
    
    init(id: Int, title: String, image: String, color: Color, price: Int, timeForBuilding: Double, powerPerUnit: Double, workerPerUnit: Double, description: String, dependentOnWeather: Bool = false) {
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
}

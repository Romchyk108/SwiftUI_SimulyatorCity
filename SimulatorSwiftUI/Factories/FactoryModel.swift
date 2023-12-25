//
//  FactoryModel.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 2023/12/20.
//

import Foundation
import SwiftUI

class FactoryModel: ObservableObject {
    @Published var bakery = Factory(id: 0, title: "Bakery", iconName: "bakery", color: .cyan, price: 100000, factoryConsumeEnergy: 250, workersForShift: 20, profit: 30, timeForBuild: 15)
    @Published var cheeseFactory = Factory(id: 1, title: "Cheese factory", iconName: "cheeseFactory", color: .yellow, price: 100000, factoryConsumeEnergy: 30, workersForShift: 5, profit: 12, timeForBuild: 15)
    @Published var milkFactory = Factory(id: 2, title: "Mick factory", iconName: "milkFactory", color: .teal, price: 75000, factoryConsumeEnergy: 100, workersForShift: 35, profit: 50, timeForBuild: 13)
    @Published var oilMill = Factory(id: 3, title: "Oil mill", iconName: "oilMill", color: .orange, price: 35000, factoryConsumeEnergy: 20, workersForShift: 5, profit: 7, timeForBuild: 14)
    @Published var factories = [Factory]()
    
    @Published var chickenFarm = Factory(id: 10, title: "Chicken farm", iconName: "chickenFarm", color: .teal, price: 250000, factoryConsumeEnergy: 20, workersForShift: 20, profit: 50, timeForBuild: 7)
    @Published var cowFarm = Factory(id: 11, title: "Cow farm", iconName: "cowFarm", color: .purple, price: 450000, factoryConsumeEnergy: 70, workersForShift: 30, profit: 70, timeForBuild: 7)
    @Published var gooseFarm = Factory(id: 12, title: "Goose farm", iconName: "gooseFarm", color: .cyan, price: 300000, factoryConsumeEnergy: 25, workersForShift: 20, profit: 60, timeForBuild: 7)
    @Published var pigFarm = Factory(id: 13, title: "Pig farm", iconName: "pigFarm", color: .brown, price: 300000, factoryConsumeEnergy: 18, workersForShift: 25, profit: 55, timeForBuild: 7)
    @Published var farms = [Factory]()
    
    @Published var farmsAndFactories = [Factory]()
    
    init () {
        factories = [bakery, cheeseFactory, milkFactory, oilMill].sorted(by: { $0.profit < $1.profit })
        farms = [chickenFarm, cowFarm, gooseFarm, pigFarm].sorted(by: { $0.profit < $1.profit })
        farmsAndFactories = farms + factories
    }
}

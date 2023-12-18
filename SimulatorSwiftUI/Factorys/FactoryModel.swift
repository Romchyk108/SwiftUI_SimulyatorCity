////
////  FactoryModel.swift
////  SimulatorSwiftUI
////
////  Created by Roman Shestopal on 13.12.2023.
////
//
//import Foundation
//import SwiftUI
//
//class FactoryModel {
//    let id: Int
//    let title: String
//    let iconName: String
//    let color: Color
//    let price: Int
//    let factoryWorkers: Int
//    let factoryConsumeEnergy: Double
//    let profit: Double
//    let timeForBuild: Int
//    var numberForBuild: Int = 0
//    var count: Int = 0
//    var finishTime = [Double]()
//
//    var totalWorkers: Int {
//        factoryWorkers * count
//    }
//    var totalConsumeEnergy: Double {
//        factoryConsumeEnergy * Double(count)
//    }
//    var totalProfit: Double {
//        profit * Double(count)
//    }
//
//    init(id: Int, title: String, iconName: String, color: Color, price: Int, factoryWorkers: Int, factoryConsumeEnergy: Double, profit: Double, timeForBuild: Int) {
//        self.id = id
//        self.title = title
//        self.iconName = iconName
//        self.color = color
//        self.price = price
//        self.factoryWorkers = factoryWorkers
//        self.factoryConsumeEnergy = factoryConsumeEnergy
//        self.profit = profit
//        self.timeForBuild = timeForBuild
//    }
//}

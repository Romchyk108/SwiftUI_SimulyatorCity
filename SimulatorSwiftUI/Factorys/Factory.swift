//
//  Factory.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 13.12.2023.
//

import Foundation
import SwiftUI

protocol TakeTimeDelegate: AnyObject {
    func takeCurrentHour() -> Int
}

class Factory: ObservableObject, Identifiable {
    
    let id: Int
    let title: String
    let iconName: String
    let color: Color
    let price: Int
    let factoryConsumeEnergy: Double
    let workersForShift: Int
    let profit: Double
    let timeForBuild: Int
    
    @Published var numberOfShifts: Int = 0
    @Published var finishTime = [Double]()
    @Published var processBuilding: Double = 0
    @Published var workingTime = 0
    @Published var shifts = [Shift]()
    @Published var isOpenFactory = false
    @Published var totalWorkers = 0
    @Published var firstShiftWorkingTime: Int = 0
    @Published var secondShiftWorkingTime: Int = 0
    @Published var thirdShiftWorkingTime: Int = 0
    
    weak var timeDelegate: TakeTimeDelegate?
    
    init(id: Int, title: String, iconName: String, color: Color, price: Int, factoryConsumeEnergy: Double, workersForShift: Int, profit: Double, timeForBuild: Int) {
        self.id = id
        self.title = title
        self.iconName = iconName
        self.color = color
        self.price = price
        self.factoryConsumeEnergy = factoryConsumeEnergy
        self.workersForShift = workersForShift
        self.profit = profit
        self.timeForBuild = timeForBuild
    }
    
    var totalProfit: Double {
        isWorkingHour && isOpenFactory ? profit : 0
    }
    var isWorkingHour: Bool {
        guard let currentHour = timeDelegate?.takeCurrentHour(), workingHours.contains(currentHour) else { return false }
        return true
    }
    var workingHours = [Int]()
    var error = ""
    var canOpenFactory: Bool {
        Money.shared.money >= price
    }
    var totalConsumeEnergy: Double {
        return isWorkingHour && isOpenFactory ? factoryConsumeEnergy * randomCoefficient : 0.0
    }
    var shiftHours: [Int: Int] = [0: 0, 1: 0, 2: 0]
    private var randomCoefficient = 1.0
    
    func addShift() {
        guard shifts.count < 3 else { return }
        let shift = Shift(startWork: shifts.last?.finishWork ?? 8, numberOfWorker: workersForShift, workingHours: 8)
        workingTime += shift.workingHours
        totalWorkers += shift.numberOfWorker
        shifts.append(shift)
        getWorkingHours()
    }
    
    func removeShift() {
        guard !shifts.isEmpty, let shift = shifts.last else { return }
        workingTime -= shift.workingHours
        totalWorkers -= shift.numberOfWorker
        shifts.removeLast()
        getWorkingHours()
    }
    
    func openFactory() {
        guard canOpenFactory else {
            self.error = localizedString("You have enough money.")
            return
        }
        guard !isOpenFactory else { return }
        Money.shared.money -= price
        self.processBuilding = calculateProcessBuilding()
        finishTime.append((finishTime.last ?? DashboardManager.currentTime) + Double(timeForBuild * 3600))
    }
    
    func closeFactory() {
        Money.shared.money += Int(Double(price) * 0.4)
        if !finishTime.isEmpty {
            self.finishTime.removeFirst()
        }
        totalWorkers = 0
        shifts.removeAll()
        isOpenFactory = false
    }
    
    func checkTime() {
        randomCoefficient = Double(Array(80...125).randomElement() ?? 100) / 100.0
        self.processBuilding = calculateProcessBuilding()
        if let currentFinishTime = finishTime.first, currentFinishTime <= DashboardManager.currentTime {
            finishBuild()
        }
    }
    
    private func getWorkingHours() {
        workingHours.removeAll()
        shifts.forEach({
            workingHours += ($0.startWork..<$0.finishWork).map{ $0 % 24 }
        })
    }
    
    private func finishBuild() {
        if !finishTime.isEmpty {
            finishTime.removeFirst()
            isOpenFactory = true
        }
    }
    
    private func calculateProcessBuilding() -> Double {
        guard let time = finishTime.first else { return 0.0 }
        return 1.0 - ((1.0 / Double(timeForBuild)) * ((time - DashboardManager.currentTime) / 3600))
    }
    
    
}

extension Factory: CreatorTimeLine { }


struct Shift {
    let startWork: Int
    let numberOfWorker: Int
    let workingHours: Int
    var finishWork: Int {
        startWork + workingHours
    }
}

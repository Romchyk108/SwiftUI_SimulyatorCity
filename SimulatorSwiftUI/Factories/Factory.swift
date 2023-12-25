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

protocol CalculatorProcess: AnyObject {
    func calculateProcess(array: [Double], period: Int) -> Double
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
    
    @Published var numberOfShifts = 0
    @Published var finishTime = [Double]()
    @Published var processBuilding = 0.0
    @Published var processInventing = 0.0
    @Published var processImproving = 0.0
    @Published var isOpenFactory = false
    @Published var totalProfit: Double = 0.0
    @Published var totalWorkers = 0
    
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
    
    var tappedInvent = false
    var tappedImprove = false
    
    var isImprovedFactory = false
    var isInventedImprovingFactory = false
    
    var finishInventing = 0.0
    var finishImproving = 0.0
    
    var shifts = [Shift]() {
        didSet{
            numberOfShifts = shifts.count
        }
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
    private var randomCoefficient = 1.0
    private var maxNumberOfWorkers: Int {
        workersForShift * 3
    }
    
    func addShift() {
        guard shifts.count < 3 else { return }
        let shift = Shift(startWork: shifts.last?.finishWork ?? 8, numberOfWorker: workersForShift, workingHours: 8)
        totalWorkers += totalWorkers == 0 ? shift.numberOfWorker + Int(maxNumberOfWorkers / 7) : shift.numberOfWorker
        shifts.append(shift)
        getWorkingHours()
    }
    
    func removeShift() {
        guard !shifts.isEmpty, let shift = shifts.last else {
            totalWorkers = 0
            return
        }
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
        self.processBuilding = calculateProcess(array: finishTime, period: timeForBuild)
        finishTime.append((finishTime.last ?? DashboardManager.currentTime) + Double(timeForBuild * 3600))
    }
    
    func closeFactory() {
        Money.shared.money += Int(Double(price) * 0.4)
        if !finishTime.isEmpty {
            self.finishTime.removeFirst()
        }
        totalWorkers = 0
        totalProfit = 0
        shifts.removeAll()
        isOpenFactory = false
        isImprovedFactory = false
    }
    
    func inventImprove(since: Double) {
        guard Money.shared.money >= (price / 2) else {
            error = "Enough money!"
            return
        }
        Money.shared.money -= (price / 2)
        finishInventing = since
        processInventing = calculateProcess(array: [finishInventing], period: timeForBuild)
    }
    
    func improve() {
        guard Money.shared.money >= (price / 2) else {
            error = "Enough money!"
            return
        }
        Money.shared.money -= (price / 2)
        finishImproving = DashboardManager.currentTime + Double(timeForBuild * 3600)
        processImproving = calculateProcess(array: [finishImproving], period: timeForBuild)
    }
    
    func checkTime() {
        if isImprovedFactory {
            totalProfit = isWorkingHour && isOpenFactory ? profit * 1.25 : 0
            randomCoefficient = Double(Array(85...100).randomElement() ?? 100) / 100.0
        }
        else {
            totalProfit = isWorkingHour && isOpenFactory ? profit : 0
            randomCoefficient = Double(Array(80...125).randomElement() ?? 100) / 100.0
        }
        self.processBuilding = calculateProcess(array: finishTime, period: timeForBuild)
        if let currentFinishTime = finishTime.first, currentFinishTime <= DashboardManager.currentTime {
            finishBuild()
        }
        
        if finishInventing != 0.0, !isInventedImprovingFactory {
            finishInvent()
            processInventing = calculateProcess(array: [finishInventing], period: (timeForBuild))
        }
        if finishImproving != 0.0, !isImprovedFactory {
            finishImprove()
            processImproving = calculateProcess(array: [finishImproving], period: (timeForBuild))
        }
    }
    
    private func getWorkingHours() {
        workingHours.removeAll()
        shifts.forEach({
            workingHours += ($0.startWork..<$0.finishWork).map{ $0 % 24 }
        })
    }
    
    private func finishInvent() {
        if finishInventing <= DashboardManager.currentTime {
            isInventedImprovingFactory = true
        }
    }
    
    private func finishImprove() {
        if finishImproving <= DashboardManager.currentTime {
            isImprovedFactory = true
        }
    }
    
    private func finishBuild() {
        if !finishTime.isEmpty {
            finishTime.removeFirst()
            isOpenFactory = true
        }
    }
}

extension Factory: CreatorTimeLine, CalculatorProcess { }


struct Shift {
    let startWork: Int
    let numberOfWorker: Int
    let workingHours: Int
    var finishWork: Int {
        startWork + workingHours
    }
}

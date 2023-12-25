//
//  EducationUnit.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 2023/12/21.
//

import Foundation
import SwiftUI

protocol InventingDelegate: AnyObject {
    func inventImprovingFactory(for factory: Factory)
}

class EducationUnit: ObservableObject, Identifiable {
    enum EducationLevel {
        case kinderGarden
        case school
        case university
    }
    
    let id: Int
    let educationUnit: EducationLevel
    let title: String
    let imageName: String
    let color: Color
    let price: Int
    let consumeEnergy: Double
    let timeForBuild: Int
    let canInventing: Bool
    let percentFormPopulation: Double
    
    var finishTime = [Double]()
    var error = ""
    var datesInventing = [Double]()
    var inventingFactories = [Factory]()
    
    @Published var isOpen = false
    @Published var canOpen = false
    @Published var workers: Int = 0
    @Published var students: Int = 0
    @Published var totalConsumeEnergy: Double = 0.0
    @Published var processBuilding: Double = 0.0
    @Published var processInventing: Double = 0.0
    
    init(educationUnit: EducationLevel) {
        switch educationUnit {
        case .kinderGarden:
            self.id = 0
            self.title = localizedString("Kinder Garden")
            self.imageName = "kinderGarden"
            self.color = .green
            self.price = 30000
            self.consumeEnergy = 5
            self.timeForBuild = 14
            self.canInventing = false
            self.percentFormPopulation = 0.12
            self.canOpen = true
        case .school:
            self.id = 1
            self.title = localizedString("School")
            self.imageName = "school"
            self.color = .orange
            self.price = 200000
            self.consumeEnergy = 15
            self.timeForBuild = 14
            self.canInventing = false
            self.percentFormPopulation = 0.12
        case .university:
            self.id = 2
            self.title = localizedString("University")
            self.imageName = "university"
            self.color = .red
            self.price = 500000
            self.consumeEnergy = 30
            self.timeForBuild = 14
            self.canInventing = true
            self.percentFormPopulation = 0.1
        }
        self.educationUnit = educationUnit
    }
    
    func openUnit() {
        guard canOpen, Money.shared.money > price else {
            self.error = localizedString("You have enough money.")
            return
        }
        guard !isOpen else { return }
        Money.shared.money -= price
        processBuilding = calculateProcess(array: finishTime, period: timeForBuild)
        finishTime.append(DashboardManager.currentTime + Double(timeForBuild * 3600))
    }
    
    func update(people: Int) {
        students = isOpen ? Int(Double(people) * percentFormPopulation) : 0
        workers = Int((Double(students) * percentFormPopulation).rounded(.up))
        processBuilding = calculateProcess(array: finishTime, period: timeForBuild)
        if let currentFinishTime = finishTime.first, currentFinishTime <= DashboardManager.currentTime {
            finishBuild()
        }
        finishInvent()
    }
    
    func tapInventing(for factory: Factory) {
        datesInventing.append((datesInventing.last ?? DashboardManager.currentTime) + Double(factory.timeForBuild * 3600))
        inventingFactories.append(factory)
        factory.tappedInvent = true
        if let first = datesInventing.first, datesInventing.count <= 1 {
            factory.inventImprove(since: first)
        }
    }
    
    private func finishInvent() {
        if let first = datesInventing.first, first <= DashboardManager.currentTime {
            datesInventing.removeFirst()
            inventingFactories.removeFirst()
            if let dateInventing = datesInventing.first, let factory = inventingFactories.first {
                factory.inventImprove(since: dateInventing)
            }
        }
    }

    private func finishBuild() {
        finishTime.removeFirst()
        isOpen = true
    }
}

extension EducationUnit: CreatorTimeLine, CalculatorProcess { }

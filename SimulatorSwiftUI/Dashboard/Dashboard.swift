//
//  Dashboard.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 25.06.2023.
//

import Foundation

struct Dashboard {
    enum State {
        case pause
        case play
        case forward
    }
    var money: Int
    var workers: Int
    var people: Int
    var date: String
    var weather: String
    var energyPrice: Double
    var generatedEnergy: Double
    var consumeEnergy: Double
    var state: State
}

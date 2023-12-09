//
//  Money.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 16.07.2023.
//

import Foundation

final class Money {
    static var shared = Money()
    var money: Int = 5000000
    
    private init() { }
    
    static func addProfit(_ profit: Double) {
        guard !profit.isNaN else { return }
        self.shared.money += Int(profit)
    }
}

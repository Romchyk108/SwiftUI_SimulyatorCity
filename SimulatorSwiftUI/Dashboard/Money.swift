//
//  Money.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 16.07.2023.
//

import Foundation

final class Money {
    static var shared = Money()
    var money: Int = 1000000
    
    private init() { }
}

//
//  HouseModel.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 16.07.2023.
//

import Foundation
import SwiftUI

struct HouseModel: Identifiable {
    let id: Int
    let title: String
    let icon: String
    let color: Color
    var price: Int
    let comfortLevel: Int
    let timeForBuild: Int
    let generalSquare: Int
    let numberForSES: Int
    var numberCanLiveHere: Int
    
    init(id: Int, title: String, icon: String, color: Color, price: Int, comfortLevel: Int, timeForBuild: Int, numberCanLiveHere: Int, generalSquare: Int, numberForSes: Int) {
        self.id = id
        self.title = title
        self.icon = icon
        self.color = color
        self.price = price
        self.comfortLevel = comfortLevel
        self.timeForBuild = timeForBuild
        self.numberCanLiveHere = numberCanLiveHere
        self.generalSquare = generalSquare
        self.numberForSES = numberForSes
    }
}

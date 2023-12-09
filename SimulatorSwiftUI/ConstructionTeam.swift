//
//  ConstructionTeam.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 01.12.2023.
//

import Foundation

final class ConstructionTeam {
    static var shared = ConstructionTeam()
    var amountTeams: Int = 1
    var freeTeams: Int
    var tasks = [(()->())?]()
    
    private init() {
        self.freeTeams = self.amountTeams
    }
    
    func start(completion: (()->())?) {
        if freeTeams > 1 {
            freeTeams -= 1
            completion
        }
    }
    
    func addTeam() {
        amountTeams += 1
    }
    
    func removeTeam() {
        amountTeams -= 1
    }
}

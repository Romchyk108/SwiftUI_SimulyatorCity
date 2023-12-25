//
//  EducationModel.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 2023/12/21.
//

import Foundation

class EducationModel: ObservableObject {
    @Published var kinderGarden = EducationUnit(educationUnit: .kinderGarden)
    @Published var school = EducationUnit(educationUnit: .school)
    @Published var university = EducationUnit(educationUnit: .university)
    
    var educationUnits = [EducationUnit]()
    
    init() {
        educationUnits = [kinderGarden, school, university]
    }
    
    func update(people: Int) {
        school.canOpen = kinderGarden.isOpen
        university.canOpen = school.isOpen
        educationUnits.forEach({
            $0.update(people: people)
        })
    }
}

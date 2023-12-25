//
//  EducationRowView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 2023/12/21.
//

import SwiftUI

struct EducationRowView: View {
    @ObservedObject var unit: EducationUnit
    
    var body: some View {
        HStack(spacing: 30) {
            Image(unit.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .cornerRadius(30)
                .blur(radius: unit.isOpen ? 0.0 : 3.0)
            VStack(alignment: .leading) {
                Text("\(unit.title)")
                    .lineLimit(2)
                    .padding(10)
                    .background(unit.color)
                    .cornerRadius(10)
                HStack {
                    Image(systemName: unit.educationUnit == .kinderGarden ? "figure.and.child.holdinghands" : "figure.dress.line.vertical.figure")
                        .font(.title)
                    Text(unit.students.scale)
                        .font(.system(size: 14))
                }
            }
        }
        .foregroundColor(unit.isOpen ? .black : .gray)
        .saturation(unit.canOpen ? 1.0 : 0.0)
        .previewLayout(.sizeThatFits)
//        .buttonStyle(.plain)
    }
}

struct EducationRowView_Previews: PreviewProvider {
    static let university = EducationUnit(educationUnit: .university)
    static let school = EducationUnit(educationUnit: .school)
    static let kinderGarden = EducationUnit(educationUnit: .kinderGarden)
    
    static var previews: some View {
        List {
            EducationRowView(unit: kinderGarden)
            EducationRowView(unit: school)
            EducationRowView(unit: university)
        }
    }
}

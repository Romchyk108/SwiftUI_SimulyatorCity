//
//  GeneratingEnergyRow.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 28.06.2023.
//

import SwiftUI

struct GeneratingEnergyRow: View {
    @ObservedObject var unit: GeneratingEnergyUnit
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Image(unit.image)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                if unit.autoAdding {
                    Image(systemName: "goforward")
                        .frame(width: 50, height: 50)
                        .font(.largeTitle)
                        .foregroundColor(unit.color)
                }
            }
            VStack(spacing: 10) {
                Text(unit.title)
                    .font(.system(size: 14))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding(.all, 10)
                    .background(unit.color)
                    .cornerRadius(10)
                HStack(spacing: 10) {
                    Image(systemName: "bolt")
                        .foregroundColor(.green)
                    Text("\(unit.totalPower.scalePower)")
                        .font(.system(size: 14))
                }
                .multilineTextAlignment(.center)
                HStack(spacing: 10) {
                    Image(systemName: "person.2.badge.gearshape")
                        .foregroundColor(.blue)
                    Text("\(unit.totalWorkers)")
                        .font(.system(size: 14))
                }
                .multilineTextAlignment(.center)
            }
        }
    }
}

struct GeneratingEnergyRow_Previews: PreviewProvider {
    static let unit = GeneratingEnergyUnit(id: 0, title: localizedString("SES on the roof of house"), image: "solarPanelOnTheRoof", color: .green, price: 5000, timeForBuilding: 18, powerPerUnit: 5.0, workerPerUnit: 0.35, description: localizedString("Description ses roof"), dependentOnWeather: true)
    static var previews: some View {
        GeneratingEnergyRow(unit: unit)
    }
}

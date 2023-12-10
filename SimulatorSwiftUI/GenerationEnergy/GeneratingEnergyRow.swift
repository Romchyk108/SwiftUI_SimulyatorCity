//
//  GeneratingEnergyRow.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 28.06.2023.
//

import SwiftUI

struct GeneratingEnergyRow: View {
    @Binding var energyManager: GeneratingEnergyManager
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Image(energyManager.energyModel.image)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                if energyManager.autoAdding {
                    Image(systemName: "goforward")
                        .frame(width: 50, height: 50)
                        .font(.largeTitle)
                        .foregroundColor(energyManager.energyModel.color)
                }
            }
            VStack(spacing: 10) {
                Text(energyManager.energyModel.title)
                    .font(.system(size: 14))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding(.all, 10)
                    .background(energyManager.energyModel.color)
                    .cornerRadius(10)
                HStack(spacing: 10) {
                    Image(systemName: "bolt")
                        .foregroundColor(.green)
                    Text("\(energyManager.totalPower.scalePower)")
                        .font(.system(size: 14))
                }
                .multilineTextAlignment(.center)
                HStack(spacing: 10) {
                    Image(systemName: "person.2.badge.gearshape")
                        .foregroundColor(.blue)
                    Text("\(energyManager.totalWorkers)")
                        .font(.system(size: 14))
                }
                .multilineTextAlignment(.center)
            }
        }
    }
}

struct GeneratingEnergyRow_Previews: PreviewProvider {
    static var previews: some View {
        GeneratingEnergyRow(energyManager: .constant(GeneratingEnergyManager.energyManagers[1]))
    }
}

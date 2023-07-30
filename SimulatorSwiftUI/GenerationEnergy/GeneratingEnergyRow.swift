//
//  GeneratingEnergyRow.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 28.06.2023.
//

import SwiftUI

struct GeneratingEnergyRow: View {
    @EnvironmentObject var energyUnit: GeneratingEnergy
    
    var body: some View {
        HStack(spacing: 10) {
            Image(energyUnit.image)
                .resizable()
                .frame(width: 150, height: 150)
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
            VStack(spacing: 10) {
                Text(energyUnit.title)
                    .font(.system(size: 14))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding(.all, 10)
                    .background(energyUnit.color)
                    .cornerRadius(10)
                HStack(spacing: 10) {
                        Image(systemName: "bolt")
                            .foregroundColor(.green)
                        Text("\(energyUnit.totalPower.scalePower)")
                            .font(.system(size: 14))
                }
                .multilineTextAlignment(.center)
                HStack(spacing: 10) {
                        Image(systemName: "person.2.badge.gearshape")
                            .foregroundColor(.blue)
                        Text("\(energyUnit.totalWorkers)")
                            .font(.system(size: 14))
                }
                .multilineTextAlignment(.center)
            }
        }
    }
}

struct GeneratingEnergyRow_Previews: PreviewProvider {
    static var manager = GeneratingEnergyManager(sesRoof: SesRoof(), sesGround: SesGround(), wes: WindPowerPlant(), bpp: BiogasPowerPlant(), smallhpp: SmallHydroPowerPlant(), hpp: HydroPowerPlant(), tpp: ThermalPowerPlant(), npp: NuclearPowerPlant())
    static var previews: some View {
        GeneratingEnergyRow()
            .environmentObject(manager.units[1])
    }
}

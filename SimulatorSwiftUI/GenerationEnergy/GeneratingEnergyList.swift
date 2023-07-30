//
//  GeneratingEnergyView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 27.06.2023.
//

import SwiftUI

struct GeneratingEnergyList: View {
    @EnvironmentObject var manager: GeneratingEnergyManager
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(manager.units, id: \.self.id) { energyUnit in
                        NavigationLink {
                            GeneratingEnergyDetailView()
                                .environmentObject(energyUnit)
                                .environmentObject(manager)
                        } label: {
                            GeneratingEnergyRow()
                                .environmentObject(energyUnit)
                        }
                    }
                    
                    //                    PieChartView()
                    //                        .environmentObject(manager)
                    //                        .frame(width: 300, height: 300)
                }
                PieChartView()
                    .environmentObject(manager)
                    .frame(width: 250, height: 250)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Generating Energy")
    }
    
    private func createCustomBinding<T>(_ data: [T]) -> Binding<[T]> {
        return Binding<[T]> {
            data
        } set: { _ in }
    }
}

struct GeneratingEnergyView_Previews: PreviewProvider {
    static var manager = GeneratingEnergyManager(sesRoof: SesRoof(), sesGround: SesGround(), wes: WindPowerPlant(), bpp: BiogasPowerPlant(), smallhpp: SmallHydroPowerPlant(), hpp: HydroPowerPlant(), tpp: ThermalPowerPlant(), npp: NuclearPowerPlant())
    static var previews: some View {
        GeneratingEnergyList()
            .environmentObject(manager)
    }
}

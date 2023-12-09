//
//  GeneratingEnergyView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 27.06.2023.
//

import SwiftUI

struct GeneratingEnergyList: View {
    @Binding var managers: [GeneratingEnergyManager]
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(managers.indices, id: \.self) { index in
                        NavigationLink {
                            GeneratingEnergyDetailView(manager: $managers[index])
                        } label: {
                            GeneratingEnergyRow(energyManager: $managers[index])
                        }
                    }
                    PieChartView(energyManagers: $managers)
                        .frame(width: 300, height: 300)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(localizedString("GeneratingEnergy"))
    }
    
    private func createCustomBinding<T>(_ data: [T]) -> Binding<[T]> {
        return Binding<[T]> {
            data
        } set: { _ in }
    }
}

struct GeneratingEnergyView_Previews: PreviewProvider {
    static var previews: some View {
        GeneratingEnergyList(managers: .constant(GeneratingEnergyManager.energyManagers))
    }
}

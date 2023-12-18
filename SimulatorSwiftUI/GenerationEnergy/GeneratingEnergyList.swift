//
//  GeneratingEnergyView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 27.06.2023.
//

import SwiftUI

struct GeneratingEnergyList: View {
    @ObservedObject var manager: GeneratingEnergyManager
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(manager.energyUnits, id: \.id) { unit in
                        NavigationLink {
                            GeneratingEnergyDetailView(unit: unit)
                        } label: {
                            GeneratingEnergyRow(unit: unit)
                        }
                    }
                    PieCharView(energyManager: manager)
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
        GeneratingEnergyList(manager: GeneratingEnergyManager())
    }
}

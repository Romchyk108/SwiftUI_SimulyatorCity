//
//  EngineeringView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 08.12.2023.
//

import SwiftUI

struct EngineeringView: View {
    @AppStorage ("sellElectricity") private var sellElectricity = false
    @AppStorage ("investigateGravityBattery") private var investigateGravityBattery = false
    
    @State private var sellElectricityPower = UserDefaults.standard.bool(forKey: "sellElectricity")
    @State private var investigatingGravityBattery = UserDefaults.standard.bool(forKey: "investigateGravityBattery")
    @State private var moneyForInvestigatingGB: Double = 0.2
    var body: some View {
        VStack {
            Toggle(isOn: $sellElectricity) {
                Text("Selling excess electricity power")
            }
            .onTapGesture {
                UserDefaults.standard.set($sellElectricity, forKey: "sellElectricity")
            }
            VStack {
                Toggle(isOn: $investigatingGravityBattery) {
                    Text("Investigate gravity battery")
                }
                .onTapGesture {
                    UserDefaults.standard.set($sellElectricity, forKey: "sellElectricity")
                }
                Slider(value: $moneyForInvestigatingGB, label: {
                    Text(String(format: "%2.1f", (moneyForInvestigatingGB * 100)) + "%")
                })
                    .formStyle(.columns)
            }
        }
        .padding(.horizontal)
        
    }
}

struct EngineeringView_Previews: PreviewProvider {
    static var previews: some View {
        EngineeringView()
    }
}

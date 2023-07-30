//
//  GeneratingEnergyDetailView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 28.06.2023.
//

import SwiftUI

struct GeneratingEnergyDetailView: View {
    @EnvironmentObject var unit: GeneratingEnergy
    @EnvironmentObject var manager: GeneratingEnergyManager
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Image(unit.image)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 200, height: 200, alignment: .center)
                Text("\(unit.title) - \(unit.price.scale)$")
                    .font(.system(size: 14))
                Button {
                    print("+ \(unit.title)")
                    unit.touchPlusButton()
                } label: {
                    Label("Add SES", systemImage: "plus")
                        .labelStyle(.iconOnly)
                        .frame(width: 50, height: 30)
                        .border(Color.green, width: 2)
                        .cornerRadius(12)
                }
                VStack(spacing: 10) {
                    HStack(spacing: 50) {
                        Text("\(unit.count.scale)")
                        Text("\(unit.numberForBuild.scale)")
                    }
                    .padding(.horizontal)
                    HStack(spacing: 50) {
                        HStack() {
                            Image(systemName: "bolt")
                                .foregroundColor(.green)
                            Text("\(unit.totalPower.scalePower)")
                        }
                        .multilineTextAlignment(.leading)
                        HStack() {
                            Image(systemName: "bolt")
                                .foregroundColor(.green)
                            Text("\((unit.powerPerUnit * Double(unit.numberForBuild)).scalePower)")
                        }
                        .multilineTextAlignment(.trailing)
                    }
                    .font(.system(size: 14))
                    .padding(.horizontal)
                    Spacer()
                    HStack(spacing: 50) {
                        HStack() {
                            Image(systemName: "person.2.badge.gearshape")
                                .foregroundColor(.blue)
                            Text("\(unit.totalWorkers)")
                        }
                        .multilineTextAlignment(.leading)
                        HStack() {
                            Image(systemName: "person.2.badge.gearshape")
                                .foregroundColor(.blue)
                            Text("+ \((unit.workerPerUnit * Double(unit.numberForBuild)).scale)")
                        }
                        .multilineTextAlignment(.trailing)
                    }
                    HStack(spacing: 10) {
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                        Text(unit.timeForBuilding.scaleDate)
                    }
                    .padding(.leading, 90)
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: 14))
                }
                .padding(.horizontal, 5)
                .padding(.vertical)
                VStack(spacing: 10) {
                    if !unit.finishTime.isEmpty {
                        Image(systemName: "clock.badge.checkmark")
                            .foregroundColor(.blue)
                        VStack {
                            ForEach(unit.finishTime, id: \.self) { date in
                                Text("\(manager.createTimeLine(time: date))")
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct GeneratingEnergyDetailView_Previews: PreviewProvider {
    static var manager = GeneratingEnergyManager(sesRoof: SesRoof(), sesGround: SesGround(), wes: WindPowerPlant(), bpp: BiogasPowerPlant(), smallhpp: SmallHydroPowerPlant(), hpp: HydroPowerPlant(), tpp: ThermalPowerPlant(), npp: NuclearPowerPlant())
    static var previews: some View {
        GeneratingEnergyDetailView()
            .environmentObject(manager.units[0])
            .environmentObject(manager)
    }
}

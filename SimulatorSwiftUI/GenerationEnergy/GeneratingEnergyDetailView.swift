//
//  GeneratingEnergyDetailView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 28.06.2023.
//

import SwiftUI

struct GeneratingEnergyDetailView: View {
    @ObservedObject var unit: GeneratingEnergyUnit
    @State private var showingAlert = false
    
    private var canTappedPlus: Bool {
        unit.canTappedPlus()
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Image(unit.image)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 200, height: 200, alignment: .center)
                    .onTapGesture {
                        guard canTappedPlus else {
                            showingAlert = true
                            return
                        }
                        unit.tappedPlus()
                    }
                    .onLongPressGesture(minimumDuration: 2) {
                        unit.autoAdding = unit.autoAdding ? false : canTappedPlus
                    }

                Text("\(unit.title) - \(unit.price.scale)$")
                    .font(.system(size: 14))
                Text(unit.description)
                    .font(.system(size: 12))
                HStack {
                    Button {
                        guard canTappedPlus else {
                            showingAlert = true
                            return
                        }
                        unit.autoAdding = false
                        unit.tappedPlus()
                    } label: {
                        Label("Add SES", systemImage: "plus")
                            .labelStyle(.iconOnly)
                            .frame(width: 50, height: 30)
                            .background(canTappedPlus ? unit.color : .gray)
                            .cornerRadius(12)
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(unit.errorMessage), dismissButton: .default(Text("Dismiss")))
                    }
                    
                    if unit.autoAdding {
                        Image(systemName: "goforward")
                            .frame(width: 30, height: 30)
                            .background(unit.color)
                            .cornerRadius(10)
                    }
                }
                VStack(spacing: 10) {
                    HStack {
                        Text("\(unit.count.scale)")
                        Spacer()
                        if unit.id == 0, !canTappedPlus {
                            Text("Not enough houses")
                                .font(.system(size: 12))
                            Spacer()
                        }
                        if unit.numberForBuild != 0 {
                            Text("\(unit.numberForBuild.scale)")
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        HStack() {
                            Image(systemName: "bolt")
                                .foregroundColor(.green)
                            Text("\(unit.totalPower.scalePower)")
                        }
                        Spacer()
                        HStack() {
                            Image(systemName: "bolt")
                                .foregroundColor(.green)
                            Text("\((unit.powerPerUnit * Double(unit.numberForBuild)).scalePower)")
                        }
                    }
                    .font(.system(size: 14))
                    .padding(.horizontal)
                    
                    HStack {
                        HStack() {
                            Image(systemName: "person.2.badge.gearshape")
                                .foregroundColor(.blue)
                            Text("\(unit.totalWorkers.scale)")
                        }
                        Spacer()
                        HStack() {
                            Image(systemName: "person.2.badge.gearshape")
                                .foregroundColor(.blue)
                            Text("+ \((unit.workerPerUnit * Double(unit.numberForBuild)).scale)")
                        }
                    }
                    .font(.system(size: 14))
                    .padding(.horizontal)
                    
                    HStack {
                        if !unit.finishTime.isEmpty {
                            ProgressView(value: unit.buildingProcess, label: {
                                Text(String(format: "%2.1f", (unit.buildingProcess * 100)) + "%")
                            })
                        }
                        Spacer()
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                        Text(unit.timeForBuilding.scaleDate)
                    }
                    .padding(.horizontal)
                    .font(.system(size: 14))
                }
                .padding(.horizontal, 5)
                
                VStack(spacing: 10) {
                    if !unit.finishTime.isEmpty {
                        Image(systemName: "clock.badge.checkmark")
                            .foregroundColor(.blue)
                        VStack {
                            ForEach(unit.finishTime, id: \.self) { date in
                                Text("\(unit.createTimeLine(time: date))")
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 10)
    }
}

struct GeneratingEnergyDetailView_Previews: PreviewProvider {
    static let unit = GeneratingEnergyUnit(id: 0, title: localizedString("SES on the roof of house"), image: "solarPanelOnTheRoof", color: .green, price: 5000, timeForBuilding: 18, powerPerUnit: 5.0, workerPerUnit: 0.35, description: localizedString("Description ses roof"), dependentOnWeather: true)
    static var previews: some View {
        GeneratingEnergyDetailView(unit: unit)
    }
}

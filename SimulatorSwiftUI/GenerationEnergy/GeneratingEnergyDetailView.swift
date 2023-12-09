//
//  GeneratingEnergyDetailView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 28.06.2023.
//

import SwiftUI

struct GeneratingEnergyDetailView: View {
    @Binding var manager: GeneratingEnergyManager
    @State private var showingAlert = false
    
    private var process: Double {
        manager.getProgressValue(for: manager)
    }
    private var canTappedPlus: Bool {
        manager.canTappedPlus(manager)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Image(manager.energyModel.image)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 200, height: 200, alignment: .center)
                    .onTapGesture {
                        guard canTappedPlus else {
                            showingAlert = true
                            return
                        }
                        manager.tappedPlus(unit: manager)
                    }
                Text("\(manager.energyModel.title) - \(manager.energyModel.price.scale)$")
                    .font(.system(size: 14))
                Text(manager.energyModel.description)
                    .font(.system(size: 12))
                Button {
                    guard canTappedPlus else {
                        showingAlert = true
                        return
                    }
                    manager.tappedPlus(unit: manager)
                } label: {
                    Label("Add SES", systemImage: "plus")
                        .labelStyle(.iconOnly)
                        .frame(width: 50, height: 30)
                        .background(canTappedPlus ? .green : .gray)
                        .cornerRadius(12)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(manager.errorMessage), dismissButton: .default(Text("Dismiss")))
                }
                VStack(spacing: 10) {
                    HStack {
                        Text("\(manager.count.scale)")
                        Spacer()
                        if manager.energyModel.id == 0, !canTappedPlus {
                            Text("Not enough houses")
                                .font(.system(size: 12))
                            Spacer()
                        }
                        if manager.numberForBuild != 0 {
                            Text("\(manager.numberForBuild.scale)")
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        HStack() {
                            Image(systemName: "bolt")
                                .foregroundColor(.green)
                            Text("\(manager.totalPower.scalePower)")
                        }
                        Spacer()
                        HStack() {
                            Image(systemName: "bolt")
                                .foregroundColor(.green)
                            Text("\((manager.energyModel.powerPerUnit * Double(manager.numberForBuild)).scalePower)")
                        }
                    }
                    .font(.system(size: 14))
                    .padding(.horizontal)
                    
                    HStack {
                        HStack() {
                            Image(systemName: "person.2.badge.gearshape")
                                .foregroundColor(.blue)
                            Text("\(manager.totalWorkers.scale)")
                        }
                        Spacer()
                        HStack() {
                            Image(systemName: "person.2.badge.gearshape")
                                .foregroundColor(.blue)
                            Text("+ \((manager.energyModel.workerPerUnit * Double(manager.numberForBuild)).scale)")
                        }
                    }
                    .font(.system(size: 14))
                    .padding(.horizontal)
                    
                    HStack {
                        if !manager.finishTime.isEmpty {
                            ProgressView(value: process, label: {
                                Text(String(format: "%2.1f", (process * 100)) + "%")
                            })
                        }
                        Spacer()
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                        Text(manager.energyModel.timeForBuilding.scaleDate)
                    }
                    .padding(.horizontal)
                    .font(.system(size: 14))
                }
                .padding(.horizontal, 5)
                
                VStack(spacing: 10) {
                    if !manager.finishTime.isEmpty {
                        Image(systemName: "clock.badge.checkmark")
                            .foregroundColor(.blue)
                        VStack {
                            ForEach(manager.finishTime, id: \.self) { date in
                                Text("\(manager.createTimeLine(time: date))")
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
    static var previews: some View {
        GeneratingEnergyDetailView(manager: .constant(GeneratingEnergyManager.energyManagers[2]))
    }
}

//
//  DashboardView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 25.06.2023.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var manager: DashboardManager
    @Binding var board: Dashboard
    var body: some View {
        HStack(spacing: 25) {
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "dollarsign")
                    Text("-  \(manager.dashboard.money.scale)")
                }
                HStack {
                    Image(systemName: "person.2.badge.gearshape.fill")
                    Text("-  \(manager.dashboard.workers.scale)")
                }
                HStack {
                    Image(systemName: "person.3.fill")
                    Text("-  \(manager.dashboard.people.scale)")
                }
            }
            .font(.system(size: 14))
            VStack(spacing: 10) {
                PlayButtons(state: $manager.dashboard.state, manager: manager)
                    .frame(width: 80, height: 25)
                Text(manager.dashboard.date)
                    .font(.system(size: 14))
                    .lineLimit(1)
                    .frame(width: 120)
                Image(systemName: manager.dashboard.weather)
                    .frame(width: 25, height: 25)
            }
            .padding(10)
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "bolt")
                        .foregroundColor(.yellow)
                    Text("-  \(manager.dashboard.energyPrice.scale)$")
                        .font(.system(size: 14))
                }
                HStack {
                    Image(systemName: "bolt")
                        .foregroundColor(.green)
                    Text("-  \(manager.dashboard.generatedEnergy.scalePower)")
                        .font(.system(size: 14))
                }
                HStack {
                    Image(systemName: "bolt.ring.closed")
                        .foregroundColor(.red)
                    Text("-  \(manager.dashboard.consumeEnergy.scalePower)")
                        .font(.system(size: 14))
                }
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DashboardModel())
    }
}


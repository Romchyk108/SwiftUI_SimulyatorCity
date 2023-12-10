//
//  DashboardView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 25.06.2023.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var manager: DashboardManager
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(manager.dashboard.date)
                        .monospacedDigit()
                        .font(.system(size: 14))
                        .lineLimit(1)
                }
                .font(.system(size: 14))
                HStack {
                    Image(systemName: "person.2.badge.gearshape.fill")
                    Text("\(manager.dashboard.workers.scale)")
                }
                HStack {
                    Image(systemName: "person.3.fill")
                    Text("\(manager.dashboard.people.scale) / \(manager.placesForPeople.scale)")
                        .background(manager.people > manager.placesForPeople ? .red : .clear)
                    Image(systemName: "person.badge.key.fill")
                }
            }
            .font(.system(size: 14))
            
            Spacer()
            VStack(spacing: 10) {
                PlayButtons(state: $manager.dashboard.state, manager: manager)
                    .frame(width: 100, height: 25)
                
                Image(systemName: manager.dashboard.weather)
                    .frame(width: 25, height: 25)
                    .monospacedDigit()
            }
            
            Spacer()
            VStack(alignment: .trailing, spacing: 10) {
                HStack {
                    Image(systemName: "dollarsign")
                    Text("\(manager.dashboard.money.scale)")
                    Text("+ \(manager.profit.scale)$")
                }
                .frame(width: 120)
                HStack {
                    Text("\(manager.dashboard.generatedEnergy.scalePower)")
                        .background(manager.dashboard.generatedEnergy < manager.dashboard.consumeEnergy ? .red : .clear)
                        .font(.system(size: 14))
                        .lineLimit(1)
                        .monospacedDigit()
                    Image(systemName: "bolt")
                        .foregroundColor(.green)
                }
                HStack {
                    Text("\(manager.dashboard.consumeEnergy.scalePower)")
                        .font(.system(size: 14))
                        .lineLimit(1)
                        .monospacedDigit()
                    Image(systemName: "bolt.ring.closed")
                        .foregroundColor(.red)
                }
            }
            .font(.system(size: 14))
            .padding(.vertical)
        }
        .padding(.horizontal)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static let dashboardManager = DashboardModel().dashboardManager
    static var previews: some View {
        DashboardView()
            .environmentObject(dashboardManager)
    }
}


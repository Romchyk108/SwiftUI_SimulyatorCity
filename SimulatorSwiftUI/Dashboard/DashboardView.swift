//
//  DashboardView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 25.06.2023.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var manager: DashboardManager
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                PlayButtons(state: $manager.dashboard.state, manager: manager)
                    .frame(width: 100, height: 25)
                
                Image(systemName: manager.dashboard.weather)
                    .frame(width: 25, height: 25)
                    .monospacedDigit()
            }
            .frame(alignment: .center)
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(manager.dashboard.date)
                            .monospacedDigit()
                            .font(.system(size: 14))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: true)
                    }
                    HStack {
                        Image(systemName: "person.3.sequence.fill") // person.2.badge.gearshape.fill
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.blue, .green, .red)
                        Text("\(manager.dashboard.people.scale)") // manager.dashboard.workers.scale
                    }
                    HStack {
                        //                    Image(systemName: "person.3.sequence.fill")
                        //                        .symbolRenderingMode(.palette)
                        //                        .foregroundStyle(.blue, .green, .red)
                        Image(systemName: "person.badge.key.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.red, .green)
                        Text("\(manager.placesForPeople.scale)")
                            .background(manager.people > manager.placesForPeople ? .red : .clear)
                    }
                    .frame(alignment: .leading)
                }
                .font(.system(size: 13))
                .frame(alignment: .leading)
                
                Spacer()
                VStack(alignment: .trailing, spacing: 10) {
                    HStack {
                        Image(systemName: "dollarsign")
                        Text("\(manager.dashboard.money.scale)")
                        Text("+ \(manager.profit.scale)")
                    }
                    .frame(alignment: .trailing)
                    HStack {
                        Text("\(manager.dashboard.generatedEnergy.scalePower)")
                            .background(manager.dashboard.generatedEnergy < manager.dashboard.consumeEnergy ? .red : .clear)
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
            }
            .font(.system(size: 13))
        }
        .padding(5)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static let dashboardManager = DashboardModel().dashboardManager
    static var previews: some View {
        DashboardView(manager: dashboardManager)
    }
}


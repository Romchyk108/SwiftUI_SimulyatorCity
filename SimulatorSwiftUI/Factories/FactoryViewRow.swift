//
//  FactoryViewRow.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 13.12.2023.
//

import SwiftUI

struct FactoryViewRow: View {
    @ObservedObject var factory: Factory
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack {
                Image(factory.iconName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .blur(radius: factory.isOpenFactory ? 0.0 : 3.0)
                VStack(spacing: 10) {
                    Text("\(factory.title)")
                        .lineLimit(2)
                        .padding(10)
                        .background(factory.color)
                        .cornerRadius(10)
                    HStack {
                        Text("\(factory.totalProfit.scale) $")
                    }
                    
                    HStack {
                        Image(systemName: "bolt.ring.closed")
                            .foregroundColor(.red)
                        Text("\(factory.totalConsumeEnergy.scalePower)")
                    }
                }
                .aspectRatio(contentMode: .fit)
                .frame(alignment: .leading)
                .font(.system(size: 14))
                Spacer()
            }
            .saturation(factory.isOpenFactory ? 1.0 : 0.0)
            .previewLayout(.sizeThatFits)
            
            if factory.isImprovedFactory {
                Image(systemName: "star.fill")
                    .font(.title3)
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct FactoryViewRow_Previews: PreviewProvider {
    static let bakery = Factory(id: 0, title: "Bakery", iconName: "bakery", color: .cyan, price: 100000, factoryConsumeEnergy: 25000, workersForShift: 30, profit: 3, timeForBuild: 5)
    
    static var previews: some View {
        List {
            FactoryViewRow(factory: bakery)
            FactoryViewRow(factory: bakery)
            FactoryViewRow(factory: bakery)
        }
    }
}

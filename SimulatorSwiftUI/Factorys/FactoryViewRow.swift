//
//  FactoryViewRow.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 13.12.2023.
//

import SwiftUI

struct FactoryViewRow: View {
    @Binding var factory: Factory
    
    var body: some View {
        HStack() {
            Image(factory.iconName)
                .resizable()
                .frame(width: 150, height: 150)
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
            VStack(spacing: 10) {
                Text(factory.title)
                    .font(.system(size: 14))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding(.all, 10)
                    .background(factory.color)
                    .cornerRadius(10)
                HStack(spacing: 10) {
                    Image(systemName: "building")
                        .foregroundColor(.green)
//                    Text("\(factory.count)")
//                        .font(.system(size: 14))
                }
                .multilineTextAlignment(.center)
                
                HStack {
                    Image(systemName: "bolt.ring.closed")
                        .foregroundColor(.red)
                    Text("\(factory.totalConsumeEnergy.scalePower)")
                }
            }
        }
    }
}

struct FactoryViewRow_Previews: PreviewProvider {
    static let bakery = Factory(id: 0, title: "Bakery", iconName: "bakery", color: .cyan, price: 100000, factoryConsumeEnergy: 25000, workersForShift: 30, profit: 3, timeForBuild: 5)
    static var previews: some View {
        FactoryViewRow(factory: .constant(bakery))
    }
}

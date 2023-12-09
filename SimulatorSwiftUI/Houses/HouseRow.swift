//
//  HouseRow.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 16.07.2023.
//

import SwiftUI

struct HouseRow: View {
    @Binding var manager: HouseManager
    
    var body: some View {
        HStack() {
            Image(manager.house.icon)
                .resizable()
                .frame(width: 150, height: 150)
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
            VStack(spacing: 10) {
                Text(manager.house.title)
                    .font(.system(size: 14))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding(.all, 10)
                    .background(manager.house.color)
                    .cornerRadius(10)
                HStack(spacing: 10) {
                    Image(systemName: "building")
                        .foregroundColor(.green)
                    Text("\(manager.count)")
                        .font(.system(size: 14))
                }
                .multilineTextAlignment(.center)
                Stars(number: manager.house.comfortLevel)
                HStack {
                    Image(systemName: "bolt.ring.closed")
                        .foregroundColor(.red)
                    Text("\(manager.consumeElectricity.scalePower)")
                }
            }
        }
    }
}

struct HouseRow_Previews: PreviewProvider {
    static var previews: some View {
        HouseRow(manager: .constant(HouseManager.houseManagers[0]))
    }
}

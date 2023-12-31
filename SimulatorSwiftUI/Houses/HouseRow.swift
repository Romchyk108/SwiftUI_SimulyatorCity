//
//  HouseRow.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 16.07.2023.
//

import SwiftUI

struct HouseRow: View {
    @ObservedObject var house: House
    
    var body: some View {
        HStack() {
            Image(house.icon)
                .resizable()
                .frame(width: 150, height: 150)
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
            VStack(spacing: 10) {
                Text(house.title)
                    .font(.system(size: 14))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding(.all, 10)
                    .background(house.color)
                    .cornerRadius(10)
                HStack(spacing: 10) {
                    Image(systemName: "building")
                        .foregroundColor(.green)
                    Text("\(house.count)")
                        .font(.system(size: 14))
                }
                .multilineTextAlignment(.center)
                Stars(number: house.comfortLevel)
                HStack {
                    Image(systemName: "bolt.ring.closed")
                        .foregroundColor(.red)
                    Text("\(house.consumeElectricity.scalePower)")
                }
            }
        }
    }
}

struct HouseRow_Previews: PreviewProvider {
    static let house = House(id: 0, title: "Cheap House", icon: "cheapHouse", color: .brown, price: 30000, comfortLevel: 2, timeForBuild: 24, numberCanLiveHere: 3, generalSquare: 50, numberForSes: 1)
    static var previews: some View {
        HouseRow(house: house)
    }
}

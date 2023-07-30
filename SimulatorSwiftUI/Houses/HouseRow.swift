//
//  HouseRow.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 16.07.2023.
//

import SwiftUI

struct HouseRow: View {
    @EnvironmentObject var house: HouseModel
    
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
                HStack(spacing: 10) {
                    ForEach(0..<house.comfortLevel) {_ in
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                        .frame(width: 12)
                    }
                }
                .multilineTextAlignment(.center)
            }
        }
    }
}

struct HouseRow_Previews: PreviewProvider {
    static let manager = HouseManager()
    static var previews: some View {
        HouseRow()
            .environmentObject(manager.houses[0])
    }
}

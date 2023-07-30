//
//  FinishedMark.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 28.06.2023.
//

import SwiftUI

struct FinishedMark: View {
    @State var startBuilding: Bool = false
    var time: Double
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .trim(to: startBuilding ? 1: 0)
                    .stroke(.green, lineWidth: 2)
                    .frame(width: 50, height: 50, alignment: .trailing)
                    .animation(.linear(duration: startBuilding ? time : 0), value: startBuilding)
                    .rotationEffect(Angle(degrees: 270))
                    .opacity(!startBuilding ? 0 : 1)
                
                Image(systemName: "checkmark")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                    .scaleEffect(startBuilding ? 1.0 : 0)
                    .animation(.spring(response: 0.2, dampingFraction: 0.2).delay(startBuilding ? time - 0.5 : 0), value: startBuilding)
                    .opacity(!startBuilding ? 0 : 1)
                    
            }
            .onAppear {
                startBuilding.toggle()
            }

            Toggle(startBuilding ? "On" : "Off", isOn: $startBuilding)
        }
    }
}

struct FinishedMark_Previews: PreviewProvider {
    static var previews: some View {
        FinishedMark(startBuilding: true, time: 2)
    }
}

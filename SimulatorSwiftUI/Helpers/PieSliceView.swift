//
//  PieSliceView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 01.07.2023.
//

import SwiftUI

struct PieSliceView: View {
    @ObservedObject var pieSlice: PieSliceData
    var midRadian: Double {
        Double.pi / 2.0 - (pieSlice.startAngle + pieSlice.endAngle).radians / 2.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let width: CGFloat = min(geometry.size.width, geometry.size.height)
                    let height = width
                    
                    let center = CGPoint(x: width * 0.5, y: height * 0.5)
                    
                    path.move(to: center)
                    
                    path.addArc(
                        center: center,
                        radius: width * 0.5,
                        startAngle: Angle(degrees: -90.0) + pieSlice.startAngle,
                        endAngle: Angle(degrees: -90.0) + pieSlice.endAngle,
                        clockwise: false)
                }
                .fill(pieSlice.unit.color)
                if pieSlice.value > 0.0 {
                    Text("\(String(format: "%.1f", pieSlice.value))%")
                        .position(x: geometry.size.width * 0.5 * CGFloat(1.0 + 0.78 * cos(self.midRadian)),
                                  y: geometry.size.width * 0.5 * CGFloat(1.0 - 0.78 * sin(self.midRadian)))
                        .foregroundColor(.white)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        
    }
}

class PieSliceData: ObservableObject {
    let id: Int
    let startAngle: Angle
    let endAngle: Angle
    let unit: GeneratingEnergyUnit
    @Published var value: Double

    init(id: Int, startAngle: Angle, endAngle: Angle, unit: GeneratingEnergyUnit, value: Double) {
        self.id = id
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.unit = unit
        self.value = value
    }
}

//struct PieSliceView_Previews: PreviewProvider {
//    static let pieSlice = PieSliceData(id: 0, startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 120.0), unit: GeneratingEnergyManager.energyManagers[1], value: 45.9)
//    static var previews: some View {
//        PieSliceView(pieSlice: .constant(pieSlice))
//    }
//}

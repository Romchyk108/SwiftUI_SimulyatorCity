//
//  PieCharView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 01.07.2023.
//

import SwiftUI

struct PieChartView: View {
    @Binding var energyManagers: [GeneratingEnergyManager]
    @State var slicesModel = PieSliceDataModel()
    
    var colors: [Color] {
        energyManagers.map{ $0.energyModel.color }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(slicesModel.slices.indices) { index in
                    PieSliceView(pieSlice: $slicesModel.slices[index])
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                Circle()
                    .frame(width: geometry.size.width * 0.6, height: geometry.size.width * 0.6)
                VStack {
                    Text("Total")
                        .font(.title)
                        .foregroundColor(Color.gray)
                    Text(String(slicesModel.sum.scalePower))
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct PieSliceDataModel {
    var slices: [PieSliceData] = []
    let sum: Double
    
    init() {
        self.sum = GeneratingEnergyManager.energyManagers.map{ $0.energyModel.powerPerUnit * Double($0.count) * $0.coefficientDependentWeather }.reduce(0, +)
        var endDeg: Double = 0
        
        for energyManager in GeneratingEnergyManager.energyManagers {
            let degrees: Double = energyManager.totalPower * 360 / sum
            slices.append(PieSliceData(id: energyManager.energyModel.id,
                                       startAngle: Angle(degrees: endDeg),
                                       endAngle: Angle(degrees: endDeg + degrees),
                                       unit: energyManager,
                                       value: energyManager.totalPower * 100 / sum))
            endDeg += degrees
        }
    }
}


struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(energyManagers: .constant(GeneratingEnergyManager.energyManagers))
    }
}

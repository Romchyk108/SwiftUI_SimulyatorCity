//
//  PieCharView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 01.07.2023.
//

import SwiftUI

struct PieCharView: View {
    @ObservedObject var energyManager: GeneratingEnergyManager
    var slicesModel: PieSliceDataModel {
        PieSliceDataModel(manager: energyManager)
    }
    
    var colors: [Color] {
        energyManager.energyUnits.map{ $0.color }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(slicesModel.slices.indices) { index in
                    PieSliceView(pieSlice: slicesModel.slices[index])
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

class PieSliceDataModel: ObservableObject {
    var manager: GeneratingEnergyManager
    @Published var slices: [PieSliceData] = []
    @Published var sum: Double
    
    init(manager: GeneratingEnergyManager) {
        self.manager = manager
        self.sum = manager.energyUnits.map{ $0.powerPerUnit * Double($0.count) * $0.coefficientDependentWeather }.reduce(0, +)
        var endDeg: Double = 0
        
        for unit in manager.energyUnits {
            let degrees: Double = unit.totalPower * 360 / sum
            slices.append(PieSliceData(id: unit.id,
                                       startAngle: Angle(degrees: endDeg),
                                       endAngle: Angle(degrees: endDeg + degrees),
                                       unit: unit,
                                       value: unit.totalPower * 100 / sum))
            endDeg += degrees
        }
    }
}


struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieCharView(energyManager: GeneratingEnergyManager())
    }
}

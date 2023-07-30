//
//  PieCharView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 01.07.2023.
//

import SwiftUI

struct PieChartView: View {
    @EnvironmentObject var manager: GeneratingEnergyManager
    
    var values: [Double] {
        manager.units.map{ $0.powerPerUnit * Double($0.count) }
    }
    var colors: [Color] {
        manager.units.map{ $0.color }
    }
    
    var slicesModel: PieSliceDataModel {
        let model = PieSliceDataModel(units: manager.units)
        return model
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(slicesModel.slices) { slice in
                    PieSliceView()
                        .environmentObject(slice)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                Circle()
                    .frame(width: geometry.size.width * 0.6, height: geometry.size.width * 0.6)
                VStack {
                    Text("Total")
                        .font(.title)
                        .foregroundColor(Color.gray)
                    Text(String(slicesModel.sum.scalePower)) //values.reduce(0, +).scalePower))
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

class PieSliceDataModel: ObservableObject, Identifiable {
    @Published var slices: [PieSliceData] = []
    @Published var sum: Double
    
    init(units: [GeneratingEnergy]) {
        self.sum = units.map{ $0.powerPerUnit * Double($0.count) }.reduce(0, +)
        var endDeg: Double = 0
        
        for (unit) in units {
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
    static var manager = GeneratingEnergyManager(sesRoof: SesRoof(), sesGround: SesGround(), wes: WindPowerPlant(), bpp: BiogasPowerPlant(), smallhpp: SmallHydroPowerPlant(), hpp: HydroPowerPlant(), tpp: ThermalPowerPlant(), npp: NuclearPowerPlant())
    static var arrayGeneratings = [SesRoof(), WindPowerPlant()]
    
    static var previews: some View {
        PieChartView()
            .environmentObject(manager)
    }
}

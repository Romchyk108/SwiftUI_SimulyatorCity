//
//  HouseDetailView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 16.07.2023.
//

import SwiftUI

struct HouseDetailView: View {
    @Binding var houseManager: HouseManager
    @State private var showAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    Image(houseManager.house.icon)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 250, height: 250, alignment: .center)
                        .onTapGesture {
                            if !houseManager.disableButton {
                                houseManager.tappedPlus(house: houseManager)
                            } else {
                                showAlert = true
                            }
                        }
                    HStack {
                        Text("\(houseManager.house.title) - \(houseManager.count.scale)")
                        if houseManager.numberForBuilding != 0 {
                            Text("+ \(houseManager.numberForBuilding)")
                        }
                    }
                    
                    VStack(alignment: .center, spacing: 10) {
                        HStack {
                            Text("Price - \(houseManager.house.price.scale)$")
                            Spacer()
                            Stars(number: houseManager.house.comfortLevel)
                        }
                        HStack {
                            Text("SES on the roof: \(houseManager.existingSES)")
                            Spacer()
                            Text("\(houseManager.house.numberForSES * (houseManager.count == 0 ? 1 : houseManager.count))")
                        }
                        HStack {
                            Text("People which live: \(houseManager.numberWhoLiveHere.scale)")
                            Spacer()
                            Text("can live: \((houseManager.house.numberCanLiveHere * (houseManager.count == 0 ? 1 : houseManager.count)).scale)")
                        }
                        HStack {
                            Spacer()
                            Image(systemName: "bolt.ring.closed")
                                .foregroundColor(.red)
                            Text("\(houseManager.consumeElectricity.scalePower)")
                        }
                        HStack {
                            Spacer()
                            Text("\(localizedString("square")): \(houseManager.house.generalSquare.scale) m^2")
                        }
                        HStack {
                            if !houseManager.finishTime.isEmpty {
                                ProgressView(value: houseManager.buildingProcess, label: {
                                    Text(String(format: "%2.1f", (houseManager.buildingProcess * 100)) + "%")
                                })
                            }
                            Spacer()
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                            Text(houseManager.house.timeForBuild.scaleDate)
                        }
                    }
                    .font(.system(size: 14))
                    .padding(.horizontal)
                        Button(action: {
                            if !houseManager.disableButton {
                                houseManager.tappedPlus(house: houseManager)
                            } else {
                                showAlert = true
                            }
                        }, label: {
                            HStack {
                                Image(systemName: "plus")
                                    .labelStyle(.iconOnly)
                                Image(systemName: "house")
                                    .foregroundColor(houseManager.disableButton ? .white : .brown)
                                    .bold()
                            }
                            .frame(width: 70, height: 30)
                            .background(houseManager.disableButton ? .gray : .cyan)
                            .cornerRadius(12)
                        })
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text(houseManager.errorMessage), dismissButton: .default(Text(localizedString("Dismiss"))))
                        }
                    
                    VStack(spacing: 10) {
                        if !houseManager.finishTime.isEmpty {
                            Image(systemName: "clock.badge.checkmark")
                                .foregroundColor(.blue)
                            VStack {
                                ForEach(houseManager.finishTime, id: \.self) { date in
                                    Text("\(houseManager.createTimeLine(time: date))")
                                }
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width)
            }
        }
    }
}

struct HouseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HouseDetailView(houseManager: .constant(HouseManager.houseManagers[2]))
    }
}

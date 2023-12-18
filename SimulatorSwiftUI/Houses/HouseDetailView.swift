//
//  HouseDetailView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 16.07.2023.
//

import SwiftUI

struct HouseDetailView: View {
    @ObservedObject var house: House
    @State private var showAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                Image(house.icon)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 250, height: 250, alignment: .center)
                    .onTapGesture {
                        if !house.disableButton {
                            house.tappedPlus()
                        } else {
                            showAlert = true
                        }
                    }
                HStack {
                    Text("\(house.title) - \(house.count.scale)")
                    if house.numberForBuilding != 0 {
                        Text("+ \(house.numberForBuilding)")
                    }
                }
                
                VStack(alignment: .center, spacing: 10) {
                    HStack {
                        Text("Price - \(house.price.scale)$")
                        Spacer()
                        Stars(number: house.comfortLevel)
                    }
                    HStack {
                        Text("SES on the roof: \(house.existingSES)")
                        Spacer()
                        Text("\(house.numberForSES * (house.count == 0 ? 1 : house.count))")
                    }
                    HStack {
                        Text("People which live: \(house.numberWhoLiveHere.scale)")
                        Spacer()
                        Text("can live: \((house.numberCanLiveHere * (house.count == 0 ? 1 : house.count)).scale)")
                    }
                    HStack {
                        Spacer()
                        Image(systemName: "bolt.ring.closed")
                            .foregroundColor(.red)
                        Text("\(house.consumeElectricity.scalePower)")
                    }
                    HStack {
                        Spacer()
                        Text("\(localizedString("square")): \(house.generalSquare.scale) m^2")
                    }
                    HStack {
                        if !house.finishTime.isEmpty {
                            ProgressView(value: house.buildingProcess, label: {
                                Text(String(format: "%2.1f", (house.buildingProcess * 100)) + "%")
                            })
                        }
                        Spacer()
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                        Text(house.timeForBuild.scaleDate)
                    }
                }
                .font(.system(size: 14))
                .padding(.horizontal)
                Button(action: {
                    if !house.disableButton {
                        house.tappedPlus()
                    } else {
                        showAlert = true
                    }
                }, label: {
                    HStack {
                        Image(systemName: "plus")
                            .labelStyle(.iconOnly)
                        Image(systemName: "house")
                            .foregroundColor(house.disableButton ? .white : .brown)
                            .bold()
                    }
                    .frame(width: 70, height: 30)
                    .background(house.disableButton ? .gray : .cyan)
                    .cornerRadius(12)
                })
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(house.errorMessage), dismissButton: .default(Text(localizedString("Dismiss"))))
                }
                
                VStack(spacing: 10) {
                    if !house.finishTime.isEmpty {
                        Image(systemName: "clock.badge.checkmark")
                            .foregroundColor(.blue)
                        VStack {
                            ForEach(house.finishTime, id: \.self) { date in
                                Text("\(house.createTimeLine(time: date))")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct HouseDetailView_Previews: PreviewProvider {
    static let house = House(id: 0, title: "Cheap House", icon: "cheapHouse", color: .brown, price: 30000, comfortLevel: 2, timeForBuild: 24, numberCanLiveHere: 3, generalSquare: 50, numberForSes: 1)
    static var previews: some View {
        HouseDetailView(house: house)
    }
}

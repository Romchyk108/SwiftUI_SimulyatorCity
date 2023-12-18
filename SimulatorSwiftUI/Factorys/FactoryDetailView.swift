//
//  FactoryDetailView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 13.12.2023.
//

import SwiftUI

struct FactoryDetailView: View {
    @ObservedObject var factory: Factory
    
    var body: some View {
        ScrollView {
            VStack {
                Image("\(factory.iconName)")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 250, height: 250)
                Text(factory.title)
                Button {
                    factory.isOpenFactory ? factory.closeFactory() : factory.openFactory()
                } label: {
                    if factory.isOpenFactory {
                        Text(factory.finishTime.isEmpty ? "Working \(factory.title)" : "Opening \(factory.title)")
                    } else {
                        Text("Open \(factory.title) - \(factory.price.scale)$")
                    }
                }
                .disabled(!factory.finishTime.isEmpty)
                .frame(width: 250, height: 35)
                .foregroundColor(.blue)
                .background(Color.green)
                .cornerRadius(10)
                
                
                VStack(alignment: .center, spacing: 10) {
                    
                    HStack {
                        Image(systemName: "person.2.badge.gearshape.fill")
                        Text(factory.totalWorkers.scale)
                        
                        Spacer()
                        Text("\(factory.totalConsumeEnergy.scalePower)")
                        Image(systemName: "bolt.ring.closed")
                            .foregroundColor(.red)
                    }
                    
                    HStack {
                        
                        Spacer()
                        Text("\(factory.totalProfit.scale)")
                        Image(systemName: "dollarsign")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        if !factory.finishTime.isEmpty {
                            ProgressView(value: factory.processBuilding, label: {
                                Text(String(format: "%2.1f", (factory.processBuilding * 100)) + "%")
                            })
                            Spacer()
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                            Text(factory.timeForBuild.scaleDate)
                        }
                    }
                }
                .font(.system(size: 14))
                .padding(.horizontal)
                
                
                VStack(spacing: 10) {
                    if !factory.finishTime.isEmpty {
                        Image(systemName: "clock.badge.checkmark")
                            .foregroundColor(.blue)
                        VStack {
                            ForEach(factory.finishTime, id: \.self) { date in
                                Text("\(factory.createTimeLine(time: date))")
                            }
                        }
                    }
                }
                
                if factory.isOpenFactory && factory.finishTime.isEmpty {
                    
                    VStack {
                        HStack(spacing: 35) {
                            Button {
                                factory.addShift()
                            } label: {
                                Image(systemName: "person.fill.badge.plus")
                                    .font(.largeTitle)
                                    .frame(width: 30, height: 30)
                            }
                            Button {
                                factory.removeShift()
                            } label: {
                                Image(systemName: "person.fill.badge.minus")
                                    .font(.largeTitle)
                                    .frame(width: 30, height: 30)
                            }
                        }
                        
                        ForEach(0..<factory.numberOfShifts) { index in
                            HStack {
                                ProgressView(value: factory.processBuilding, label: {
                                    Text(String(format: "%2.1f", (factory.processBuilding * 100)) + "%")
                                })
                                .offset(y: 100)
                                .progressViewStyle(.roundedRectangle)
                            }
                            .frame(height: 200)
                        }
                    }
                    .padding(.horizontal)
                    
                }
            }
        }
    }
}

struct FactoryDetailView_Previews: PreviewProvider {
    static let milkFactory = Factory(id: 1, title: "Milk factory", iconName: "milkFactory", color: .teal, price: 75000, factoryConsumeEnergy: 100000, workersForShift: 20, profit: 5, timeForBuild: 7)
    static var previews: some View {
        FactoryDetailView(factory: milkFactory)
    }
}

struct RoundedRectProgressViewStyle: ProgressViewStyle {
    @State private var progressMeterOffset = CGSize.zero
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 14)
                .frame(width: 200, height: 20)
                .foregroundColor(.blue)
                .overlay(Color.black.opacity(0.5)).cornerRadius(14)
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * 200, height: 20)
                .foregroundColor(.green)
        }
        .rotationEffect(Angle(degrees: 270))
        .padding()
    }
}

extension ProgressViewStyle where Self == RoundedRectProgressViewStyle {
    static var roundedRectangle: RoundedRectProgressViewStyle { .init() }
}

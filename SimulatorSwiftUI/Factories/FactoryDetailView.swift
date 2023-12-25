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
                    .blur(radius: factory.isOpenFactory ? 0.0 : 3.0)
                HStack {
                    Text(factory.title)
                    if factory.isImprovedFactory{
                        Image(systemName: "star")
                            .font(.title3)
                            .foregroundColor(.yellow)
                    }
                }
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
                .foregroundColor(factory.isOpenFactory ? .blue : .black)
                .background(factory.isOpenFactory ? .green : .gray)
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
                        Text("Number of shifts: \(factory.numberOfShifts)")
                        Spacer()
                        Text("\(factory.totalProfit.scale)")
                        Image(systemName: "dollarsign")
                            .foregroundColor(.green)
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
                            .disabled(factory.shifts.count == 3)
                            Button {
                                factory.removeShift()
                            } label: {
                                Image(systemName: "person.fill.badge.minus")
                                    .font(.largeTitle)
                                    .frame(width: 30, height: 30)
                            }
                            .disabled(factory.shifts.isEmpty)
                        }
                    }
                    .padding(.horizontal)
                }
                
                if factory.isOpenFactory, factory.isInventedImprovingFactory, !factory.isImprovedFactory {
                    VStack {
                        Button {
                            factory.improve()
                        } label: {
                            Text("Upgrade your \(factory.title)")
                        }
                        .disabled(factory.isImprovedFactory)
                        .frame(width: 250, height: 35)
                        .foregroundColor(.blue)
                        .background(factory.isImprovedFactory ? .gray : .green)
                        .cornerRadius(10)
                        
                        if factory.isInventedImprovingFactory, factory.finishImproving != 0.0 {
                            ProgressView(value: factory.processImproving, label: {
                                Text(String(format: "%2.1f", (factory.processImproving * 100)) + "%")
                            })
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

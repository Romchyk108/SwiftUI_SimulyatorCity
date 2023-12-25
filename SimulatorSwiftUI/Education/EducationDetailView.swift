//
//  EducationDetailView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 2023/12/21.
//

import SwiftUI

struct EducationDetailView: View {
    @ObservedObject var unit: EducationUnit
    @EnvironmentObject var dashboardManager: DashboardManager
    
    var body: some View {
        ScrollView {
            VStack {
                Image("\(unit.imageName)")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 250, height: 250)
                    .blur(radius: unit.isOpen ? 0.0 : 3.0)
                Text(unit.title)
                Button {
                    if unit.canOpen {
                        unit.openUnit()
                    }
                } label: {
                    if unit.isOpen {
                        Text(unit.finishTime.isEmpty ? "Working \(unit.title)" : "Opening \(unit.title)")
                    } else {
                        Text("Open \(unit.title) - \(unit.price.scale)$")
                    }
                }
                .disabled(!unit.finishTime.isEmpty)
                .frame(width: 250, height: 35)
                .foregroundColor(unit.isOpen ? .blue : .black)
                .background(unit.isOpen ? .green : .gray)
                .cornerRadius(15)
                
                
                VStack(alignment: .center, spacing: 10) {
                    
                    HStack {
                        Image(systemName: "person.2.badge.gearshape.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.green, .red)
                            .font(.title3)
                        Text(unit.workers.scale)
                        
                        Spacer()
                        Text("\(unit.totalConsumeEnergy.scalePower)")
                        Image(systemName: "bolt.ring.closed")
                            .foregroundColor(.red)
                    }
                    
                    HStack {
                        if unit.educationUnit == .kinderGarden {
                            Image(systemName: "figure.and.child.holdinghands")
                                .foregroundStyle(.green)
                                .font(.title3)
                        } else {
                            HStack {
                                Image(systemName: "book")
                                    .foregroundStyle(.angularGradient(Gradient(colors: [.blue, .yellow]), center: .center, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 0)))
                                Image(systemName: "person.3.sequence.fill")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.blue, .green, .yellow)
                            }
                            .font(.title3)
                        }
                        
                        Text("\(unit.students.scale)")
                        Spacer()
                    }
                    
                    HStack {
                        if !unit.finishTime.isEmpty {
                            ProgressView(value: unit.processBuilding, label: {
                                Text(String(format: "%2.1f", (unit.processBuilding * 100)) + "%")
                            })
                            Spacer()
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                            Text(unit.timeForBuild.scaleDate)
                        }
                    }
                }
                .font(.system(size: 14))
                .padding(.horizontal)
                
                VStack(spacing: 10) {
                    if !unit.finishTime.isEmpty {
                        Image(systemName: "clock.badge.checkmark")
                            .foregroundColor(.blue)
                        VStack {
                            ForEach(unit.finishTime, id: \.self) { date in
                                Text("\(unit.createTimeLine(time: date))")
                            }
                        }
                    }
                }
                
                if unit.educationUnit == .university, unit.isOpen, unit.workers != 0 {
                VStack(alignment: .leading, spacing: 10) {
                        ForEach(dashboardManager.factoryModel.farmsAndFactories.indices) { index in
                            if !dashboardManager.factoryModel.farmsAndFactories[index].isInventedImprovingFactory && dashboardManager.factoryModel.farmsAndFactories[index].isOpenFactory {
                                VStack {
                                    HStack {
                                        Button {
                                            unit.tapInventing(for: dashboardManager.factoryModel.farmsAndFactories[index])
                                        } label: {
                                            Text("Improve - \(dashboardManager.factoryModel.farmsAndFactories[index].title)")
                                                .padding(10)
                                                .foregroundColor(.black)
                                                .background(dashboardManager.factoryModel.farmsAndFactories[index].color)
                                                .cornerRadius(10)
                                        }
                                        .disabled(dashboardManager.factoryModel.farmsAndFactories[index].tappedInvent)
                                        
                                        Spacer()
                                        Text("\((dashboardManager.factoryModel.farmsAndFactories[index].price / 2).scale)")
                                        Spacer()
                                    }
                                    
                                    ProgressView(value: dashboardManager.factoryModel.farmsAndFactories[index].processInventing, label: {
                                        Text(String(format: "%2.0f", (dashboardManager.factoryModel.farmsAndFactories[index].processInventing * 100)) + "%")
                                    })
                                }
                            }
                        }
                    }
                    .padding(10)
                }
            }
        }
    }
}

struct EducationDetailView_Previews: PreviewProvider {
    static let university = EducationUnit(educationUnit: .university)
    static var previews: some View {
        EducationDetailView(unit: university)
            .environmentObject(DashboardManager())
    }
}

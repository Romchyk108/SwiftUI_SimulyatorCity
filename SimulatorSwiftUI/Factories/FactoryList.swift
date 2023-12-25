//
//  FactoryList.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 13.12.2023.
//

import SwiftUI

struct FactoryList: View {
    @ObservedObject var factoryModel: FactoryModel
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $selectedTab) {
                    List {
                        ForEach(factoryModel.factories.indices, id: \.self) { index in
                            NavigationLink {
                                FactoryDetailView(factory: factoryModel.factories[index])
                            } label: {
                                FactoryViewRow(factory: factoryModel.factories[index])
                            }
                        }
                    }
                    List {
                        ForEach(factoryModel.farms.indices, id: \.self) { index in
                            NavigationLink {
                                FactoryDetailView(factory: factoryModel.farms[index])
                            } label: {
                                FactoryViewRow(factory: factoryModel.farms[index])
                            }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .ignoresSafeArea()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Factories")
    }
}

struct FactoryList_Previews: PreviewProvider {
    static let dashBoard = DashboardManager()
    static var previews: some View {
        FactoryList(factoryModel: dashBoard.factoryModel)
    }
}

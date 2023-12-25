//
//  EducationList.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 2023/12/21.
//

import SwiftUI

struct EducationList: View {
    @ObservedObject var dashboardManager: DashboardManager
    
    var body: some View {
        List {
            ForEach(dashboardManager.educationModel.educationUnits.indices, id: \.self) { index in
                NavigationLink {
                    EducationDetailView(unit: dashboardManager.educationModel.educationUnits[index])
                        .environmentObject(dashboardManager)
                } label: {
                    EducationRowView(unit: dashboardManager.educationModel.educationUnits[index])
                }
                .disabled(!dashboardManager.educationModel.educationUnits[index].canOpen)
            }
        }
    }
}

struct EducationList_Previews: PreviewProvider {
    static var previews: some View {
        EducationList(dashboardManager: DashboardManager())
    }
}

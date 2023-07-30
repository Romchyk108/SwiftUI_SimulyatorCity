//
//  MainRowView.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 27.06.2023.
//

import SwiftUI

struct MainRowView: View {
    var mainRow: MainRow
    var body: some View {
        HStack(spacing: 20) {
            Image(mainRow.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 150, height: 150)
            VStack(spacing: 10) {
                Text(mainRow.title)
                    .font(.system(size: 16))
                    .padding(.vertical, 5)
                    .lineLimit(2)
                Text(mainRow.description)
                    .font(.system(size: 12))
                    .lineLimit(3)
            }
        }
    }
}

struct MainRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            MainRowView(mainRow: MainRow(id: 1, title: "Generating Energy", image: "generateEnergy", description: "Some description, bla bla bla bla"))
            MainRowView(mainRow:MainRow(id: 1, title: "Hauses", image: "mainRowHause", description: "Some description, bla bla bla bla"))
        }
    }
}

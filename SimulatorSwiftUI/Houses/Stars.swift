//
//  Stars.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 03.12.2023.
//

import SwiftUI

struct Stars: View {
    let number: Int
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<number) { _ in
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
        .previewLayout(/*@START_MENU_TOKEN@*/.sizeThatFits/*@END_MENU_TOKEN@*/)
    }
}

struct Stars_Previews: PreviewProvider {
    static var previews: some View {
        Stars(number: 2)
    }
}

//
//  PlayButton.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 25.06.2023.
//

import SwiftUI

struct PlayButtons: View {
    @Binding var state: Dashboard.State
    var manager: DashboardManager
    var body: some View {
        HStack(spacing: 18) {
            Button {
                state = .pause
                manager.setStateButtons()
            } label: {
                Label("Toggle Favorite", systemImage: state == .pause ? "pause.fill" : "pause")
                    .labelStyle(.iconOnly)
                    .foregroundColor(state == .pause ? .green : .gray)
            }
            Button {
                state = .play
                manager.setStateButtons()
            } label: {
                Label("Toggle Favorite", systemImage: state == .play ? "play.fill" : "play")
                    .labelStyle(.iconOnly)
                    .foregroundColor(state == .play ? .green : .gray)
            }
            Button {
                state = .forward
                manager.setStateButtons()
            } label: {
                Label("Toggle Favorite", systemImage: state == .forward ? "forward.fill" : "forward")
                    .labelStyle(.iconOnly)
                    .foregroundColor(state == .forward ? .green : .gray)
            }
        }
    }
}

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayButtons(state: .constant(.pause), manager: DashboardManager())
    }
}

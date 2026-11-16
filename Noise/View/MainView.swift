//
//  ContentView.swift
//  Noise
//
//  Created by Valeriy Protsenko on 10.11.2026.
//

import SwiftUI

struct MainView: View {
    @State private var viewModel = NoiseMeterViewModel()
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            GridView(cellColors: makeCellColors())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.state.title)
                    .font(.system(size: 56, weight: .light))
                    .foregroundStyle(.white)
                    .frame(height: 68)
                Text(viewModel.state.message)
                    .font(.system(size: 26, weight: .light))
                    .lineSpacing(2)
            }
            
            if viewModel.state.showSettingsButton {
                PrimaryButtonView(title: "Открыть настройки") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        openURL(url)
                    }
                }
            }
        }
        .frame(width: 327)
        .task {
            await viewModel.startMeasuring()
        }
    }
    
    private func makeCellColors() -> [Color] {
        if case .measuring(let decibels) = viewModel.state {
            
            var colors: [Color] = []
            
            for index in 0..<96 {
                let rowFromTop = index / 8
                let column = index % 8
                let rowFromBottom = 11 - rowFromTop
                let position = rowFromBottom * 8 + column
                let cellStart = 30 + Double(position) * 0.75
                
                if decibels > cellStart {
                    colors.append(NoiseLevel(decibels: cellStart).color)
                } else {
                    colors.append(.grayDarkBox)
                }
            }
            return colors
        } else {
            return Array(repeating: .grayDarkBox, count: 96)
        }
    }
    
}

#Preview {
    MainView()
        .preferredColorScheme(.dark)
}

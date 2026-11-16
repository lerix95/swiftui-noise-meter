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
    
    private let micGrayCells: Set<Int> = Set(arrayLiteral: 3, 4, 10, 11, 12, 13, 18, 19, 20, 21, 26, 27, 28, 34, 35, 37, 40, 42, 44, 45, 47, 48, 51, 52, 53, 55, 58, 59, 60, 61, 62, 66, 67, 68, 69, 75, 76, 83, 84, 89, 90, 91, 92, 93, 94)
    private let micRedCells: Set<Int> = [15, 22, 29, 36, 43, 50, 57, 64]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            GridView(cellColors: makeCellColors())
            
            VStack(alignment: .leading, spacing: 4) {
                if !viewModel.state.title.isEmpty {
                    Text(viewModel.state.title)
                        .font(.system(size: 56, weight: .light))
                        .foregroundStyle(.white)
                        .frame(height: 68)
                }
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
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, 50)
        .task {
            await viewModel.startMeasuring()
        }
    }
    
    private func makeCellColors() -> [Color] {
        if case .denied = viewModel.state {
            var colors: [Color] = []
            
            for index in 0..<96 {
                if micRedCells.contains(index) {
                    colors.append(.redBox)
                } else if micGrayCells.contains(index) {
                    colors.append(.grayLightBox)
                } else {
                    colors.append(.grayDarkBox)
                }
            }
            return colors
        }
        
        if case .measuring(let decibels) = viewModel.state {
            var colors: [Color] = []
            for index in 0..<96 {
                let rowFromTop = index / 8
                let column = index % 8
                let rowFromBottom = 11 - rowFromTop
                let position = rowFromBottom * 8 + column
                let cellStart = 30 + Double(position) * 0.75
                
                if decibels > cellStart || position == 0 {
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

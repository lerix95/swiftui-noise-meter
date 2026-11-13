//
//  ContentView.swift
//  Noise
//
//  Created by Valeriy Protsenko on 10.11.2026.
//

import SwiftUI

struct MainView: View {
    @State private var viewModel = NoiseMeterViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            GridView(cellColors: Array(repeating: .grayDarkBox, count: 96))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.state.title)
                    .font(.system(size: 56, weight: .light))
                    .foregroundStyle(.white)
                    .frame(height: 68)
                Text(viewModel.state.message)
                    .font(.system(size: 26, weight: .light))
                    .lineSpacing(2)
            }
        }
        .frame(width: 327)
        .task {
            await viewModel.startMeasuring()
        }
    }
}

#Preview {
    MainView()
        .preferredColorScheme(.dark)
}

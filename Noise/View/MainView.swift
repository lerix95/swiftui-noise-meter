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
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.state.title)
                .font(.system(size: 56, weight: .light))
            
            Text(viewModel.state.message)
                .font(.system(size: 26, weight: .light))
        }
        .padding()
        .task {
            await viewModel.startMeasuring()
        }
    }
}

#Preview {
    MainView()
        .preferredColorScheme(.dark)
}

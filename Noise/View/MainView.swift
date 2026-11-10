//
//  ContentView.swift
//  Noise
//
//  Created by Valeriy Protsenko on 10.11.2026.
//

import SwiftUI

struct MainView: View {
    let audioMeter = AudioMeter()
    
    var body: some View {
        VStack {
            Text("Тест микрофона")
        }
        .task {
            await audioMeter.requestPermission()
            audioMeter.configureSession()
        }
    }
}

#Preview {
    MainView()
        .preferredColorScheme(.dark)
}

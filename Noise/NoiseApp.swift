//
//  NoiseApp.swift
//  Noise
//
//  Created by Valeriy Protsenko on 10.11.2026.
//

import SwiftUI

@main
struct NoiseApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.launchBackground)
                .preferredColorScheme(.dark)
        }
    }
}

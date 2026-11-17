//
//  NoiseMeterViewModel.swift
//  Noise
//
//  Created by Valeriy Protsenko on 11.11.2026.
//

import Foundation
import Observation

@Observable
class NoiseMeterViewModel {
    var state = MeterState.requesting
    private let audioMeter = AudioMeter()
    private var smoothedDecibels: Double?
    private var isRunning = false
    
    private let calibrationOffset = 105.0
    private let smoothingFactor = 0.2
    
    init() {
        audioMeter.onInterruptionBegan = { [weak self] in
            self?.stopMeasuring()
        }
        audioMeter.onInterruptionEnded = { [weak self] in
            Task { await self?.startMeasuring() }
        }
        audioMeter.observeInterruptions()
    }
    
    func startMeasuring() async {
        guard !isRunning else { return }
        isRunning = true
        
        let granted = await audioMeter.requestPermission()
        guard granted else {
            state = .denied
            isRunning = false
            return
        }
        
        if !state.isMeasuring {
            state = .listening
        }
        
        await audioMeter.configureSession()
        audioMeter.onDecibels = { [weak self] decibels in
            Task { @MainActor in
                self?.updateLevel(decibels)
            }
        }
        audioMeter.start()
    }
    
    func stopMeasuring() {
        guard isRunning else { return }
        audioMeter.stop()
        isRunning = false
        smoothedDecibels = nil
    }
    
    private func updateLevel(_ decibels: Float) {
        let calibrated = max(Double(decibels) + calibrationOffset, 0)
        
        if let previous = smoothedDecibels {
            smoothedDecibels = previous + (calibrated - previous) * smoothingFactor
        } else {
            smoothedDecibels = calibrated
        }
        
        state = .measuring(decibels: smoothedDecibels ?? calibrated)
    }
}

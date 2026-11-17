//
//  AudioMeter.swift
//  Noise
//
//  Created by Valeriy Protsenko on 10.11.2026.
//

import AVFoundation

class AudioMeter {
    private let audioEngine = AVAudioEngine()
    var onDecibels: ((Float) -> Void)?
    var onInterruptionBegan: (() -> Void)?
    var onInterruptionEnded: (() -> Void)?
    
    func requestPermission() async -> Bool {
        let granted = await AVAudioApplication.requestRecordPermission()
        return granted
    }
    
    @concurrent nonisolated func configureSession() async {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.record, mode: .measurement)
            try session.setActive(true)
        } catch {
            print("Session error: \(error)")
        }
    }
    
    func start() {
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 4096, format: format) { buffer, _ in
            let decibels = self.calculateDecibels(from: buffer)
            self.onDecibels?(decibels)
        }
        
        do {
            try audioEngine.start()
        } catch {
            print("Engine error: \(error)")
        }
    }
    
    private func calculateDecibels(from buffer: AVAudioPCMBuffer) -> Float {
        guard let samples = buffer.floatChannelData?[0] else {
            return -160
        }
        
        let numberCount = Int(buffer.frameLength)
        
        var sum: Float = 0
        for i in 0..<numberCount {
            sum += samples[i] * samples[i]
        }
        
        let rms = sqrt(sum / Float(numberCount))
        
        guard rms > 0 else {
            return -160
        }
        
        return 20 * log10(rms)
    }
    
    func stop() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setActive(false)
        } catch {
            print("Stop error: \(error)")
        }
    }
    
    func observeInterruptions() {
        Task {
            for await notification in NotificationCenter.default.notifications(
                named: AVAudioSession.interruptionNotification
            ) {
                guard let value = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt,
                      let type = AVAudioSession.InterruptionType(rawValue: value) else {
                    continue
                }
                
                switch type {
                case .began:
                    onInterruptionBegan?()
                case .ended:
                    onInterruptionEnded?()
                @unknown default:
                    break
                }
            }
        }
    }
}

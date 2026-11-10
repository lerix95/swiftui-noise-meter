//
//  AudioMeter.swift
//  Noise
//
//  Created by Valeriy Protsenko on 10.11.2026.
//

import AVFoundation

class AudioMeter {
    func requestPermission() async -> Bool {
        let granted = await AVAudioApplication.requestRecordPermission()
        print("Разрешено: \(granted)")
        return granted
    }
    
    func configureSession() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.record, mode: .measurement)
            try session.setActive(true)
            print("Сессия готова")
        } catch {
            print("Ошибка сессии: \(error)")
        }
    }
}

//
//  AudioMeter.swift
//  Noise
//
//  Created by Valeriy Protsenko on 10.11.2026.
//

import AVFoundation

class AudioMeter {
    var audioEngine = AVAudioEngine()
    
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
    
    func start() {
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 4096, format: format) { buffer, time in
            print("Пачка: \(buffer.frameLength)")
        }
        
        do {
            try audioEngine.start()
            print("Движок запущен")
        } catch {
            print("Ошибка движка: \(error)")
        }
    }
}

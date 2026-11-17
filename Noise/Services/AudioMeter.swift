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
    
    func requestPermission() async -> Bool {
        let granted = await AVAudioApplication.requestRecordPermission()
        print("Разрешено: \(granted)")
        return granted
    }
    
    @concurrent nonisolated func configureSession() async {
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
            let decibels = self.calculateDecibels(from: buffer)
            self.onDecibels?(decibels)
        }
        
        do {
            try audioEngine.start()
            print("Движок запущен")
        } catch {
            print("Ошибка движка: \(error)")
        }
    }
    
    func calculateDecibels(from buffer: AVAudioPCMBuffer) -> Float {
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
            print("Сессия остановлена")
        } catch {
            print("Ошибка остановки сессии: \(error)")
        }
    }
        Task {                                                     // отдельная задача: ждёт всё время
                named: AVAudioSession.interruptionNotification     // ждём только уведомления о прерываниях
                    continue                                       // битое уведомление — ждём следующее
                }

                switch type {                                      // системный enum
}

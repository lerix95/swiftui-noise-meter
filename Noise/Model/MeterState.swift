//
//  MeterState.swift
//  Noise
//
//  Created by Valeriy Protsenko on 10.11.2026.
//

import Foundation

enum MeterState {
    case requesting
    case denied
    case listening
    case measuring(decibels: Double)
    
    var title: String {
        switch self {
        case .requesting:
            ""
        case .denied:
            ""
        case .listening:
            "Слушаю..."
        case .measuring(let decibels):
            "\(Int(decibels)) dB"
        }
    }
    
    var message: String {
        switch self {
        case .requesting:
            ""
        case .denied:
            "Разрешите доступ к микрофону в Настройках."
        case .listening:
            "Первый замер займёт пару секунд, подождите."
        case .measuring(let decibels):
            NoiseLevel(decibels: decibels).description
        }
    }
    
    var showSettingsButton: Bool {
        switch self {
        case .denied:
            true
        default:
            false
        }
    }
    
    var isMeasuring: Bool {
        switch self {
        case .measuring:
            true
        default:
            false
        }
    }
}

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
            "Listening…"
        case .measuring(let decibels):
            "\(Int(decibels)) dB"
        }
    }
    
    var message: String {
        switch self {
        case .requesting:
            ""
        case .denied:
            "Allow microphone access in Settings."
        case .listening:
            "The first measurement takes a couple of seconds."
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

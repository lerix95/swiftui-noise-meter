//
//  NoiseLevel.swift
//  Noise
//
//  Created by Valeriy Protsenko on 10.11.2026.
//

import SwiftUI

enum NoiseLevel {
    case normal, elevated, dangerous
    
    init(decibels: Double) {
        switch decibels {
        case ..<60:
            self = .normal
        case 60..<84:
            self = .elevated
        default:
            self = .dangerous
        }
    }
    
    var color: Color {
        switch self {
        case .normal:
                .greenBox
        case .elevated:
                .yellowBox
        case .dangerous:
                .redBox
        }
    }
    
    var description: String {
        switch self {
        case .normal:
            "Normal noise level, nothing to worry about."
        case .elevated:
            "Elevated noise level, consider taking a break."
        case .dangerous:
            "Dangerous noise level, please protect your hearing."
        }
    }
}

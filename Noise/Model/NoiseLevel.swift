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
            "Нормальный уровень шума, можно не переживать."
        case .elevated:
            "Повышенный уровень шума, сделайте перерыв."
        case .dangerous:
            "Опасный уровень шума, пожалуйста, берегите слух."
        }
    }
}

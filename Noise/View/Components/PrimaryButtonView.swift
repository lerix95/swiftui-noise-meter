//
//  PrimaryButtonView.swift
//  Noise
//
//  Created by Valeriy Protsenko on 16.11.2026.
//

import SwiftUI

struct PrimaryButtonView: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    PrimaryButtonView(title: "Открыть Настройки", action: {})
        .padding(.horizontal, 38)
        .preferredColorScheme(.dark)
}

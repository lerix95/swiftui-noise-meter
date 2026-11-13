//
//  GridView.swift
//  Noise
//
//  Created by Valeriy Protsenko on 11.11.2026.
//

import SwiftUI

struct GridView: View {
    let cellColors: [Color]
    private let cellSize: CGFloat = 33
    private let cellSpacing: CGFloat = 9
    private let cellCornerRadius: CGFloat = 6
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.fixed(cellSize), spacing: cellSpacing), count: 8)
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: cellSpacing) {
            ForEach(0..<cellColors.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: cellCornerRadius)
                    .fill(cellColors[index])
                    .frame(width: cellSize, height: cellSize)
            }
        }
    }
}

#Preview {
    GridView(cellColors: Array(repeating: .grayLightBox, count: 96))
        .preferredColorScheme(.dark)
}

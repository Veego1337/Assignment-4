//
//  ColorExtensions.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

extension Color {
    static let colors: [Color] = [
        .green, .red, .blue, .gray, .yellow, .pink, .orange, .purple
    ]

    static func random() -> Color {
        colors.randomElement() ?? .black
    }

    // Adaptive background and bar colors for iOS 14
    static var background: Color {
        Color(UIColor.systemGroupedBackground)
    }

    static var bar: Color {
        Color(UIColor.secondarySystemBackground)
    }

    static var cardShadow: Color {
        Color.black.opacity(0.15)
    }
}

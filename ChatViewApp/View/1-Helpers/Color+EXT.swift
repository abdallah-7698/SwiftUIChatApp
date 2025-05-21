//
//  Color+EXT.swift
//  ChatViewApp
//
//  Created by name on 20/05/2025.
//

import SwiftUI

extension Color {
    // Neumorphic Core
    static let lightShadow = Color(red: 1.0, green: 1.0, blue: 1.0) // #FFFFFF
    static let darkShadow = Color(red: 163 / 255, green: 177 / 255, blue: 198 / 255) // #A3B1C6
    static let background = Color(red: 224 / 255, green: 229 / 255, blue: 236 / 255) // #E0E5EC
    static let neumorphictextColor = Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255) // #848484

    // Neumorphic Variants (for Cards, Inputs, etc.)
    static let surface = Color(red: 209 / 255, green: 217 / 255, blue: 230 / 255) // #D1D9E6
    static let elevatedSurface = Color(red: 191 / 255, green: 200 / 255, blue: 215 / 255) // #BFC8D7

    // Accent Colors (for buttons, highlights, icons)
    static let accentBlue = Color(red: 115 / 255, green: 143 / 255, blue: 199 / 255) // #738FC7
    static let accentIndigo = Color(red: 96 / 255, green: 119 / 255, blue: 165 / 255) // #6077A5
    static let accentGreen = Color(red: 151 / 255, green: 203 / 255, blue: 179 / 255) // #97CBB3

    // Message Bubble Colors
    static let senderBubble = Color(red: 209 / 255, green: 217 / 255, blue: 230 / 255) // #D1D9E6
    static let receiverBubble = Color(red: 241 / 255, green: 243 / 255, blue: 246 / 255) // #F1F3F6

    // Warnings and Status
    static let errorRed = Color(red: 235 / 255, green: 87 / 255, blue: 87 / 255) // #EB5757
    static let successGreen = Color(red: 56 / 255, green: 178 / 255, blue: 172 / 255) // #38B2AC
    static let warningYellow = Color(red: 255 / 255, green: 193 / 255, blue: 7 / 255) // #FFC107
}

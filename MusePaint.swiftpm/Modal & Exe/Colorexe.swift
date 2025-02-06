//
//  Colorexe.swift
//  MusePaint
//
//  Created by Prince Yadav on 04/02/25.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&int)
        
        let red, green, blue, alpha: Double
        switch hexSanitized.count {
        case 6: 
            red   = Double((int >> 16) & 0xFF) / 255.0
            green = Double((int >>  8) & 0xFF) / 255.0
            blue  = Double((int      ) & 0xFF) / 255.0
            alpha = 1.0
        case 8:
            alpha = Double((int >> 24) & 0xFF) / 255.0
            red   = Double((int >> 16) & 0xFF) / 255.0
            green = Double((int >>  8) & 0xFF) / 255.0
            blue  = Double((int      ) & 0xFF) / 255.0
        default:
            red = 0; green = 0; blue = 0; alpha = 1
        }
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}

struct PianoColorScheme: Hashable {
    let id: String  // Unique identifier
    let whiteKeyColor: Color
    let blackKeyColor: Color
    let selectedColor: Color
    let backgroundColor: Color
    let labelColor: Color
    
    static let classic = PianoColorScheme(
        id: "classic",
        whiteKeyColor: .white,
        blackKeyColor: .black,
        selectedColor: .blue,
        backgroundColor: Color.black.opacity(0.1),
        labelColor: .white
    )
    
    static let warm = PianoColorScheme(
        id: "warm",
        whiteKeyColor: Color(hex: "#FAF2E6"),
        blackKeyColor: Color(hex: "#4D3321"),
        selectedColor: .orange,
        backgroundColor: Color(hex: "#F2E0D0"),
        labelColor: Color(hex: "#664D3D")
    )
    
    static let cool = PianoColorScheme(
        id: "cool",
        whiteKeyColor: Color(hex: "#F2FAFF"),
        blackKeyColor: Color(hex: "#334D66"),
        selectedColor: Color.blue.opacity(0.6),
        backgroundColor: Color(hex: "#D9ECFF"),
        labelColor: Color(hex: "#4D6699")
    )
    
    static let vibrant = PianoColorScheme(
        id: "vibrant",
        whiteKeyColor: Color(hex: "#FFD700"), // Gold
        blackKeyColor: Color(hex: "#8B0000"), // Dark Red
        selectedColor: Color(hex: "#FF4500"), // Orange Red
        backgroundColor: Color(hex: "#FFEC8B"), // Light Yellow
        labelColor: Color(hex: "#5B2C6F") // Purple Accent
    )
    
    static let darkMode = PianoColorScheme(
        id: "darkMode",
        whiteKeyColor: Color(hex: "#333333"), // Dark Gray
        blackKeyColor: Color(hex: "#000000"), // Black
        selectedColor: Color(hex: "#00FFCC"), // Cyan Accent
        backgroundColor: Color(hex: "#1C1C1C"), // Dark Background
        labelColor: Color(hex: "#CCCCCC") // Light Gray
    )
    
    static let pastel = PianoColorScheme(
        id: "pastel",
        whiteKeyColor: Color(hex: "#FFEBE9"), // Light Pink
        blackKeyColor: Color(hex: "#6D597A"), // Muted Purple
        selectedColor: Color(hex: "#8ACDD7"), // Soft Blue
        backgroundColor: Color(hex: "#E5D1FA"), // Lavender
        labelColor: Color(hex: "#5D5D5D") // Soft Gray
    )

    static let neon = PianoColorScheme(
        id: "neon",
        whiteKeyColor: Color(hex: "#0FF0FC"), // Bright Cyan
        blackKeyColor: Color(hex: "#8D00FF"), // Deep Purple
        selectedColor: Color(hex: "#FF00FF"), // Neon Pink
        backgroundColor: Color(hex: "#202020"), // Almost Black
        labelColor: Color(hex: "#E0E0E0") // Soft White
    )

    // Computed property for easy iteration
    static var allSchemes: [PianoColorScheme] {
        [classic, warm, cool, vibrant, darkMode, pastel, neon]
    }
}

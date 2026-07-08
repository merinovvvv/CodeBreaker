//
//  ext+Color.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 08.07.2026.
//

import SwiftUI

extension Color {
    private static let knownPegColors: [String: Color] = [
        "red": .red, "green": .green, "yellow": .yellow,
        "blue": .blue, "purple": .purple, "orange": .orange,
        "pink": .pink, "clear": .clear, "brown": .brown
    ]
    
    init?(pegString: String) {
        guard let color = Color.knownPegColors[pegString] else { return nil }
        self = color
    }
}

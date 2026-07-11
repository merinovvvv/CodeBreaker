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

extension Animation {
    static let codeBreaker = Animation.bouncy
    static let guess = codeBreaker
    static let restart = codeBreaker
    static let selection = codeBreaker
}

extension AnyTransition {
    static let pegChooser = AnyTransition.offset(x: 0, y: 200)
    static func attempts(_ isGameOver: Bool) -> AnyTransition {
        .asymmetric(
            insertion: isGameOver ? .identity : .move(edge: .top),
            removal: .offset(x: 400, y: 0)
        )
    }
    
}

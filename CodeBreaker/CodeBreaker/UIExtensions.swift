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
        "pink": .pink, "clear": .clear, "brown": .brown,
        "cyan": .cyan, "gray": .gray
    ]
    
    var pegString: String? {
        return Color.knownPegColors.first(where: { $0.value == self })?.key
    }
    
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
            removal: .move(edge: .trailing).combined(with: .offset(x: 50))
        )
    }
    
}

extension View {
    func flexibleSize(minimum: CGFloat = 8, maximum: CGFloat = 80) -> some View {
        self
            .font(.system(size: maximum))
            .minimumScaleFactor(minimum / maximum)
    }
}

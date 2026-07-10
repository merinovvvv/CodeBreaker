//
//  ContentView.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 07.07.2026.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Constants
    struct GuessButton {
        static let maxFontSize: CGFloat = 80
        static let minFontSize: CGFloat = 8
        static let minimumScaleFactor = minFontSize / maxFontSize
    }
    
    struct RestartButton {
        static let fontSize: CGFloat = 35
    }
    
    // MARK: Data Owned by me
    @State private var game = CodeBreaker(pegsCount: [3, 4, 5, 6].randomElement() ?? 4, pegChoices: ["blue", "green", "red", "purple"])
    @State private var selected: Int = 0
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
                .transaction { transaction in
                    transaction.animation = .none
                }
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selected: $selected) {
                        guessButton
                    }
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index]) {
                        if let mathces = game.attempts[index].matches {
                            MatchMarkers(matches: mathces)
                        }
                    }
                }
            }
            PegChooser(choices: game.pegChoices) { peg in
                game.changeSelectedGuess(peg, at: selected)
                selected = (selected + 1) % game.pegsCount
            }
            .padding()
            restartButton
        }
        .padding()
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
                selected = 0
            }
        }
        .font(.system(size: GuessButton.maxFontSize))
        .minimumScaleFactor(GuessButton.minimumScaleFactor)
        .disabled(!game.isActive)
    }
    
    var restartButton: some View {
        Button("Restart") {
            withAnimation {
                game.restart()
            }
        }
        .font(.system(size: RestartButton.fontSize))
    }
}

#Preview {
    CodeBreakerView()
}

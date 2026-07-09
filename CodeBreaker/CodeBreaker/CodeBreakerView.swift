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
            view(for: game.masterCode)
            ScrollView {
                if !game.isOver {
                    view(for: game.guess)
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
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
            game.restart()
        }
        .font(.system(size: RestartButton.fontSize))
    }
    
    func view(for code: Code) -> some View {
        HStack {
            CodeView(code: code, selected: $selected)
            Circle().foregroundStyle(Color.clear)
                .overlay {
                    if let mathces = code.matches {
                        MatchMarkers(matches: mathces)
                    } else {
                        if code.kind == .guess {
                            guessButton
                        }
                    }
                }
        }
    }
}

#Preview {
    CodeBreakerView()
}

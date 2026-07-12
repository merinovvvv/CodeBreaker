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
    
    @State private var selection: Int = 0
    @State private var restarting: Bool = false
    @State private var hideMostRecentMarkers: Bool = false
    @State private var finishing: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
                .transaction { transaction in
                    transaction.animation = .none
                }
            ScrollView {
                if !game.isOver || restarting {
                    CodeView(code: game.guess, selected: $selection) {
                        guessButton
                    }
                    .opacity(restarting ? 0 : 1)
                    .animation(nil, value: game.attempts.count)
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index]) {
                        let isShowMarkers = !hideMostRecentMarkers || index != game.attempts.count - 1
                        if isShowMarkers, let mathces = game.attempts[index].matches {
                            MatchMarkers(matches: mathces)
                        }
                    }
                    .transition(.attempts(game.isOver))
                }
            }
            .scrollIndicators(.hidden)
            if !game.isOver {
                PegChooser(choices: game.pegChoices, onChoose: changePeg)
                    .transition(.pegChooser)
            }
            restartButton
                .opacity(finishing ? 0 : 1)
        }
        .padding()
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation(.guess) {
                hideMostRecentMarkers = true
                game.attemptGuess()
                if game.isOver {
                    finishing = true
                }
                selection = 0
            } completion: {
                withAnimation(.guess) {
                    hideMostRecentMarkers = false
                    finishing = false
                }
            }
        }
        .font(.system(size: GuessButton.maxFontSize))
        .minimumScaleFactor(GuessButton.minimumScaleFactor)
        .disabled(!game.isActive)
    }
    
    var restartButton: some View {
        Button("Restart") {
            withAnimation(.restart) {
                restarting = true
                game.attempts.removeAll()
            } completion: {
                var noAnimation = Transaction()
                noAnimation.disablesAnimations = true
                withTransaction(noAnimation) {
                    game.restart()
                    selection = 0
                }
                withAnimation(.restart) {
                    restarting = false
                }
            }
        }
        .font(.system(size: RestartButton.fontSize))
    }
    
    // MARK: - Functions
    
    func changePeg(to peg: Peg) {
        game.changeSelectedGuess(peg, at: selection)
        selection = (selection + 1) % game.pegsCount
    }
}

#Preview {
    CodeBreakerView()
}

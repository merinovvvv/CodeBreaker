//
//  ContentView.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 07.07.2026.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Constants
    struct RestartButton {
        static let fontSize: CGFloat = 35
    }
    
    // MARK: Data In
    let game: CodeBreaker
    
    // MARK: Data Owned by me
    @State private var selection: Int = 0
    @State private var restarting: Bool = false
    @State private var hideMostRecentMarkers: Bool = false
    @State private var finishing: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            CodeView(code: game.masterCode) {
                TimerView(startDate: game.startDate, endDate: game.endDate)
                    .flexibleSize()
                    .monospaced()
                    .lineLimit(1)
            }
                .transaction { transaction in
                    transaction.animation = .none
                }
            ScrollView {
                if !game.isOver || restarting {
                    CodeView(code: game.guess, selected: $selection) {
                        guessButton
                            .flexibleSize()
                    }
                    .opacity(restarting ? 0 : 1)
                    .animation(nil, value: game.attempts.count)
                }
                ForEach(game.attempts.reversed(), id: \.pegs) { attempt in
                    CodeView(code: attempt) {
                        let isShowMarkers = !hideMostRecentMarkers || attempt.pegs != game.attempts.last?.pegs
                        if isShowMarkers, let mathces = attempt.matches {
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
    CodeBreakerView(game: CodeBreaker(name: "Preview", pegsCount: 3, pegChoices: ["red", "green", "blue"]))
}

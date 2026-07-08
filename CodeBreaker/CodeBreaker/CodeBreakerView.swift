//
//  ContentView.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 07.07.2026.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game = CodeBreaker(pegsCount: [3, 4, 5, 6].randomElement() ?? 4, pegChoices: ["blue", "green", "red", "purple"])
    
    var body: some View {
        VStack {
            view(for: game.masterCode)
            ScrollView {
                view(for: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
            restartButton
        }
        .padding()
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
        .disabled(!game.isActive)
    }
    
    var restartButton: some View {
        Button("Restart") {
            withAnimation {
                game.restart()
            }
        }
        .font(.system(size: 35))
    }
    
    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                pegView(for: code.pegs[index])
                    .overlay {
                        if code.pegs[index] == Code.missing {
                            Circle().strokeBorder(.gray)
                        }
                    }
                    .contentShape(Circle())
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            MatchMarkers(matches: code.matches)
                .overlay {
                    if code.kind == .guess {
                        guessButton
                    }
                }
        }
    }
    
    @ViewBuilder
    private func pegView(for peg: Peg) -> some View {
        if let color = Color(pegString: peg) {
            Circle().foregroundStyle(color)
        } else {
            Text(peg).font(.system(size: 40))
        }
    }
}

#Preview {
    CodeBreakerView()
}

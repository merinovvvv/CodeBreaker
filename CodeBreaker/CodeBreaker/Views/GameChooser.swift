//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 21.07.2026.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data owned by Me
    @State private var games: [CodeBreaker] = []
    
    //MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        GameType(game: game)
                    }
                    NavigationLink(value: game.masterCode.pegs) {
                        Text("Cheat")
                    }
                }
                .onDelete { offsets in
                    games.remove(atOffsets: offsets)
                }
                .onMove { offsets, destination in
                    games.move(fromOffsets: offsets, toOffset: destination)
                }
            }
            .listStyle(.plain)
            .navigationDestination(for: CodeBreaker.self) { game in
                CodeBreakerView(game: game)
            }
            .navigationDestination(for: [Peg].self) { mastercode in
                PegChooser(choices: mastercode)
            }
            .toolbar {
                EditButton()
            }
        }
        .onAppear {
            games.append(CodeBreaker(name: "Mastermind", pegsCount: 5, pegChoices: ["red", "green", "blue", "purple", "yellow"]))
            games.append(CodeBreaker(name: "Earth Theme", pegsCount: 3, pegChoices: ["brown", "yellow", "orange"]))
            games.append(CodeBreaker(name: "Undersea", pegsCount: 3, pegChoices: ["blue", "cyan", "gray"]))
        }
    }
}

#Preview {
    GameChooser()
}

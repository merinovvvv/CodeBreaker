//
//  GameList.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 21.07.2026.
//

import SwiftUI

struct GameList: View {
    // MARK: Data shared
    @Binding var selection: CodeBreaker?
    
    // MARK: Data owned by Me
    @State private var games: [CodeBreaker] = []
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameType(game: game)
                }
                .contextMenu {
                    Button("Delete", role: .destructive) {
                        withAnimation {
                            games.removeAll { $0 == game }
                        }
                    }
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
        .onChange(of: selection) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .onAppear {
            appendMockGames()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add game", systemImage: "plus.circle") {
                    withAnimation {
                        games.append(CodeBreaker(name: "Untitled", pegsCount: 2, pegChoices: ["yellow", "orange"]))
                    }
                }
            }
            ToolbarItem {
                EditButton()
            }
        }
    }
    
    private func appendMockGames() {
        if games.isEmpty {
            games.append(CodeBreaker(name: "Mastermind", pegsCount: 5, pegChoices: ["red", "green", "blue", "purple", "yellow"]))
            games.append(CodeBreaker(name: "Earth Theme", pegsCount: 3, pegChoices: ["brown", "yellow", "orange"]))
            games.append(CodeBreaker(name: "Undersea", pegsCount: 3, pegChoices: ["blue", "cyan", "gray"]))
        }
    }
}

#Preview {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}

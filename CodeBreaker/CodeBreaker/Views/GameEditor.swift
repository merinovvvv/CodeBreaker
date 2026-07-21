//
//  GameEditor.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 22.07.2026.
//

import SwiftUI

struct GameEditor: View {
    // MARK: Data In
    @Bindable var game: CodeBreaker
    
    // MARK: - Body
    
    var body: some View {
        Form {
            Section("Name") {
                TextField("Name", text: $game.name)
            }
            
            Section("Peg Choices") {
                ForEach(game.pegChoices.indices, id: \.self) { index in
                    if Color(pegString: game.pegChoices[index]) != nil {
                        ColorPicker(
                            selection: Binding(
                                get: { Color(pegString: game.pegChoices[index]) ?? .clear },
                                set: { newColor in
                                    if let newString = newColor.pegString {
                                        game.pegChoices[index] = newString
                                    }
                                }
                            ),
                            supportsOpacity: false
                        ) {
                            Text("Peg Choice №\(index + 1)")
                        }
                    } else {
                        emojiPicker(for: index)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func emojiPicker(for index: Int) -> some View {
        Picker("Peg Choice №\(index + 1)", selection: Binding(
            get: { game.pegChoices[index] },
            set: { newEmoji in
                game.pegChoices[index] = newEmoji
            }
        )) {
            ForEach(CodeBreaker.emojiChoices, id: \.self) { emoji in
                Text(emoji).tag(emoji)
            }
        }
        .pickerStyle(.menu)
    }
}

#Preview {
    @Previewable var game: CodeBreaker = CodeBreaker(name: "Preview", pegsCount: 3, pegChoices: ["red", "green", "blue"])
    GameEditor(game: game)
        .onChange(of: game.name) { oldValue, newValue in
            print("name changed from \(oldValue) to \(newValue)")
        }
        .onChange(of: game.pegChoices) { oldValue, newValue in
            print("choices changed from \(oldValue) to \(newValue)")
        }
}

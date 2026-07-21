//
//  GameType.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 21.07.2026.
//

import SwiftUI

struct GameType: View {
    // MARK: Data In
    let game: CodeBreaker
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name)
                .font(.title)
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: 50)
            Text("^[\(game.attempts.count) attempt](inflect: true)")
        }
    }
}

//#Preview {
//    GameType()
//}

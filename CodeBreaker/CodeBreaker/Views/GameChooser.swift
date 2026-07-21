//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 21.07.2026.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data owned by Me
    @State private var selection: CodeBreaker?
    
    //MARK: - Body
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            GameList(selection: $selection)
        } detail: {
            if let selection {
                CodeBreakerView(game: selection)
            } else {
                Text("Choose a game!")
            }
        }
    }
}

#Preview {
    GameChooser()
}

//
//  PegChooser.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 09.07.2026.
//

import SwiftUI

struct PegChooser: View {
    // MARK: Data In
    let choices: [Peg]
    
    // MARK: Data Out
    var onChoose: ((Peg) -> Void)?
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            ForEach(choices, id: \.self) { peg in
                Button {
                    onChoose?(peg)
                } label: {
                    PegView(peg: peg)
                }
            }
        }
    }
}

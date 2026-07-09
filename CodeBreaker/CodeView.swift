//
//  CodeView.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 09.07.2026.
//

import SwiftUI

struct CodeView: View {
    // MARK: Constants
    struct Selection {
        static let shape = Circle()
    }
    
    // MARK: Data In
    var code: Code
    
    // MARK: Data shared
    @Binding var selected: Int
    
    // MARK: - Body
    
    var body: some View {
        ForEach(code.pegs.indices, id: \.self) { index in
            PegView(peg: code.pegs[index])
                .background {
                    if selected == index, code.kind == .guess {
                        Selection.shape.foregroundStyle(.gray.opacity(0.3))
                    }
                }
                .overlay {
                    Selection.shape.foregroundStyle(code.isHidden ? .gray : .clear)
                }
                .onTapGesture {
                    if code.kind == .guess {
                        selected = index
                    }
                }
        }
    }
}

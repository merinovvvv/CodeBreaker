//
//  CodeView.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 09.07.2026.
//

import SwiftUI

// MARK: Constants
fileprivate struct Selection {
    static let shape = Circle()
}

struct CodeView<HelperView>: View where HelperView: View {
    // MARK: Data In
    var code: Code
    @ViewBuilder var helperView: () -> HelperView
    
    // MARK: Data shared
    @Binding var selected: Int
    
    // MARK: - Init
    init(
        code: Code,
        selected: Binding<Int> = .constant(-1),
        @ViewBuilder helperView: @escaping () -> HelperView = { EmptyView() }
    ) {
        self.code = code
        self._selected = selected
        self.helperView = helperView
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
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
            Circle().foregroundStyle(Color.clear)
                .overlay {
                    helperView()
                }
        }
    }
}

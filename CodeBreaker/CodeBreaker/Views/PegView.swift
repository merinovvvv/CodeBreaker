//
//  PegView.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 09.07.2026.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    
    let pegShape = Circle()
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if let color = Color(pegString: peg) {
                pegShape.foregroundStyle(color)
            } else {
                Text(peg)
                    .font(.system(size: 40))
                    .minimumScaleFactor(0.1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .contentShape(pegShape)
    }
}

#Preview {
    PegView(peg: "blue")
        .padding()
}

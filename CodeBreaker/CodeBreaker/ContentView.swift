//
//  ContentView.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 07.07.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            makePeg(with: [.red, .yellow, .green, .blue])
            makePeg(with: [.red, .red, .green, .green])
            makePeg(with: [.green, .blue, .green, .green])
            makePeg(with: [.red, .red, .green, .red])
        }
        .padding()
    }
    
    func makePeg(with colors: [Color]) -> some View {
        HStack {
            ForEach(colors.indices, id: \.self) { index in
                Circle().foregroundStyle(colors[index])
            }
            MatchMarkers(matches: [.exact, .exact, .inexact, .nomatch])
        }
    }
}

#Preview {
    ContentView()
}

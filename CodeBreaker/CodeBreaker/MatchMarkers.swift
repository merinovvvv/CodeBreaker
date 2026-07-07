//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 07.07.2026.
//

import SwiftUI

enum Match {
    case exact
    case inexact
    case nomatch
}

struct MatchMarkers: View {
    let matches: [Match]
    
    var body: some View {
        VStack {
            HStack {
                makeMatchMarker(0)
                makeMatchMarker(1)
            }
            HStack {
                makeMatchMarker(2)
                makeMatchMarker(3)
            }
        }
    }
    
    func makeMatchMarker(_ matchNumber: Int) -> some View {
        let exactMatches = matches.count(where: { $0 == .exact })
        let foundMatches = matches.count(where: { $0 != .nomatch })
        return Circle()
            .fill(exactMatches > matchNumber ? Color.primary : .clear)
            .strokeBorder(foundMatches > matchNumber ? Color.primary : .clear)
            .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    MatchMarkers(matches: [.exact, .exact, .inexact, .nomatch])
}

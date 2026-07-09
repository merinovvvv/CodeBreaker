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
    // MARK: Data In
    let matches: [Match]
    
    private var rows: [[Int]] {
        switch matches.count {
        case 3: return [[0, 1], [2]]
        case 4: return [[0, 1], [2, 3]]
        case 5: return [[0, 1, 2], [3, 4]]
        case 6: return [[0, 1, 2], [3, 4, 5]]
        default: return [[0, 1], [2, 3]]
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            ForEach(0..<rows.count, id: \.self) { rowIndex in
                HStack {
                    ForEach(rows[rowIndex], id: \.self) { index in
                        makeMatchMarker(index)
                    }
                }
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
    VStack {
        HStack {
            Circle().fill()
            Circle().fill()
            Circle().fill()
            Circle().fill()
            Circle().fill()
            MatchMarkers(matches: [.exact, .exact, .inexact])
        }
        HStack {
            Circle().fill()
            Circle().fill()
            Circle().fill()
            MatchMarkers(matches: [.exact, .exact, .inexact, .nomatch])
        }
        HStack {
            Circle().fill()
            Circle().fill()
            Circle().fill()
            Circle().fill()
            Circle().fill()
            Circle().fill()
            Circle().fill()
            MatchMarkers(matches: [.exact, .exact, .inexact, .exact, .exact, .exact])
        }
        HStack {
            Circle().fill()
            Circle().fill()
            Circle().fill()
            Circle().fill()
            MatchMarkers(matches: [.exact, .inexact, .inexact])
        }
    }.padding()
}

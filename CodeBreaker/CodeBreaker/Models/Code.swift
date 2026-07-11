//
//  Code.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 09.07.2026.
//


import Foundation

struct Code: Equatable {
    enum Kind: Equatable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])
        case unknown
    }
    
    // MARK: Data In
    var kind: Kind
    var pegs: [Peg]
    
    var isHidden: Bool {
        switch kind {
        case .master(let isHidden): return isHidden
        default: return false
        }
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
        }
    }
    
    init(kind: Kind, pegsCount: Int) {
        self.kind = kind
        self.pegs = Array(repeating: Peg.missing, count: pegsCount)
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Peg.missing
        }
    }
    
    mutating func reset() {
        pegs = Array(repeating: Peg.missing, count: pegs.count)
    }
    
    func match(against otherCode: Code) -> [Match] {
        var result: [Match] = Array(repeating: .nomatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
        
        for index in pegsToMatch.indices.reversed() {
            if index < pegsToMatch.count, pegs[index] == pegsToMatch[index] {
                result[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        
        for index in pegs.indices {
            if result[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    result[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }
        
        return result
    }
}

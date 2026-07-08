//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 08.07.2026.
//

import SwiftUI

typealias Peg = Color

struct CodeBreaker {
    var masterCode: Code = Code(kind: .master)
    var guess: Code = Code(kind: .guess)
    var attempts: [Code] = []
    let pegChoices: [Peg]
    
    init(pegChoices: [Peg] = [.red, .green, .yellow, .blue]) {
        self.pegChoices = pegChoices
        masterCode.randomize(from: pegChoices)
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPegIndex = (indexOfExistingPegInPegChoices + 1) % pegChoices.count
            let newPeg = pegChoices[newPegIndex]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
    
    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
    }
}

struct Code {
    var kind: Kind
    var pegs: [Peg] = Array(repeating: Code.missing, count: 4)
    
    var matches: [Match] {
        switch kind {
        case .attempt(let matches): return matches
        default: return []
        }
    }
    
    static let missing: Peg = .clear
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missing
        }
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

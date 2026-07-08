//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Yaraslau Merynau on 08.07.2026.
//

import Foundation

typealias Peg = String

extension Peg {
    static let missing = "clear"
}

struct CodeBreaker {
    static let colorChoices: [Peg] = ["red", "green", "yellow", "blue", "purple", "orange", "pink", "brown"]
    static let emojiChoices: [Peg] = ["🍏", "🤓", "❤️", "😎", "👽", "🤡"]
    let pegsCount: Int
    let pegChoices: [Peg]
    
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    var isActive: Bool { !attempts.contains(guess) && guess.pegs.allSatisfy({$0 != Peg.missing}) }
    
    init(pegsCount: Int, pegChoices: [Peg] = ["red", "green", "yellow", "blue"]) {
        self.pegsCount = pegsCount
        self.pegChoices = pegChoices
        self.masterCode = Code(kind: .master, pegsCount: pegsCount)
        self.guess = Code(kind: .guess, pegsCount: pegsCount)
        masterCode.randomize(from: pegChoices)
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPegIndex = (indexOfExistingPegInPegChoices + 1) % pegChoices.count
            let newPeg = pegChoices[newPegIndex]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Peg.missing
        }
    }
    
    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        guard isActive else { return }
        attempts.append(attempt)
    }
    
    mutating func restart() {
        let newPegsCount = [3, 4, 5, 6].randomElement() ?? 4
        let newPegChoices = [CodeBreaker.colorChoices, CodeBreaker.emojiChoices].randomElement() ?? CodeBreaker.colorChoices
        self = CodeBreaker(pegsCount: newPegsCount, pegChoices: newPegChoices)
    }
}

struct Code: Equatable {
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    var kind: Kind
    var pegs: [Peg]
    
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

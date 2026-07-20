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
    
    //MARK: - Data In
    
    let pegsCount: Int
    let pegChoices: [Peg]
    
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    var isActive: Bool { !attempts.contains(guess) && guess.pegs.allSatisfy({$0 != Peg.missing}) }
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    var startDate: Date = .now
    var endDate: Date?
    
    init(pegsCount: Int, pegChoices: [Peg] = ["red", "green", "yellow", "blue"]) {
        self.pegsCount = pegsCount
        self.pegChoices = pegChoices
        self.masterCode = Code(kind: .master(isHidden: true), pegsCount: pegsCount)
        self.guess = Code(kind: .guess, pegsCount: pegsCount)
        masterCode.randomize(from: pegChoices)
        print(masterCode.pegs)
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
        guess.reset()
        if isOver {
            masterCode.kind = .master(isHidden: false)
            endDate = .now
        }
    }
    
    mutating func restart() {
        let newPegsCount = [3, 4, 5, 6].randomElement() ?? 4
        let newPegChoices = [CodeBreaker.colorChoices, CodeBreaker.emojiChoices].randomElement() ?? CodeBreaker.colorChoices
        startDate = .now
        endDate = nil
        self = CodeBreaker(pegsCount: newPegsCount, pegChoices: newPegChoices)
    }
    
    mutating func changeSelectedGuess(_ peg: Peg, at selected: Int) {
        guard guess.pegs.indices.contains(selected) else { return }
        guess.pegs[selected] = peg
    }
}

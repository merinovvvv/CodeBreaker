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

@Observable class CodeBreaker {
    static let colorChoices: [Peg] = ["red", "green", "yellow", "blue", "purple", "orange", "pink", "brown"]
    static let emojiChoices: [Peg] = ["🍏", "🤓", "❤️", "😎", "👽", "🤡"]
    
    //MARK: - Data In
    
    var pegsCount: Int
    var pegChoices: [Peg]
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    var isActive: Bool { !attempts.contains(guess) && guess.pegs.allSatisfy({$0 != Peg.missing}) }
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    var startDate: Date = .now
    var endDate: Date?
    
    var name: String
    
    init(name: String = "CodeBreaker", pegsCount: Int, pegChoices: [Peg] = ["red", "green", "yellow", "blue"]) {
        self.name = name
        self.pegsCount = pegsCount
        self.pegChoices = pegChoices
        self.masterCode = Code(kind: .master(isHidden: true), pegsCount: pegsCount)
        self.guess = Code(kind: .guess, pegsCount: pegsCount)
        masterCode.randomize(from: pegChoices)
        print(masterCode.pegs)
    }
    
    func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPegIndex = (indexOfExistingPegInPegChoices + 1) % pegChoices.count
            let newPeg = pegChoices[newPegIndex]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Peg.missing
        }
    }
    
    func attemptGuess() {
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
    
    func restart() {
        pegsCount = [3, 4, 5, 6].randomElement() ?? 4
        pegChoices = [CodeBreaker.colorChoices, CodeBreaker.emojiChoices].randomElement() ?? CodeBreaker.colorChoices
        masterCode = Code(kind: .master(isHidden: true), pegsCount: pegsCount)
        guess = Code(kind: .guess, pegsCount: pegsCount)
        attempts = []
        masterCode.randomize(from: pegChoices)
        startDate = .now
        endDate = nil
    }
    
    func changeSelectedGuess(_ peg: Peg, at selected: Int) {
        guard guess.pegs.indices.contains(selected) else { return }
        guess.pegs[selected] = peg
    }
}

extension CodeBreaker: Identifiable, Hashable, Equatable {
    static func ==(lhs: CodeBreaker, rhs: CodeBreaker) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

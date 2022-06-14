//
//  SolverY2017D4.swift
//  aoc
//
//  Created by Leif Walker-Grant on 11/11/2020.
//

import Foundation

class SolverY2017D4 : Solvable {
    static var description = "High-Entropy Passphrases"

    let passphrases: [[String]]

    required init(withLog log: Log, andInput input: String) {
        passphrases = input.components(separatedBy: .newlines).compactMap { s in
            s.components(separatedBy: .whitespaces)
        }
    }

    func doPart1(withLog log: Log) {
        let count = passphrases.filter { a in
            a.count == Set(a).count
        }.count

        log.solution(theMessage: "The number of valid passphrases is \(count).")
    }

    func doPart2(withLog log: Log) {
        let count = passphrases.filter { a in
            let b = a.compactMap { s in s.sorted() }
            return b.count == Set(b).count
        }.count

        log.solution(theMessage: "Under the new system, \(count) passwords are valid.")
    }
}

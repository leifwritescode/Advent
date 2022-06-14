//
//  SolverY2015D8.swift
//  aoc
//
//  Created by Leif Walker-Grant on 24/10/2020.
//

import Foundation

class SolverY2015D8 : Solvable {
    private let literals: [String]

    required init(withLog log: Log, andInput input: String) {
        literals = input.components(separatedBy: .newlines)
    }

    func doPart1(withLog log: Log) {
        _ = timed(toLog: log) {
            let sumCode = literals.compactMap { s in s.count }.reduce(0, +)
            let sumCharacters = literals.compactMap { s in
                var count: Int?
                if let groups: [String] = try? s.groups(for: #"(\\"|\\x[0-9a-f]{2}|\\\\|\w)"#) {
                    count = groups.count
                }
                return count
            }.reduce(0, +)
            log.solution(theMessage: "The sum of the literal lengths minus the actual lengths is \(sumCode) - \(sumCharacters) = \(sumCode - sumCharacters).")
        }
    }

    func doPart2(withLog log: Log) {
        _ = timed(toLog: log) {
            let sumCode = literals.compactMap { s in s.count }.reduce(0, +)
            let sumEscaped = literals.compactMap { s in
                let s2 = "\"" + s.replacingOccurrences(of: #"\"#, with: #"\\"#).replacingOccurrences(of: "\"", with: #"\""#) + "\""
                return s2.count
            }.reduce(0, +)
            log.solution(theMessage: "The sum of the reencoded lengths minus the literal lengths is \(sumEscaped) - \(sumCode) = \(sumEscaped - sumCode).")
        }
    }
}

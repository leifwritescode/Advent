//
//  SolverY2020D6.swift
//  aoc
//
//  Created by Leif Walker-Grant on 06/12/2020.
//

import Foundation

class SolverY2020D6 : Solvable {
    static var description = "Todo."

    let forms: [Array<String>.SubSequence]

    required init(withLog log: Log, andInput input: String) {
        forms = input.components(separatedBy: .newlines)
            .split(separator: "")
    }

    func doPart1(withLog log: Log) {
        let result = forms.compactMap { f in Set(f.joined()).count }.reduce(0, +)
        log.solution(theMessage: "The number of questions to which anyone answered yes (cumulatively) is \(result).")
    }

    func doPart2(withLog log: Log) {
        let result = forms.compactMap { g in
            g.reduce(Set(g.joined())) { r, e in
                r.intersection(Set(e))
            }.count
        }.reduce(0, +)
        log.solution(theMessage: "The number of questions to which everyone answered yes (cumulatively) is \(result).")
    }
}

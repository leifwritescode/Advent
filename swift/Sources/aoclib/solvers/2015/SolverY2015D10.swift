//
//  SolverY2015D10.swift
//  aoc
//
//  Created by Leif Walker-Grant on 25/10/2020.
//

import Foundation

class SolverY2015D10 : Solvable {
    static var description = "Elves Look, Elves Say"

    private let initial: String
    private let rounds = 40

    required init(withLog log: Log, andInput input: String) {
        initial = input
    }

    func lookAndSay(initial: String, rounds: Int, log: Log) -> String {
        var scratch = initial
        for i in 1...rounds {
            var temp: String = ""
            for s in scratch.splitOnNewCharacter() {
                temp += "\(s.count)\(s.first!)"
            }
            scratch = temp
            log.debug(theMessage: "End of round \(i).")
        }
        return scratch
    }

    func doPart1(withLog log: Log) {
        let result = lookAndSay(initial: initial, rounds: 40, log: log)
        log.solution(theMessage: "The length of the result after 40 rounds is \(result.count).")
    }

    func doPart2(withLog log: Log) {
        let result = lookAndSay(initial: initial, rounds: 50, log: log)
        log.solution(theMessage: "The length of the result after 50 rounds is \(result.count).")
    }
}

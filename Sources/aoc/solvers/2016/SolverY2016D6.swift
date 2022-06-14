//
//  SolverY2016D6.swift
//  aoc
//
//  Created by Leif Walker-Grant on 29/10/2020.
//

import Foundation

class SolverY2016D6 : Solvable {
    static var description = "Signals and Noise"

    let signals: [[String]]

    required init(withLog log: Log, andInput input: String) {
        let temp = input.components(separatedBy: .newlines)
            .compactMap { s in
                s.map { c in
                    String(c)
                }
            }
        signals = transpose2d(array: temp, width: temp[0].count, height: temp.count)
    }

    func doPart1(withLog log: Log) {
        let ecMessage = signals.compactMap { line in
            let next = line.compactMap { s in s  }
                .sorted()
                .joined()
                .splitOnNewCharacter()
                .sorted { a, b in
                    a.count > b.count
                }
                .first!
                .first!
            return String(next)
        }.joined()

        log.solution(theMessage: "The error-corrected SRC message is '\(ecMessage).'")
    }

    func doPart2(withLog log: Log) {
        let ecMessage = signals.compactMap { line in
            let next = line.compactMap { s in s  }
                .sorted()
                .joined()
                .splitOnNewCharacter()
                .sorted { a, b in
                    a.count > b.count
                }
                .last!
                .first!
            return String(next)
        }.joined()

        log.solution(theMessage: "The error-corrected MRC message is '\(ecMessage).'")
        
    }
}

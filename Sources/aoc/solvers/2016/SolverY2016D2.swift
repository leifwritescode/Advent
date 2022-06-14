//
//  SolverY2016D2.swift
//  aoc
//
//  Created by Leif Walker-Grant on 25/10/2020.
//

import Foundation

class SolverY2016D2 : Solvable {
    let moves: [[Int]]

    required init(withLog log: Log, andInput input: String) {
        // We translate each move into a lookup friendly format.
        let cToI = ["U": 0, "R": 1, "D": 2, "L": 3]
        moves = input.components(separatedBy: .newlines).compactMap { l in
            l.compactMap { c in cToI[String(c)] }
        }
    }

    func calculateCode(_ log: Log, _ kToD: [Int:[Int]]) -> String {
        var code = Array(repeating: 5, count: moves.count + 1)
        for n in 0..<moves.count {
            log.info(theMessage: "Calculating position \(n + 1).")
            var next = code[n]
            for m in moves[n] {
                let cand = kToD[next]!
                let temp = cand[m]
                log.debug(theMessage: "\(next) -> \(temp).")
                next = temp
            }
            code[n + 1] = next
        }
        return code.dropFirst().compactMap { i in String(format: "%01X", i) }.joined()
    }

    func doPart1(withLog log: Log) {
        let kToD = [
            1: [1, 2, 4, 1],
            2: [2, 3, 5, 1],
            3: [3, 3, 6, 2],
            4: [1, 5, 7, 4],
            5: [2, 6, 8, 4],
            6: [3, 6, 9, 5],
            7: [4, 8, 7, 7],
            8: [5, 9, 8, 7],
            9: [6, 9, 9, 8]
        ]

        _ = timed(toLog: log) {
            let code = calculateCode(log, kToD)
            log.solution(theMessage: "The bathroom code is \(code).")
        }
    }

    func doPart2(withLog log: Log) {
        let kToD = [
            1: [1, 1, 3, 1],
            2: [2, 3, 6, 2],
            3: [1, 4, 7, 2],
            4: [4, 4, 8, 3],
            5: [5, 6, 5, 5],
            6: [2, 7, 10, 5],
            7: [3, 8, 11, 6],
            8: [4, 9, 12, 7],
            9: [9, 9, 9, 8],
            10: [6, 11, 10, 10],
            11: [7, 12, 13, 11],
            12: [8, 12, 12, 11],
            13: [11, 13, 13, 13]
        ]

        _ = timed(toLog: log) {
            let code = calculateCode(log, kToD)
            log.solution(theMessage: "The bathroom code is, actually, \(code).")
        }
    }
}

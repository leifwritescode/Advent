//
//  SolverY2016D3.swift
//  aoc
//
//  Created by Leif Walker-Grant on 28/10/2020.
//

import Foundation

class SolverY2016D3 : Solvable {
    private let sides: [Int]

    required init(withLog log: Log, andInput input: String) {
        sides = input.components(separatedBy: .whitespacesAndNewlines)
            .filter { e in !e.isEmpty }
            .compactMap { s in Int(s) }
    }

    func isValidTriangle(_ a: Int, _ b: Int, _ c: Int) -> Bool {
        return a + b > c && c + a > b && b + c > a
    }

    func doPart1(withLog log: Log) {
        _ = timed(toLog: log) {
            var valid = 0
            for v in stride(from: 0, to: sides.count, by: 3) {
                if (isValidTriangle(sides[v], sides[v+1], sides[v+2])) {
                    valid += 1
                }
            }
            log.solution(theMessage: "Exactly \(valid) triangles are valid.")
        }
    }

    func doPart2(withLog log: Log) {
        _ = timed(toLog: log) {
            let w = 3
            let h = sides.count / w
            var valid = 0
            for c in stride(from: 0, through: w - 1, by: 1) {
                for r in stride(from: 0, through: h - 1, by: 3) {
                    if (isValidTriangle(sides[r * w + c],
                                        sides[(r + 1) * w + c],
                                        sides[(r + 2) * w + c])) {
                        valid += 1
                    }
                }
            }

            log.solution(theMessage: "Exactly \(valid) triangles are valid.")
        }
    }
}

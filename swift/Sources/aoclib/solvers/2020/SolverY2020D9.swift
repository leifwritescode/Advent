//
//  SolverY2020D9.swift
//  aoclib
//
//  Created by Leif Walker-Grant on 09/12/2020.
//

import Foundation

class SolverY2020D9 : Solvable {
    static var description = "Encoding Error"

    var target = -1
    let pLen = 25
    let xmas: [Int]

    required init(withLog log: Log, andInput input: String) {
        xmas = input.components(separatedBy: .newlines).compactMap { s in Int(s)! }
    }

    func doPart1(withLog log: Log) {
        target = xmas.enumerated().dropFirst(pLen).first { e in
            let tRange = xmas[(e.offset - pLen)..<e.offset]
            return tRange.first { j in tRange.contains(e.element - j) && j != e.element - j } == nil
        }?.element ?? -1
        log.solution(theMessage: "The weak data point is \(target).")
    }

    func doPart2(withLog log: Log) {
        if target == -1 {
            log.error(theMessage: "Part 1 failed to yield a solution. Unable to continue.")
        }

        var kill = false
        DispatchQueue.concurrentPerform(iterations: xmas.count) { start in
            if kill {
                return
            }

            var result = 0
            var end = start
            while result < target && end < xmas.count {
                result += xmas[end]
                end += 1
            }

            if result == target {
                kill = true
                let range = xmas[start..<end]
                log.solution(theMessage: "The sum of weak extremes is \(range.min()! + range.max()!).")
            }
        }
    }
}

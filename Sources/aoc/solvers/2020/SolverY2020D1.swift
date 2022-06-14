//
//  SolverY2020D1.swift
//  aoc
//
//  Created by Leif Walker-Grant on 01/12/2020.
//

import Foundation

class SolverY2020D1 : Solvable {
    static var description = "Todo."

    let target = 2020
    let expenses: [Int]

    required init(withLog log: Log, andInput input: String) {
        expenses = input.components(separatedBy: .newlines).compactMap { Int($0)! }
    }

    func doPart1(withLog log: Log) {
        // This could also be achieved with a pair of indexes (which would use less memory) but this way is more verbose.
        var temp = expenses.sorted()
        while (temp.first! + temp.last! != target) {
            if temp.first! + temp.last! > target {
                temp.removeLast()
            } else {
                temp.removeFirst()
            }
        }
        log.solution(theMessage: "The product of the two numbers that sum to 2020 is \(temp.first! * temp.last!).")
    }

    func doPart2(withLog log: Log) {
        // We know that we can reliably exclude all values greater than 1k
        let temp = expenses.filter { $0 < 1000 }
        // Beyond that nugget, however, we'll just brute force it.
        var result: Int? = nil
        loop: for a in 0..<temp.count {
            for b in (a + 1)..<temp.count {
                for c in (b + 1)..<temp.count {
                    let ea = temp[a],
                        eb = temp[b],
                        ec = temp[c]
                    if (ea + eb + ec == target) {
                        result = ea * eb * ec
                        break loop
                    }
                }
            }
        }
        log.solution(theMessage: "The product of the three numbers that sum to 2020 is \(result!).")
    }
}

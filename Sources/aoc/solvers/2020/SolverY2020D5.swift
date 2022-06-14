//
//  SolverY2020D5.swift
//  aoc
//
//  Created by Leif Walker-Grant on 05/12/2020.
//

import Foundation

class SolverY2020D5 : Solvable {
    static var description = "Binary Boarding"

    let passes: [Int]

    required init(withLog log: Log, andInput input: String) {
        passes = input.components(separatedBy: .newlines).compactMap { pass in
            let str = pass.replacingOccurrences(of: "F", with: "0")
                .replacingOccurrences(of: "L", with: "0")
                .replacingOccurrences(of: "B", with: "1")
                .replacingOccurrences(of: "R", with: "1")
            return Int(str, radix: 2)!
        }
    }

    func doPart1(withLog log: Log) {
        log.solution(theMessage: "The highest seat ID on a boarding pass is \(passes.max() ?? -1).")
    }

    func doPart2(withLog log: Log) {
        let mySeat = Set(stride(from: passes.min()!, to: passes.max()!, by: 1)).subtracting(Set(passes))
        log.solution(theMessage: "The ID of my seat is \(mySeat).")
    }
}

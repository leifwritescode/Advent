//
//  SolverY2020D15.swift
//  aoclib
//
//  Created by Leif Walker-Grant on 15/12/2020.
//

import Foundation

class SolverY2020D15 : Solvable {
    static var description = "Rambunctious Recitation"

    let initial: [Int]

    required init(withLog log: Log, andInput input: String) {
        initial = input.components(separatedBy: ",")
            .compactMap { i in Int(i)! }
    }

    func recite(_ till: Int, _ log: Log) -> Int {
        var state = initial
        for _ in initial.count..<till {
            if let prev = state.dropLast().lastIndex(of: state.last!) {
                state.append(state.count - (prev + 1))
            } else {
                state.append(0)
            }
        }
        return state.last!
    }

    func doPart1(withLog log: Log) {
        log.solution(theMessage: "The 2020th number in the sequence is \(recite(2020, log)).")
    }

    func doPart2(withLog log: Log) {
        log.solution(theMessage: "The 30 millionth term is \(recite(30000000, log)).")
    }
}

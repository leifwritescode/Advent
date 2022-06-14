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

    func recite2(_ till: Int, _ log: Log) -> Int {
        // set up a dictionary of each value (the key) and the last time it was seen (value)
        var map = [Int:Int]()
        initial.enumerated().forEach { e in map[e.element] = e.offset + 1 }
        // get the first test value
        var next = map.key(forValue: initial.count)!
        // loop until we've computed the final case
        for term in initial.count..<till {
            // get the delta between now and the last time we saw next, or 0 if we haven't
            let delta = term - map[next, default: term]
            // the last time we saw next is in this cycle
            // this looks counterintuitive, but keep in mind that the sequence is 1-indexed.
            map[next] = term
            // delta is now the last value we saw
            next = delta
        }
        // the final value of next is our solution
        return next
    }

    func doPart1(withLog log: Log) {
        log.solution(theMessage: "The 2020th number in the sequence is \(recite(2020, log)).")
    }

    func doPart2(withLog log: Log) {
        log.solution(theMessage: "The 30 millionth term is \(recite2(30000000, log)).")
    }
}

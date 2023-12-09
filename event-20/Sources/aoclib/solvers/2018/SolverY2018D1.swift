//
//  SolverY2018D1.swift
//  aoc
//
//  Created by Leif Walker-Grant on 11/11/2020.
//

import Foundation

class SolverY2018D1 : Solvable {
    static var description = "Chronal Calibration"

    let changes: [Int]

    required init(withLog log: Log, andInput input: String) {
        changes = input.components(separatedBy: .newlines).compactMap { s in
            Int(s)!
        }
    }

    func doPart1(withLog log: Log) {
        let res = changes.reduce(0, +)
        log.solution(theMessage: "The frequency of the device is \(res).")
    }

    func doPart2(withLog log: Log) {
        var currDrift = 0
        var prevDrifts = Set<Int>()
        var iter = changes.makeIterator()
        var nextDelta: Int?

        while (!prevDrifts.contains(currDrift)) {
            prevDrifts.insert(currDrift)

            nextDelta = iter.next()
            if (nextDelta == nil) {
                iter = changes.makeIterator()
                nextDelta = iter.next()
            }

            currDrift += nextDelta!
        }
        
        log.solution(theMessage: "The frequency first reached twice is \(currDrift).")
    }
}

//
//  SolverY2020D13.swift
//  aoclib
//
//  Created by Leif Walker-Grant on 13/12/2020.
//

import Foundation
import BigInt

class SolverY2020D13 : Solvable {
    static var description = "Shuttle Search"

    let timestamp: Int
    let bustimes: [(Int,Int)]

    required init(withLog log: Log, andInput input: String) {
        let lines = input.components(separatedBy: .newlines)
        timestamp = Int(lines.first!)!
        bustimes = lines.last!
            .components(separatedBy: ",")
            .enumerated()
            .reduce([(Int,Int)]()) { d, i in
                if i.element == "x" {
                    return d
                }

                let e = Int(i.element)!
                return d + [(e, (e - i.offset) % e)]
            }
    }

    func doPart1(withLog log: Log) {
        let next = bustimes.reduce([Int: Int]()) { dict, elem in
            var dict = dict
            dict[elem.0] = elem.0 - (timestamp % elem.0)
            return dict
        }.sorted { a, b in
            a.value < b.value
        }.first!
        log.solution(theMessage: "The id of the bus multiplied by the wait is \(next.key * next.value).")
    }

    func doPart2(withLog log: Log) {
        var i = 0
        var k = BigInt(bustimes[i].0)
        var inc = k
        loop: while true {
            let div = BigInt(bustimes[i + 1].0)
            let mod = BigInt(bustimes[i + 1].1)
            if k % div == mod {
                if i == bustimes.count - 2 {
                    break loop
                }
                inc *= div
                i += 1
            }
            k += inc
        }
        log.solution(theMessage: "The earliest timestamp at which buses leave uniformly is \(k).")
    }
}

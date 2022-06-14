//
//  SolverY2017D2.swift
//  aoc
//
//  Created by Leif Walker-Grant on 11/11/2020.
//

import Foundation

class SolverY2017D2 : Solvable {
    let cells: [[Int]]

    required init(withLog log: Log, andInput input: String) {
        cells = input.components(separatedBy: .newlines)
            .compactMap { s in
                s.components(separatedBy: .whitespaces).compactMap { i in
                    Int(i)
                }
        }
    }

    func doPart1(withLog log: Log) {
        _ = timed(toLog: log) {
            var checksum = 0
            cells.forEach { array in
                log.debug(theMessage: "\(array)")
                let sorted = array.sorted()
                checksum += sorted.max()! - sorted.min()!
            }

            log.solution(theMessage: "The spreadsheet checksum is \(checksum).")
        }
    }

    func doPart2(withLog log: Log) {
        _ = timed(toLog: log) {
            var checksum = 0
            cells.forEach { array in
                let sorted = array.sorted()
                let enumerated = sorted.enumerated()
                short_circuit: for (i, n) in enumerated {
                    for (j, m) in enumerated {
                        if i != j && n % m == 0 {
                            checksum += n / m
                            break short_circuit
                        }
                    }
                }
            }

            log.solution(theMessage: "The sum of each row's result is \(checksum)")
        }
    }
}

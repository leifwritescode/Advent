//
//  SolverY2020D5.swift
//  aoc
//
//  Created by Leif Walker-Grant on 05/12/2020.
//

import Foundation

class SolverY2020D5 : Solvable {
    static var description = "Binary Boarding"

    let passes: [String]

    required init(withLog log: Log, andInput input: String) {
        passes = input.components(separatedBy: .newlines)
    }

    func boardingPassToBase2(_ log: Log, _ pass: String) -> Int {
        let str = pass.replacingOccurrences(of: "F", with: "0")
            .replacingOccurrences(of: "L", with: "0")
            .replacingOccurrences(of: "B", with: "1")
            .replacingOccurrences(of: "R", with: "1")
        return Int(str, radix: 2)!
    }

    func doPart1(withLog log: Log) {
        let maximum = passes.compactMap { pass -> Int in
            (boardingPassToBase2(log, String(pass.dropLast(3))) << 3) + boardingPassToBase2(log, String(pass.dropFirst(7)))
        }.max()
        log.solution(theMessage: "The highest seat ID on a boarding pass is \(maximum ?? -1).")
    }

    func doPart2(withLog log: Log) {
        let seats = passes.compactMap { pass in
            (boardingPassToBase2(log, String(pass.dropLast(3))) << 3) + boardingPassToBase2(log, String(pass.dropFirst(7)))
        }

        let mySeat = Set(stride(from: 0, to: seats.max()!, by: 1)).subtracting(Set(seats)).max()!
        log.solution(theMessage: "The ID of my seat is \(mySeat).")
    }
}

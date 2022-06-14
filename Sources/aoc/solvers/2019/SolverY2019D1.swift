//
//  SolverY2019D1.swift
//  aoc
//
//  Created by Leif Walker-Grant on 18/10/2020.
//

import Foundation

class SolverY2019D1 : Solvable {
    static var description = "The Tyranny of the Rocket Equation"

    var masses: [Int] = Array()
    
    required init (withLog log: Log, andInput input: String) {
        input.components(separatedBy: .newlines).forEach {
            masses.append(Int($0) ?? 0)
        }
    }

    private func simpleFuelFor(mass m: Int) -> Int {
        return max(0, m / 3 - 2)
    }

    private func recursiveFuelFor(mass m: Int) -> Int {
        let rm = simpleFuelFor(mass: m)
        return rm > 0 ? rm + recursiveFuelFor(mass: rm) : rm
    }

    func doPart1(withLog log: Log) -> Void {
        var totalFuel = 0
        masses.forEach {
            totalFuel += simpleFuelFor(mass: $0)
            log.debug(theMessage: "Interim mass is \(totalFuel).")
        }
        log.solution(theMessage: "The sum of the fuel requirements for all modules is \(totalFuel) units.")
    }

    func doPart2(withLog log: Log) -> Void {
        var totalFuel = 0
        masses.forEach {
            totalFuel += recursiveFuelFor(mass: $0)
            log.debug(theMessage: "Interim mass is \(totalFuel).")
        }
        log.solution(theMessage: "The sum of the fuel requirements, accounting for fuel mass, is \(totalFuel) units.")
    }
}

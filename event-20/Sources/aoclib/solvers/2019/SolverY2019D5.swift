//
//  SolverY2019D5.swift
//  aoc
//
//  Created by Leif Walker-Grant on 13/11/2020.
//

import Foundation

class SolverY2019D5 : Solvable {
    static var description = "Sunny with a Chance of Asteroids"

    let program: [Int]

    required init(withLog log: Log, andInput input: String) {
        program = input.split(separator: ",").compactMap { i in Int(i)! }
    }

    func runDiagnostic(_ log: Log, _ sub: Int) {
        let vm = IntcodeVM(log: log, program: program)

        var diags = [Int]()
        vm.push(sub)
        loop: repeat {
            do {
                try vm.run()
                break loop
            } catch IntcodeStatus.ioInterruptWrite {
                if let diag = try? vm.pop() {
                    diags.append(diag)
                }
            } catch let error {
                log.error(theMessage: "\(error)")
                break loop
            }
        } while true

        log.solution(theMessage: "The value at position zero is \(diags.last!)")
    }

    func doPart1(withLog log: Log) {
        runDiagnostic(log, 1)
    }

    func doPart2(withLog log: Log) {
        runDiagnostic(log, 5)
    }
}

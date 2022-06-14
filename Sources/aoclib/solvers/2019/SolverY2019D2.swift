//
//  SolverY2019D2.swift
//  aoc
//
//  Created by Leif Walker-Grant on 12/11/2020.
//

import Foundation

class SolverY2019D2 : Solvable {
    static var description = "1202 Program Alarm"

    let program: [Int]

    required init(withLog log: Log, andInput input: String) {
        program = input.split(separator: ",").compactMap { i in Int(i)! }
    }

    func doPart1(withLog log: Log) {
        let vm = IntcodeVM(log: log, program: program)
        do {
            vm.memset(1, 12)
            vm.memset(2, 2)
            let solution = try vm.run()
            log.solution(theMessage: "The value at position zero is \(solution)")
        } catch let error {
            log.error(theMessage: "The vm crashed with error: '\(error).'")
        }
    }

    func doPart2(withLog log: Log) {
        var solution = 0
        let target = 19690720
        let stride = 99

        DispatchQueue.concurrentPerform(iterations: stride * stride) { i in
            if solution != 0 {
                return
            }

            let noun = i % stride
            let verb = i / stride
            log.debug(theMessage: "Testing noun=\(noun), verb=\(verb)")

            let vm = IntcodeVM(log: log, program: program)
            do {
                vm.memset(1, noun)
                vm.memset(2, verb)
                let output = try vm.run()
                if output == target {
                    solution = i
                }
            } catch let error {
                log.error(theMessage: "VM #\(i+1) crashed with error: '\(error).'")
            }
        }

        log.solution(theMessage: "The result of 100 * noun + verb is \(100 * (solution % stride) + (solution / stride)).")
    }
}

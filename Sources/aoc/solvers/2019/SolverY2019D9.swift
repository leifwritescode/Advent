//
//  SolverY2019D9.swift
//  aoc
//
//  Created by Leif Walker-Grant on 14/11/2020.
//

import Foundation

class SolverY2019D9 : Solvable {
    static var description = "Sensor Boost"

    let program: [Int]

    required init(withLog log: Log, andInput input: String) {
        program = input.split(separator: ",").compactMap { i in Int(i)! }
    }

    func runProgram(_ log: Log, _ mode: Int) -> [Int] {
        let vm = IntcodeVM(log: log, program: program)
        
        var outputs = [Int]()
        loop: while (true) {
            do {
                try vm.run()
                break loop
            } catch IntcodeStatus.ioInterruptRead {
                vm.push(mode)
            } catch IntcodeStatus.ioInterruptWrite {
                if let code = try? vm.pop() {
                    outputs.append(code)
                }
            } catch let error {
                log.error(theMessage: "\(error)")
                break loop
            }
        }

        return outputs
    }

    func doPart1(withLog log: Log) {
        let codes = runProgram(log, 1)
        if codes.count > 1 {
            for code in codes.dropLast() {
                log.error(theMessage: "BOOST: Instruction \(code) failed.")
            }
        } else {
            log.solution(theMessage: "The BOOST keycode is \(codes.first!).")
        }
    }

    func doPart2(withLog log: Log) {
        let coords = runProgram(log, 2)
        log.solution(theMessage: "The coords are \(coords.first!).")
    }
}

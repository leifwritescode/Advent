//
//  SolverY2019D13.swift
//  aoc
//
//  Created by Leif Walker-Grant on 14/11/2020.
//

import Foundation

class SolverY2019D13 : Solvable {
    static var description = "Care Package"

    let program: [Int]

    required init(withLog log: Log, andInput input: String) {
        program = input.split(separator: ",").compactMap { i in Int(i)! }
    }

    func doPart1(withLog log: Log) {
        let vm = IntcodeVM(log: log, program: program)

        var outputs = [Int]()
        loop: while (true) {
            do {
                try vm.run()
                break loop
            } catch IntcodeStatus.ioInterruptWrite {
                if let code = try? vm.pop() {
                    outputs.append(code)
                }
            } catch let error {
                log.error(theMessage: "\(error)")
                break loop
            }
        }

        var dict = [Vector2:Int]()
        for i in stride(from: 0, to: outputs.count, by: 3) {
            let x = Float(outputs[i]),
                y = Float(outputs[i + 1])
            let state = outputs[i + 2]

            let v = Vector2(x: x, y: y)
            dict[v] = state
        }

        log.solution(theMessage: "The number of blocks on screen is \(dict.values.filter { v in v == 2 }.count).")
    }

    func doPart2(withLog log: Log) {
        let vm = IntcodeVM(log: log, program: program)
        vm.memset(0, 2)

        var outputs = [Int]()
        var blocks = 239, score = 0, padX = 0, ballX = 0
        loop: while (true) {
            do {
                try vm.run()
                break loop
            } catch IntcodeStatus.ioInterruptRead {
                let joyTilt = padX > ballX ? -1 : padX < ballX ? 1 : 0
                vm.push(joyTilt)
            } catch IntcodeStatus.ioInterruptWrite {
                if let code = try? vm.pop() {
                    outputs.append(code)
                }

                if outputs.count == 3 {
                    let x = outputs.removeFirst(),
                        y = outputs.removeFirst(),
                        t = outputs.removeFirst()

                    if x == -1 && y == 0 && t != 0 {
                        score = t
                        blocks -= 1
                        log.info(theMessage: "Block hit! Score \(score). \(blocks) Blocks remain.")
                    } else if t == 3 {
                        padX = x
                    } else if t == 4 {
                        ballX = x
                    }
                }
            } catch let error {
                log.error(theMessage: "\(error)")
                break loop
            }
        }
    }
}

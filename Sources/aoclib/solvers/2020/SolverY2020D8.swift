//
//  SolverY2020D8.swift
//  aoclib
//
//  Created by Leif Walker-Grant on 07/12/2020.
//

import Foundation

class SolverY2020D8 : Solvable {
    static var description = "Handheld Halting"

    struct Op {
        var ins: String
        var arg: Int

        init(_ inp: String) {
            let op = inp.components(separatedBy: .whitespaces)
            ins = op.first!
            arg = Int(op.last!)!
        }

        func exec(_ accumulator: inout Int) -> Int {
            switch ins {
                case "nop":
                    return 1
                case "acc":
                    accumulator += arg
                    return 1
                case "jmp":
                    return arg
                default:
                    return 0
            }
        }
    }

    let bios: [Op]

    required init(withLog log: Log, andInput input: String) {
        bios = input.components(separatedBy: .newlines).compactMap{ s in Op(s) }
    }

    @discardableResult
    func executeBios(_ code: [Op], _ accumulator: inout Int, _ ip: inout Int) -> Bool {
        var previousPointers = Set<Int>()

        while !previousPointers.contains(ip) && ip < code.count {
            previousPointers.insert(ip)
            ip += code[ip].exec(&accumulator)
        }

        return ip >= code.count
    }

    func doPart1(withLog log: Log) {
        var accumulator = 0, ip = 0
        executeBios(bios, &accumulator, &ip)
        log.solution(theMessage: "The value in the accumulator is \(accumulator).")
    }

    func doPart2(withLog log: Log) {
        var kill = false
        DispatchQueue.concurrentPerform(iterations: bios.count) { index in
            if kill {
                return
            }

            var temp = bios
            if temp[index].ins.matches(#"(nop|jmp)"#) {
                temp[index].ins = temp[index].ins == "nop" ? "jmp" : "nop"
            } else {
                return
            }

            var accumulator = 0, ip = 0
            if executeBios(temp, &accumulator, &ip) {
                kill = true
                log.solution(theMessage: "The value in the accumulator is \(accumulator).")
            } else {
                log.info(theMessage: "Variant \(index) did not yield success.")
            }
        }
    }
}

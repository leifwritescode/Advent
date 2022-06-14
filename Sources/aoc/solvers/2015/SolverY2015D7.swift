//
//  SolverY2015D7.swift
//  aoc
//
//  Created by Leif Walker-Grant on 24/10/2020.
//

import Foundation

fileprivate enum Gate : String, CaseIterable {
    case OR, NOT, AND, LSHIFT, RSHIFT
}

fileprivate class Instruction : CustomStringConvertible {
    private let gate: Gate?
    private let args: [String]

    init (_ instruction: String) {
        self.args = instruction.components(separatedBy: .whitespaces)
        self.gate = Gate.allCases.filter { instruction.contains($0.rawValue) }.first
    }

    var description: String { return args.joined(separator: " ") }

    func execute(registers r: inout [String:Int], log: Log) -> Bool {
        switch (gate) {
        // [a] OR [b] -> [c]
        case .OR:
            let c = args[4]
            guard let a = Int(args[0]) ?? r[args[0]] else {
                log.debug(theMessage: "Unable to process [a] in \(description).")
                return false
            }

            guard let b = Int(args[2]) ?? r[args[2]] else {
                log.debug(theMessage: "Unable to process [b] in \(description).")
                return false
            }

            r[c] = a | b

        // NOT [a] -> [b]
        case .NOT:
            let b = args[3]
            guard let a = Int(args[1]) ?? r[args[1]] else {
                log.debug(theMessage: "Unable to process [a] in \(description).")
                return false
            }

            r[b] = ~a

        // [a] AND [b] -> [c]
        case .AND:
            let c = args[4]
            guard let a = Int(args[0]) ?? r[args[0]] else {
                log.debug(theMessage: "Unable to process [a] in \(description).")
                return false
            }

            guard let b = Int(args[2]) ?? r[args[2]] else {
                log.debug(theMessage: "Unable to process [b] in \(description).")
                return false
            }

            r[c] = a & b

        // [a] LSHIFT b -> [c]
        case .LSHIFT:
            let c = args[4]
            guard let a = Int(args[0]) ?? r[args[0]] else {
                log.debug(theMessage: "Unable to process [a] in \(description)")
                return false
            }

            guard let b = Int(args[2]) else {
                log.debug(theMessage: "Unable to process [b] in \(description).")
                return false
            }

            r[c] = a << b

        // [a] RSHIFT b -> [c]
        case .RSHIFT:
            let c = args[4]
            guard let a = Int(args[0]) ?? r[args[0]] else {
                log.debug(theMessage: "Unable to process [a] in \(description).")
                return false
            }

            guard let b = Int(args[2]) else {
                log.debug(theMessage: "Unable to process [b] in \(description).")
                return false
            }

            r[c] = a >> b

        // [a] -> [b]
        default:
            let b = args[2]
            guard let a = Int(args[0]) ?? r[args[0]] else {
                log.debug(theMessage: "Unable to process [a] in \(description).")
                return false
            }

            r[b] = a
        }

        return true
    }
}

class SolverY2015D7 : Solvable {
    private let instructions: [Instruction]

    required init(withLog log: Log, andInput input: String) {
        instructions = input.components(separatedBy: .newlines)
            .compactMap { Instruction($0) }
    }

    func runProgram(withLog log: Log, outputAt: String = "a", fixup: (inout [String:Int]) -> Void = { _ in }) {
        var registers: [String:Int] = Dictionary()

        var retry = instructions
        while (!retry.isEmpty) {
            fixup(&registers)

            let ins = retry.removeFirst()
            if (!ins.execute(registers: &registers, log: log)) {
                retry.append(ins)
                log.debug(theMessage: "Pushed \(ins.description) on to retry queue. Count = \(retry.count).")
            }
        }

        guard let ans = registers[outputAt] else {
            log.error(theMessage: "Signal on wire \(outputAt) is never set. An error has occurred.")
            return
        }

        log.solution(theMessage: "The signal on wire \(outputAt) is \(ans).")
    }

    func doPart1(withLog log: Log) {
        _ = timed(toLog: log) {
            runProgram(withLog: log, outputAt: "a")
        }
    }

    func doPart2(withLog log: Log) {
        _ = timed(toLog: log) {
            runProgram(withLog: log, outputAt: "a") { r in r["b"] = 16076 }
        }
    }
}

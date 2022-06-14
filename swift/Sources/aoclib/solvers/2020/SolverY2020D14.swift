//
//  SolverY2020D14.swift
//  aoclib
//
//  Created by Leif Walker-Grant on 14/12/2020.
//

import Foundation

fileprivate enum Instruction {
    case setMask(mask: String)
    case setMem(addr: Int, val: Int)
}

class SolverY2020D14 : Solvable {
    static var description = "Docking Data"

    fileprivate let program: [Instruction]

    required init(withLog log: Log, andInput input: String) {
        program = input.components(separatedBy: .newlines)
            .compactMap { line in
                if line.starts(with: "mask") {
                    return .setMask(mask: line.components(separatedBy: " = ").last!)
                } else {
                    let ins = line.groups(for: #"mem\[(\d+)\]\s=\s(\d+)"#).first!
                    return .setMem(addr: Int(ins.first!)!, val: Int(ins.last!)!)
                }
            }
    }

    func maskedValue(_ value: Int, _ mask: String) -> Int {
        let bits = mask.reversed().enumerated()
        return bits.reduce(0) { res, bit in
            switch bit.element {
                case "X":
                    return res + (value & (1 << bit.offset))
                default:
                    return res + (Int(String(bit.element))! << bit.offset)
            }
        }
    }

    func maskedAddress(_ addr: Int, _ mask: String, _ key: Int) -> Int {
        var key = key
        let bits = mask.reversed().enumerated()
        return bits.reduce(0) { res, bit in
            switch bit.element {
                case "0":
                    return res + (addr & (1 << bit.offset))
                case "1":
                    return res + (1 << bit.offset)
                default:
                    defer { key = key >> 1 }
                    return res + ((key & 1) << bit.offset)
            }
        }
    }

    func doPart1(withLog log: Log) {
        var mem = [Int:Int]()
        var mask = ""
        program.forEach { ins in
            switch ins {
                case .setMask(let m):
                    mask = m
                case .setMem(let a, let v):
                    mem[a] = maskedValue(v, mask)
            }
        }

        log.solution(theMessage: "The sum of all non-zero memory is \(mem.values.reduce(0, +)).")
    }

    func doPart2(withLog log: Log) {
        var mem = [Int:Int]()
        var mask = ""
        program.forEach { ins in
            switch ins {
                case .setMask(let m):
                    mask = m
                case .setMem(let a, let v):
                    (0..<(1 << mask.filter({ c in c == "X" }).count))
                        .compactMap { k in maskedAddress(a, mask, k) }
                        .forEach { addr in mem[addr] = v}
            }
        }

        log.solution(theMessage: "The sum of all non-zero memory is \(mem.values.reduce(0, +)).")
    }
}

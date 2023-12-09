//
//  IntcodeVM.swift
//  aoc
//
//  Created by Leif Walker-Grant on 13/11/2020.
//

import Foundation

enum IntcodeStatus : Error, Equatable {
    // The vm has halted normally.
    case halt

    // The vm is waited on read IO.
    case ioInterruptRead

    // The vm is waited on write IO.
    case ioInterruptWrite

    // The vm tried to read memory in an unsupported way.
    case unrecognisedMemoryReadWriteMode

    // The vm tried to execute an opcode it cannot read.
    case unrecognisedOpcode(Int)

    // An attempt was made to read from the output, but it was empty.
    case outputIsEmpty
}

class IntcodeVM {
    private let log: Log
    private let program: [Int]
    private var memory: [Int]
    private let memorySize = 1000000
    private var halt = false
    private var ip = 0
    private var rb = 0

    private var modes = [Int](repeating: 0, count: 3)
    private var inputs = [Int]()
    private var outputs = [Int]()

    private let optable = [
        1:  add,
        2:  mul,
        3:  wrm,
        4:  rdm,
        5:  jnz,
        6:  jpz,
        7:  ltn,
        8:  eql,
        9:  rbo,
        99: hlt,
    ]

    init(log: Log, program: [Int]) {
        self.log = log
        self.program = program
        self.memory = program + Array(repeating: 0, count: memorySize)
    }

    func reset() {
        ip = 0
        halt = false
        rb = 0

        memory = program + Array(repeating: 0, count: memorySize)
        inputs.removeAll()
        outputs.removeAll()
    }

    func push(_ input: Int) {
        inputs.append(input)
    }

    func pop() throws -> Int {
        guard let res = outputs.popFirst() else {
            log.error(theMessage: "pop: output is empty.")
            throw IntcodeStatus.outputIsEmpty
        }

        return res
    }

    @discardableResult
    func run() throws -> Int {
        loop: while (true) {
            do {
                modes.removeAll()
                var ins = try memread(ip)

                // populate the read modes and strip
                modes.append((ins / 100) % 10)     // nnXnn
                modes.append((ins / 1000 ) % 10)   // nYnnn
                modes.append(ins / 10000)          // Xnnnn
                ins = ins % 100                    // nnnXX

                guard let fn = optable[ins] else {
                    throw IntcodeStatus.unrecognisedOpcode(ins)
                }

                ip = try fn(self)(ip)
            } catch let error {
                let e = error as! IntcodeStatus
                switch e {
                case .halt:
                    break loop
                case .ioInterruptRead,
                     .ioInterruptWrite:
                    throw error
                default:
                    log.error(theMessage: "start: \(error)")
                    throw error
                }
            }
        }

        // The memory at position 0 holds the 'exit code.'
        return memory[0]
    }

    func memset(_ addr: Int, _ value: Int) {
        memory[addr] = value
    }

    /* Internal implementation below */

    private func memread(_ addr: Int) throws -> Int {
        // get the next io mode - the default behaviour is to read the immediate value
        let mode = modes.popFirst() ?? 1
        var mem = -1
        switch mode {
        case 0:  // Positional: Read the memory at the address pointed to by addr.
            mem = memory[memory[addr]]
        case 1:  // Immediate:  Read the memory at addr.
            mem = memory[addr]
        case 2:  // Relative: Read the memory at the rb-adjusted address pointed to by addr.
            mem = memory[memory[addr] + rb]
        default:
            log.error(theMessage: "memread: unknown io mode.")
            throw IntcodeStatus.unrecognisedMemoryReadWriteMode
        }

        return mem
    }

    private func memwrite(_ addr: Int, _ value: Int) throws {
        let mode = modes.popFirst() ?? 1
        switch mode {
        case 0, 1: // Immediate mode behaves as positional.
            memory[memory[addr]] = value
        case 2:    // Relative mode, as positional but adjust address by rb.
            memory[memory[addr] + rb] = value
        default:   // Error: Unknown IO mode.
            log.error(theMessage: "memwrite: unknown io mode.")
            throw IntcodeStatus.unrecognisedMemoryReadWriteMode
        }
    }

    private func add(_ ip: Int) throws -> Int {
        let a = try memread(ip + 1)
        let b = try memread(ip + 2)
        let c = a + b

        log.debug(theMessage: "\(String(format: "%04X", ip)): ADD \(a), \(b) -> \(c)")
        try memwrite(ip + 3, c)
        return ip + 4
    }

    private func mul(_ ip: Int) throws -> Int {
        let a = try memread(ip + 1)
        let b = try memread(ip + 2)
        let c = a * b

        log.debug(theMessage: "\(String(format: "%04X", ip)): MUL \(a), \(b) -> \(c)")
        try memwrite(ip + 3, c)
        return ip + 4
    }

    private func wrm(_ ip: Int) throws -> Int {
        guard let b = inputs.popFirst() else {
            log.debug(theMessage: "\(String(format: "%04X", ip)): WRM ??? -> ???")
            throw IntcodeStatus.ioInterruptRead
        }

        log.debug(theMessage: "\(String(format: "%04X", ip)): WRM \(b) -> \(ip + 1)")
        try memwrite(ip + 1, b)
        return ip + 2
    }

    private func rdm(_ ip: Int) throws -> Int {
        let a = try memread(ip + 1)

        log.debug(theMessage: "\(String(format: "%04X", ip)): RDM \(a) -> OUT; ioInterruptWrite")
        outputs.append(a)
        self.ip = ip + 2 // advance the instruction pointer before raising the interrupt
        throw IntcodeStatus.ioInterruptWrite
    }

    private func jnz(_ ip: Int) throws -> Int {
        let a = try memread(ip + 1)
        let b = try memread(ip + 2)

        log.debug(theMessage: "\(String(format: "%04X", ip)): JNZ \(a), \(b)")
        return a != 0 ? b : ip + 3
    }

    private func jpz(_ ip: Int) throws-> Int {
        let a = try memread(ip + 1)
        let b = try memread(ip + 2)

        log.debug(theMessage: "\(String(format: "%04X", ip)): JPZ \(a), \(b)")
        return a == 0 ? b : ip + 3
    }

    private func ltn(_ ip: Int) throws -> Int {
        let a = try memread(ip + 1)
        let b = try memread(ip + 2)
        let c = a < b ? 1 : 0

        log.debug(theMessage: "\(String(format: "%04X", ip)): LTN \(a), \(b) -> \(c)")
        try memwrite(ip + 3, c)
        return ip + 4
    }

    private func eql(_ ip: Int) throws -> Int {
        let a = try memread(ip + 1)
        let b = try memread(ip + 2)
        let c = a == b ? 1 : 0

        log.debug(theMessage: "\(String(format: "%04X", ip)): EQL \(a), \(b) -> \(c)")
        try memwrite(ip + 3, c)
        return ip + 4
    }

    private func rbo(_ ip: Int) throws -> Int {
        let a = try memread(ip + 1)

        log.debug(theMessage: "\(String(format: "%04X", ip)): ARB \(a)")
        rb = rb + a
        return ip + 2
    }

    private func hlt(_ ip: Int) throws -> Int {
        log.debug(theMessage: "\(String(format: "%04X", ip)): HLT")
        throw IntcodeStatus.halt
    }
}

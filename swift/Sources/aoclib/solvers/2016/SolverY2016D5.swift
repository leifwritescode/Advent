//
//  SolverY2016D5.swift
//  aoc
//
//  Created by Leif Walker-Grant on 28/10/2020.
//

import Foundation

class SolverY2016D5 : Solvable {
    static var description = "How About a Nice Game of Chess"

    let doorId: String

    required init(withLog log: Log, andInput input: String) {
        doorId = input
    }

    func doPart1(withLog log: Log) {
        var password = ""
        var suffix = 0
        let stride = 1000

        while (password.count < 8) {
            DispatchQueue.concurrentPerform(iterations: stride) { idx in
                let candidate = "\(doorId)\(suffix + idx)".MD5
                var prefix = candidate.prefix(6)
                if (prefix.dropLast() == "00000") {
                    password += String(prefix.popLast()!)
                    log.debug(theMessage: "Candidate '\(candidate)' passes. Password is currently '\(password).'")
                }
            }
            suffix += stride
        }

        log.solution(theMessage: "The password for door \(doorId) is \(password).")
    }

    func doPart2(withLog log: Log) {
        var password = [String](repeating: "_", count: 8)
        var suffix = 0
        let stride = 10000

        while (password.filter { e in e != "_" }.count < 8) {
            DispatchQueue.concurrentPerform(iterations: stride) { idx in
                let candidate = "\(doorId)\(suffix + idx)".MD5
                var prefix = candidate.prefix(7)
                if (prefix.prefix(5) == "00000") {
                    let b = String(prefix.popLast()!)
                    let a = Int(String(prefix.popLast()!), radix: 16)!
                    if (a < password.count && password[a] == "_") {
                        password[a] = b
                        log.debug(theMessage: "Candidate '\(candidate)' passes. Password is currently '\(password.joined()).'")
                    }
                }
            }
            suffix += stride
        }

        log.solution(theMessage: "The (much more cinematic) password for door \(doorId) is \(password.joined()).")
    }
}

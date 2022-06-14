//
//  SolverY2015D4.swift
//  aoc
//
//  Created by Leif Walker-Grant on 22/10/2020.
//

import Foundation
import CryptoKit

class SolverY2015D4 : Solvable {
    let secretKey: String

    required init(withLog log: Log, andInput input: String) {
        secretKey = input.trimmingCharacters(in: CharacterSet.newlines)
    }

    private func doTask(withPrefix prefix: String, andLog log: Log) {
        if #available(OSX 10.15, *) {
            var found: Bool = false
            var sk2 = 1
            repeat {
                let digest = (secretKey + String(sk2)).MD5
                found = digest.starts(with: prefix)
                if (found) {
                    log.solution(theMessage: "The lowest possible number to produce a digest beginning with \(prefix) is \(sk2).")
                } else {
                    sk2 += 1
                    if (sk2 % 100000 == 0) {
                        log.debug(theMessage: "Sk2 hit \(sk2).")
                    }
                }
            } while !found
        } else {
            log.error(theMessage: "SolverY2015D4 cannot be run on macOS < 10.15.")
        }
    }

    func doPart1(withLog log: Log) {
        _ = timed(toLog: log) {
            doTask(withPrefix: "00000", andLog: log)
        }
    }

    func doPart2(withLog log: Log) {
        _ = timed(toLog: log) {
            doTask(withPrefix: "000000", andLog: log)
        }
    }
}

extension String {
    var MD5: String {
        var result = ""
        if #available(OSX 10.15, *) {
            result = Insecure.MD5
                .hash(data: self.data(using: .utf8)!)
                .map { String(format: "%02hhx", $0) }
                .joined()
        }
        return result
    }
}

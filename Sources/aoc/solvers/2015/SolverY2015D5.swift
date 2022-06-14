//
//  SolverY2015D5.swift
//  aoc
//
//  Created by Leif Walker-Grant on 24/10/2020.
//

import Foundation

class SolverY2015D5 : Solvable {
    let candidates: [String]

    required init(withLog log: Log, andInput input: String) {
        candidates = input.components(separatedBy: .newlines)
    }

    func doPart1(withLog log: Log) {
        _ = timed(toLog: log) {
            let niceStrings = candidates.filter { s in
                var nice = false
                if (!s.matches(#"([aeiou].*){3}"#)) {
                    log.debug(theMessage: "\(s) violates first rule.")
                }  else if (!s.matches(#"(\w)\1"#)) {
                    log.debug(theMessage: "\(s) violates second rule.")
                } else if (!s.matches(#"^((?!ab|cd|pq|xy)\w)*$"#)) {
                    log.debug(theMessage: "\(s) violates third rule.")
                } else {
                    nice = true
                }
                return nice
            }

            log.solution(theMessage: "Of those given, \(niceStrings.count) strings are nice.")
        }
    }

    func doPart2(withLog log: Log) {
        _ = timed(toLog: log) {
            let niceStrings = candidates.filter { s in
                var nice = false
                if (!s.matches(#"(\w\w)(?:.*)(\1)"#)) {
                    log.debug(theMessage: "\(s) violates first rule.")
                } else if (!s.matches(#"(\w)(?:.)(\1)"#)) {
                    log.debug(theMessage: "\(s) violates second rule.")
                } else {
                    nice = true
                }
                return nice
            }

            log.solution(theMessage: "Of those given, applying the alternate rules, \(niceStrings.count) strings are nice.")
        }
    }
}

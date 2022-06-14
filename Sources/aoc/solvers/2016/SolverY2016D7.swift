//
//  SolverY2016D7.swift
//  aoc
//
//  Created by Leif Walker-Grant on 29/10/2020.
//

import Foundation

class SolverY2016D7 : Solvable {
    let ipv7s: [String]

    required init(withLog log: Log, andInput input: String) {
        ipv7s = input.components(separatedBy: .newlines)
    }

    func doPart1(withLog log: Log) {
        _ = timed(toLog: log) {
            guard let candidates = try? ipv7s.filter({ ip in
                (try ip.groups(for: #"(?<!\[)(\w)(\w)\2\1(?![\w\s]*[\]])"#) as [[String]]).filter { b in
                    !b.isEmpty
                }.filter { c in
                    c.joined().splitOnNewCharacter().count == 2
                }.count > 0
            }).filter({ ip in
                (try ip.groups(for: #"\[[^\[\]]*(\w)(\w)\2\1[^\]\[]*\]"#) as [[String]]).filter { b in
                    !b.isEmpty
                }.filter { c in
                    c.joined().splitOnNewCharacter().count == 2
                }.count == 0
            }) else {
                log.error(theMessage: "No IPv7 addresses satisfying the criteria were found.")
                return
            }

            log.solution(theMessage: "The number of IPv7 address supporting TLS is \(candidates.count).")
        }
    }

    func doPart2(withLog log: Log) {
        _ = timed(toLog: log) {
            let candidates = try! ipv7s.reduce(into: [String:[[String]]]()) { (dict, ip) in
                dict[ip] = (try ip.groups(for: #"(?=(?<!\[)(\w)(\w)\1(?![\w\s]*[\]]))"#) as [[String]]).filter { b in
                    !b.isEmpty
                }.filter { c in
                    c.joined().splitOnNewCharacter().count == 2
                }
            }.filter { (_, pairs) in
                !pairs.isEmpty
            }.filter { (ip, pairs) in
                pairs.filter { pair in
                    ip.matches("\\[[^\\[\\]]*(\(pair[1]))(\(pair[0]))\\1[^\\]\\[]*\\]")
                }.count > 0
            }

            log.solution(theMessage: "The number of IPv7 address supporting SSL is \(candidates.count).")
        }
    }
}

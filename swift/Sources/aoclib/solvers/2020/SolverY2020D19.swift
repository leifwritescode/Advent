//
//  SolverY2020D19.swift
//  aoclib
//
//  Created by Leif Walker-Grant on 19/12/2020.
//

import Foundation

class SolverY2020D19 : Solvable {
    static var description = "Monster Messages"

    private enum Rule {
        case rule(c: String)
        case sub(r: [[String]])
    }

    private let rules: [String:Rule]
    let messages: [String]

    required init(withLog log: Log, andInput input: String) {
        // temp has the two sections
        let temp = input.components(separatedBy: .newlines)
            .compactMap{ line in line.replacingOccurrences(of: "\"", with: "") }
            .split(separator: "")

        messages = Array(temp.last!)
        rules = temp.first!.reduce([String:Rule]()) { dict, val in
            var dict = dict
            let sect = val.split(separator: ":")
            let name = String(sect.first!)
            let ruleset = String(sect.last!)
            let rule: Rule
            if ruleset.matches(#"^\s[ab]$"#) {
                rule = .rule(c: sect.last!.trimmingCharacters(in: .whitespaces))
            } else {
                let sub = ruleset.components(separatedBy: "|")
                    .compactMap { rs in
                        rs.components(separatedBy: .whitespaces)
                            .filter { s in
                                !s.isEmpty
                            }
                    }
                rule = .sub(r: sub)
            }
            dict[name] = rule
            return dict
        }
        rules.forEach { k, v in
            log.debug(theMessage: "\(k) -> \(v)")
        }
    }

    private func dfsRegex(_ rule: String, _ ruleset: [String:Rule], _ cache: inout [String:String]) -> String {
        if let cached = cache[rule] {
            return cached
        }

        let result: String
        switch ruleset[rule] {
            case .rule(let c):
                result = c
                cache[rule] = c
            case .sub(let arr):
                // the array is an array of arrays of strings.
                // each array represents an optional part of the capturing group
                // if there is just one array, it all fits within a single abc.
                // if there are several, it looks like abc|abc...
                let subrule = arr.compactMap { rule in
                    rule.reduce("") { r, e in
                        r + dfsRegex(e, ruleset, &cache)
                    }
                }.joined(separator: "|")

                result = "(?>\(subrule))"
                cache[rule] = result
            default:
                // error!
                result = ""
        }
        return result
    }

    func doPart1(withLog log: Log) {
        var cache = [String:String]()
        let regex = "^\(dfsRegex("0", rules, &cache))$"
        let count = messages.filter { msg in msg.matches(regex) }.count
        log.solution(theMessage: "Precisely \(count) messages completely match rule 0.")
    }

    func doPart2(withLog log: Log) {
        var cache = [String:String]()

        // alter the rules per spec
        // ruleset["8"] = .sub(r: [["42"], ["42", "8"]])
        // ruleset["11"] = .sub(r: [["42", "31"], ["42", "11", "31"]])
        // this can be simplified to 42+42{n}31{n}
        // where 1 <= n <= 10
        let fourtytwo = dfsRegex("42", rules, &cache)
        let thirtyone = dfsRegex("31", rules, &cache)

        let count = Array(1...10).reduce(0) { c, e in
            let regex = "^\(fourtytwo)+\(fourtytwo){\(e)}\(thirtyone){\(e)}$"
            return c + messages.filter { msg in msg.matches(regex) }.count
        }

        log.solution(theMessage: "Precisely \(count) messages completely match rule 0.")
    }
}

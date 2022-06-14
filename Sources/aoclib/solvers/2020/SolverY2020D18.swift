//
//  SolverY2020D18.swift
//  aoclib
//
//  Created by Leif Walker-Grant on 18/12/2020.
//

import Foundation

class SolverY2020D18 : Solvable {
    static var description = "Operation Order"

    let equations: [String]

    required init(withLog log: Log, andInput input: String) {
        equations = input.components(separatedBy: .newlines)
    }

    // process brackets.
    func factorise(_ eq: String, _ fSolve: (String) -> Int) -> String {
        // if no opening brackets, nothing to process.
        if !eq.contains("(") {
            return eq
        }

        // find the last bracket, the immediately following term, and the matching close bracket.
        let bOpen = eq.lastIndex(of: "(")!
        let tFirst = eq.index(after: bOpen)
        let bClose = eq[bOpen...].firstIndex(of: ")")!

        // replace the subrange with the factorised value.
        var eq = eq
        eq.replaceSubrange(bOpen...bClose, with: "\(fSolve(String(eq[tFirst..<bClose])))")

        // continue factorising until nothing left to do.
        return factorise(eq, fSolve)
    }

    // solve an equation (be that complete or partial.)
    // processes from left to right.
    func solve(_ eq: String) -> Int {
        var components = eq.split(separator: " ")
        var result = Int(components.removeFirst())!
        while !components.isEmpty {
            let op = components.removeFirst()
            let next = Int(components.removeFirst())!
            switch op {
                case "+":
                    result = result + next
                case "*":
                    result = result * next
                default:
                    break
            }
        }
        return result
    }

    // solve an equation (be that complete or partial.)
    // processes additions before multiplications, left to right.
    func solve2(_ eq: String) -> Int {
        var terms = eq.split(separator: " ")
            .compactMap { ss in String(ss) }

        // solve additions.
        while let pos = terms.firstIndex(of: "+") {
            let r = Int(terms[pos - 1])! + Int(terms[pos + 1])!
            terms.replaceSubrange(pos - 1...pos + 1, with: [String(r)])
        }

        // solve multiplications.
        return terms.filter { s in s != "*" }
            .compactMap{ s in Int(s)! }
            .reduce(1, *)
    }

    func doPart1(withLog log: Log) {
        let sum = equations.reduce(0) { r, eq in
            r + solve(factorise(eq, solve))
        }
        log.solution(theMessage: "The sum of the evaluated expressions is \(sum).")
    }

    func doPart2(withLog log: Log) {
        let sum = equations.reduce(0) { r, eq in
            r + solve2(factorise(eq, solve2))
        }
        log.solution(theMessage: "The sum of the advanced evaluated expressions is \(sum).")
    }
}

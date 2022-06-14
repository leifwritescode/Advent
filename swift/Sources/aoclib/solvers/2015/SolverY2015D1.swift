//
//  SolverY2015D1.swift
//  aoc
//
//  Created by Leif Walker-Grant on 20/10/2020.
//

import Foundation

class SolverY2015D1 : Solvable {
    static var description = "Not Quite Lisp"

    let characters: [Character];

    required init(withLog log: Log, andInput input: String) {
        characters = Array(input)
    }

    func doPart1(withLog log: Log) {
        var floor = 0;
        characters.forEach {
            switch ($0) {
            case "(":
                floor += 1
            case ")":
                floor -= 1
            default:
                log.debug(theMessage: "Found an unexpected character '\($0)'.")
            }
        }
        log.solution(theMessage: "The instructions take Santa to floor \(floor).")
    }

    func doPart2(withLog log: Log) {
        var result = (floor: 0, ins: 0)
        for tuple in characters.enumerated() {
            switch (tuple.element) {
            case "(":
                result.floor += 1
            case ")":
                result.floor -= 1
            default:
                log.debug(theMessage: "Found an unexpected character '\(tuple.element)'.")
            }

            if (result.floor == -1) {
                result.ins = tuple.offset + 1
                break
            }
        }
        log.solution(theMessage: "The first instruction to have Santa reach floor \(result.floor) is \(result.ins).")
    }
}

//
//  SolverY2017D5.swift
//  aoc
//
//  Created by Leif Walker-Grant on 25/11/2020.
//

import Foundation

class SolverY2017D5 : Solvable {
    static var description = "A Maze of Twisty Trampolines, All Alike"

    let program: [Int]

    required init(withLog log: Log, andInput input: String) {
        program = input.components(separatedBy: .newlines).compactMap { Int($0)! }
    }

    func doPart1(withLog log: Log) {
        var tempProgram = program
        var ip = 0
        var steps = 0
        while (ip < tempProgram.count) {
            let ins = tempProgram[ip]
            tempProgram[ip] = ins + 1
            ip = ip + ins
            steps += 1
        }

        log.solution(theMessage: "The number of steps to reach the exit is \(steps).")
    }

    func doPart2(withLog log: Log) {
        var tempProgram = program
        var ip = 0
        var steps = 0
        while (ip < tempProgram.count) {
            let ins = tempProgram[ip]
            tempProgram[ip] = ins > 2 ? ins - 1 : ins + 1
            ip = ip + ins
            steps += 1
        }

        log.solution(theMessage: "The number of steps to reach the exit is \(steps).")
    }
}

//
//  SolverY2020D2.swift
//  aoc
//
//  Created by Leif Walker-Grant on 02/12/2020.
//

import Foundation

struct PwInfo {
    var min: Int
    var max: Int
    var char: String
    var pw: String
}

class SolverY2020D2 : Solvable {
    static var description = "Password Philosophy"

    let pwInfos: [PwInfo]

    required init(withLog log: Log, andInput input: String) {
        pwInfos = input.groups(for: #"(\d+)-(\d+)\s(\w):\s(\w+)"#).compactMap { grps in
            PwInfo(min: Int(grps[0])!,
                   max: Int(grps[1])!,
                   char: grps[2],
                   pw: grps[3])
        }
    }

    func doPart1(withLog log: Log) {
        let valid = pwInfos.filter { pwInfo in
            let count = pwInfo.pw.filter { char in
                pwInfo.char.contains(char)
            }.count
            return Functions.clamp(count, pwInfo.min, pwInfo.max) == count
        }.count
        log.solution(theMessage: "There were \(valid) valid passwords.")
    }

    func doPart2(withLog log: Log) {
        let valid = pwInfos.filter{ pwInfo in
            pwInfo.char.contains(pwInfo.pw[pwInfo.min - 1]) ^
            pwInfo.char.contains(pwInfo.pw[pwInfo.max - 1])
        }.count
        log.solution(theMessage: "Using the new policy, there were \(valid) valid passwords.")
    }
}

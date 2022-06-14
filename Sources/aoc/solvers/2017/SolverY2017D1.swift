//
//  SolverY2017D1.swift
//  aoc
//
//  Created by Leif Walker-Grant on 10/11/2020.
//

import Foundation

class SolverY2017D1 : Solvable {
    static var description = "Inverse Captcha"

    let input: String

    required init(withLog log: Log, andInput input: String) {
        self.input = input
    }

    func doPart1(withLog log: Log) {
        var checksum = input.splitOnNewCharacter()
        if checksum.last?.first == checksum.first?.first {
            let last = checksum.dropLast().first!
            checksum[0].append(last)
        }

        var sum = 0
        checksum.filter { s in
            s.count > 1
        }.forEach { s in
            let num = Int("\(s.first!)")!
            sum += num * (s.count - 1)
        }

        log.solution(theMessage: "The checksum is \(sum).")
    }

    func doPart2(withLog log: Log) {
        let str = Array(input)
        let halfcount = input.count / 2

        var sum = 0
        for (i, c) in str.enumerated() {
            let next = (i + halfcount) % input.count
            if c == str[next] {
                sum += Int("\(c)")!
            }
        }

        log.solution(theMessage: "The checksum, using half-count, is \(sum).")
    }
}

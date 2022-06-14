//
//  SolverY2020D3.swift
//  aoc
//
//  Created by Leif Walker-Grant on 03/12/2020.
//

import Foundation

class SolverY2020D3 : Solvable {
    static var description = "Toboggan Trajectory"

    let h: Int
    let w: Int
    let data: [Coordinate]
    let slopes = [
        Coordinate(3,1),
        Coordinate(1,1),
        Coordinate(5,1),
        Coordinate(7,1),
        Coordinate(1,2)
    ]

    required init(withLog log: Log, andInput input: String) {
        var temp = [Coordinate]()
        let rows = input.components(separatedBy: .newlines)
        for y in 0..<rows.count {
            let cols = Array(rows[y])
            for x in 0..<cols.count {
                if (cols[x] == "#") {
                    temp.append(Coordinate(x, y))
                }
            }
        }

        data = temp
        h = rows.count
        w = Array(rows.first!).count
    }

    func solveFor(_ offset: Coordinate) -> Int {
        var result = 0
        var position = Coordinate.zero
        while (position.y < h) {
            position += offset
            position.x %= w

            if (data.contains(position)) {
                result += 1
            }
        }
        return result
    }

    func doPart1(withLog log: Log) {
        let result = solveFor(slopes.first!)
        log.solution(theMessage: "On slope \(slopes.first!), we encounter \(result) trees.")
    }

    func doPart2(withLog log: Log) {
        let result = slopes.compactMap { slope in solveFor(slope) }.reduce(1, *)
        log.solution(theMessage: "The product of the number of trees encountered on all slopes is \(result).")
    }
}

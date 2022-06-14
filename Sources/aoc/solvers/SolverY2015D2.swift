//
//  SolverY2015D2.swift
//  aoc
//
//  Created by Leif Walker-Grant on 20/10/2020.
//

import Foundation

class SolverY2015D2 : Solvable {
    let boxes: [(w: Int, h: Int, l: Int)]

    required init(withLog log: Log, andInput input: String) {
        var temp: [(w: Int, h: Int, l: Int)] = Array()
        input.components(separatedBy: .newlines).forEach { line in
            if (!line.isEmpty) {
                let dims = line.components(separatedBy: "x")
                temp.append((w: Int(dims[0]) ?? 0, h: Int(dims[1]) ?? 0, l: Int(dims[2]) ?? 0))
            }
        }
        boxes = temp
    }

    func doPart1(withLog log: Log) {
        var sqft = 0
        boxes.forEach { d in
            let d2 = (d.l * d.w, d.w * d.h, d.h * d.l)
            let sm = min(d2.0, min(d2.1, d2.2))
            sqft += sm + (d2.0 * 2) + (d2.1 * 2) + (d2.2 * 2)
        }
        log.solution(theMessage: "The total square feet of wrapping paper to order is \(sqft) sqft.")
    }

    func doPart2(withLog log: Log) {
        var sqft = 0
        boxes.forEach { d in
            let a = Array([d.w, d.h, d.l]).sorted()
            sqft += (a[0] * 2) + (a[1] * 2) + (d.w * d.h * d.l)
        }
        log.solution(theMessage: "The total feet of ribbon to order is \(sqft) sqft.")
    }
}

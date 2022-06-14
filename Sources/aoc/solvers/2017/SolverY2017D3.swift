//
//  SolverY2017D3.swift
//  aoc
//
//  Created by Leif Walker-Grant on 11/11/2020.
//

import Foundation

class SolverY2017D3 : Solvable {
    static var description = "Spiral Memory"

    let address: Int

    required init(withLog log: Log, andInput input: String) {
        address = Int(input)!
    }

    private func firstOn(cycle: Int) -> Int {
        // The equation of the parabola that passes through (1,2), (2,10) and (3,26) is 4x^2 - 4x + 2.
        return 4 * (cycle * cycle) - 4 * cycle + 2
    }

    private func cycleContaining(number: Int) -> Int {
        // Our ulam spiral starts at 1, so we don't offset this.
        let t = Double(number)
        let s = ceil(sqrt(t))
        return ( Int(s) ) / 2
    }

    private func lengthOf(cycle: Int) -> Int {
        // The length of a cycle is 8n.
        return 8 * cycle
    }

    private func sectorContaining(number: Int) -> Int {
        // the sectors are e0, n1, w2, w3
        let c = cycleContaining(number: number) // 1
        let o = number - firstOn(cycle: c) // 0 -> 7
        let n = lengthOf(cycle: c) // 8
        return 4 * o / n // 0 -> 28 / 8
    }

    private func positionOf(number: Int) -> (Int, Int) {
        let c = cycleContaining(number: number)
        let s = sectorContaining(number: number)
        let o = number - firstOn(cycle: c) - s * lengthOf(cycle: c) / 4
        switch (s) {
        case 0:
            return (c, -c + o + 1)
        case 1:
            return (c - o - 1, c)
        case 2:
            return (-c, c - o - 1)
        default:
            return (-c + o + 1, -c)
        }
    }
    
    private func manhattan(pos: (Int,Int)) -> Int {
        return abs(pos.0) + abs(pos.1)
    }

    func doPart1(withLog log: Log) {
        let p = positionOf(number: address)
        let d = manhattan(pos: p)
        log.solution(theMessage: "The number of steps required is \(d).")
    }

    func doPart2(withLog log: Log) {
        var grid = [Vector2:Int]()
        var num = 1

        grid[Vector2.zero] = 1
        while (!grid.values.contains { e in e > address }) {
            num += 1
            let p = positionOf(number: num)
            let v = Vector2(x: Float(p.0), y: Float(p.1))

            var sumP = 0
            for x in stride(from: v.x - 1, to: v.x + 2, by: 1) {
                for y in stride(from: v.y - 1, to: v.y + 2, by: 1) {
                    if v.x == x && v.y == y {
                        continue
                    }

                    let v2 = Vector2(x: x, y: y)
                    if grid.keys.contains(where: { k in k == v2}) {
                        sumP += grid[v2]!
                    }
                }
            }

            log.debug(theMessage: "Computing position \(v) as \(sumP)")
            grid[v] = sumP
        }

        let v = Array(grid.values).sorted(by: >).first!
        log.solution(theMessage: "The first value written that is larger than our input is \(v).")
    }
}

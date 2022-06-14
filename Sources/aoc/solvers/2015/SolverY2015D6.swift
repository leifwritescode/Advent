//
//  SolverY2015D6.swift
//  aoc
//
//  Created by Leif Walker-Grant on 24/10/2020.
//

import Foundation

fileprivate struct Point {
    var x: Int
    var y: Int
}

fileprivate enum Operation {
    case on, off, toggle
}

class SolverY2015D6 : Solvable {
    private let w = 1000
    private let instructions: [(o: Operation, b: Int, xy1: Point, xy2: Point)]

    required init(withLog log: Log, andInput input: String) {
        instructions = input.components(separatedBy: .newlines).compactMap { s in
            if let g: [String] = try? s.groups(for: #"(\D*)\s(\d{1,3}),(\d{1,3})\D*(\d{1,3}),(\d{1,3})"#) {
                log.debug(theMessage: "\(g)")

                let op: Operation
                let b: Int
                switch (g[0]) {
                case "turn on":
                    op = .on
                    b = 1
                case "turn off":
                    op = .off
                    b = -1
                case "toggle":
                    op = .toggle
                    b = 2
                default:
                    return nil // TODO: better than this
                }

                let p1 = Point(x: Int(g[1])!, y: Int(g[2])!)
                let p2 = Point(x: Int(g[3])!, y: Int(g[4])!)

                return (o: op, b: b, xy1: p1, xy2: p2)
            }
            return nil
        }
    }

    func doPart1(withLog log: Log) {
        _ = timed(toLog: log) {
            var grid = Array(repeating: false, count: w * w)

            func unset(i: Int) {
                grid[i] = false
            }

            func set(i: Int) {
                grid[i] = true
            }

            func toggle(i: Int) {
                grid[i] = !grid[i]
            }

            instructions.forEach { t in
                let act: (Int) -> Void
                switch (t.o) {
                case .on:
                    act = set
                case .off:
                    act = unset
                case .toggle:
                    act = toggle
                }
                
                for x in t.xy1.x...(t.xy2.x) {
                    for y in t.xy1.y...(t.xy2.y) {
                        act(y * w + x)
                    }
                }
            }
            
            let onCount = grid.filter { $0 }.count
            log.solution(theMessage: "After following the instructions, \(onCount) lights are on.")
        }
    }

    func doPart2(withLog log: Log) {
        _ = timed(toLog: log) {
            var grid: [Int] = Array(repeating: 0, count: w * w)
            instructions.forEach { t in
                for x in t.xy1.x...(t.xy2.x) {
                    for y in t.xy1.y...(t.xy2.y) {
                        grid[y * w + x] = max(0, grid[y * w + x] + t.b)
                    }
                }
            }

            log.solution(theMessage: "Having retranslated the instructions, the cumulative brightness is \(grid.reduce(0, +)) units.")
        }
    }
}

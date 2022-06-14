//
//  SolverY2015D9.swift
//  aoc
//
//  Created by Leif Walker-Grant on 24/10/2020.
//

import Foundation

class SolverY2015D9 : Solvable {
    private let graph: [String:[(to: String, dist: Int)]]

    required init(withLog log: Log, andInput input: String) {
        var temp = [String:[(to: String, dist: Int)]]()
        input.components(separatedBy: .newlines).forEach { s in
            if let g: [String] = try? s.groups(for: #"(\w*)\sto\s(\w*)\s=\s(\d*)"#) {
                let d = Int(g[2])!
                let t1 = (g[1], d), t0 = (g[0], d)

                if temp[g[0]] == nil { temp[g[0]] = Array() }
                if temp[g[1]] == nil { temp[g[1]] = Array() }

                temp[g[0]]?.append(t1)
                temp[g[1]]?.append(t0)
            }
        }

        for k in temp.keys {
            temp[k] = temp[k]?.sorted {
                $0.dist < $1.dist
            }
        }

        graph = temp
    }

    func recursiveTsp(_ to: String, _ cities: [String], _ log: Log, _ predicate: ((String, Int),(String, Int)) -> Bool) -> Int {
        let next = graph[to]!.filter { n in
            cities.contains(n.to)
        }.sorted(by: predicate).first!

        log.debug(theMessage: "We're at \(to), and our next stop is \(next.to). The distance is \(next.dist).")

        return cities.count == 2 ? next.dist : next.dist + recursiveTsp(next.to, cities.filter { c in c != to }, log, predicate)
    }

    func doPart1(withLog log: Log) {
        _ = timed(toLog: log) {
            let shortest: (String, Int) = graph.keys.compactMap { k in
                log.info(theMessage: "Plotting longest route from \(k).")
                return (k, recursiveTsp(k, Array(graph.keys), log) { a, b in a.1 < b.1 })
            }.sorted { a, b in
                a.1 < b.1
            }.first!
            log.solution(theMessage: "The shortest route is \(shortest.1) km, from \(shortest.0).")
        }
    }

    func doPart2(withLog log: Log) {
        _ = timed(toLog: log) {

            let longest: (String, Int) = graph.keys.compactMap { k in
                log.info(theMessage: "Plotting longest route from \(k).")
                return (k, recursiveTsp(k, Array(graph.keys), log) { a, b in a.1 > b.1 })
            }.sorted { a, b in
                a.1 > b.1
            }.first!
            log.solution(theMessage: "The longest route is \(longest.1) km, from \(longest.0).")
        }
    }
}

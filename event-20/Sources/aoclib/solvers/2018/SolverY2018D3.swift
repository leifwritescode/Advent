//
//  SolverY2018D3.swift
//  aoc
//
//  Created by Leif Walker-Grant on 12/11/2020.
//

import Foundation

class SolverY2018D3 : Solvable {
    static var description = "No Matter How You Slice It"

    let claims: [Vector2:[Int]]

    required init(withLog log: Log, andInput input: String) {
        var temp = [Vector2:[Int]]()
        input.groups(for: #"(\d+)[^\d]+(\d+),(\d+)[^\d]+(\d+)x(\d+)"#).forEach { a in
            let n = Int(a[0])!
            let oX = Float(a[1])!, oY = Float(a[2])!, sX = Float(a[3])!, sY = Float(a[4])!
            for x in stride(from: oX, to: oX + sX, by: 1) {
                for y in stride(from: oY, to: oY + sY, by: 1) {
                    let sq = Vector2(x: x, y: y)
                    if !temp.keys.contains(sq) {
                        temp[sq] = [Int]()
                    }
                    temp[sq]?.append(n)
                }
            }
        }
        claims = temp
    }

    func doPart1(withLog log: Log) {
        let contested = claims.filter { (k, v) in v.count > 1 }.count
        log.solution(theMessage: "There are \(contested) square inches of fabric within two or more claims.")
    }

    func doPart2(withLog log: Log) {
        var uncontestedClaim = 0
        var uncontestedSquares = Array(Set(claims.filter { (_, v) in v.count == 1 }.compactMap { (k, v) in v.first! }))
        DispatchQueue.concurrentPerform(iterations: uncontestedSquares.count) { square in
            let claim = uncontestedSquares.popLast()!
            let uncontested = claims.values.first { a in a.contains(claim) && a.count > 1 } == nil
            if uncontested {
                uncontestedClaim = claim
            }
        }

        log.solution(theMessage: "The uncontested claim is \(uncontestedClaim).")
    }
}

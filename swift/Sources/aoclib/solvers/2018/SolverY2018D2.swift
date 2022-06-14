//
//  SolverY2018D2.swift
//  aoc
//
//  Created by Leif Walker-Grant on 12/11/2020.
//

import Foundation

class SolverY2018D2 : Solvable {
    static var description = "Inventory Management System"

    let skus: [String]

    required init(withLog log: Log, andInput input: String) {
        skus = input.components(separatedBy: .newlines)
    }

    func doPart1(withLog log: Log) {
        let two = skus.compactMap { s in
            String(s.sorted()).splitOnNewCharacter()
        }.filter { a in
            a.first(where: { s in s.count == 2 }) != nil
        }.count

        let three = skus.compactMap { s in
            String(s.sorted()).splitOnNewCharacter()
        }.filter { a in
            a.first(where: { s in s.count == 3 }) != nil
        }.count

        log.solution(theMessage: "The checksum is \(two * three).")
    }

    func doPart2(withLog log: Log) {
        var result: String = ""
        loop: for (idx, sku1) in skus.enumerated() {
            for (sku2) in skus[..<idx] {
                let zipped = zip(sku1, sku2)
                var iter = zipped.filter { (c1, c2) in
                    c1 != c2
                }.makeIterator()

                _ = iter.next()
                if iter.next() == nil {
                    result = String(zipped.filter { (c1, c2) in
                        c1 == c2
                    }.map { (c1, c2) in c1 })
                    break loop
                }
            }
        }

        log.solution(theMessage: "The common letters are '\(result).'")
    }
}

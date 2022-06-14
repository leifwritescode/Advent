//
//  Solvable.swift
//  aoc
//
//  Created by Leif Walker-Grant on 19/10/2020.
//

protocol Solvable {
    init (withLog log: Log, andInput input: String)

    func doPart1(withLog log: Log) -> Void

    func doPart2(withLog log: Log) -> Void
}

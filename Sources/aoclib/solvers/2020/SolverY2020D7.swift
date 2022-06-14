//
//  SolverY2020D7.swift
//  aoclib
//
//  Created by Leif Walker-Grant on 07/12/2020.
//

import Foundation

class SolverY2020D7 : Solvable {
    static var description = "Handy Haversacks"

    let clr = "shiny gold"
    let map: [String:[Bag]]

    struct Bag : Hashable {
        var clr: String
        var num: Int

        init(_ c: String, _ n: Int) {
            clr = c
            num = n
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(clr)
            hasher.combine(num)
        }
    }

    required init(withLog log: Log, andInput input: String) {
        map = input.components(separatedBy: .newlines)
            .reduce([String:[Bag]]()) { dict, elem in
                let bag = elem.groups(for: #"^(\w+\s\w+)"#).first!.first!
                let contents = elem.groups(for: #"(\d+)\s(\w+\s\w+)"#).compactMap { pair in Bag(pair[1], Int(pair[0])!) }
                var dict = dict
                dict[bag] = contents
                return dict
            }
    }

    // Recursively map all bags that could directly or indirectly contain the current bag.
    func bagsHaving(_ bag: String) -> [String] {
        var result = [bag]
        let nextColours = map
            .filter { k, v in v.contains { b in b.clr == bag } }
            .keys

        if !nextColours.isEmpty {
            result += nextColours
                .reduce([String]()) { arr, next in arr + bagsHaving(next) }
        }

        return result
    }

    // Recursively count total number of bags that could be directly or indirectly contained by the current bag.
    func bagsIn(_ bag: Bag) -> Int {
        var result = bag.num
        let nextBags = map[bag.clr]!

        if !nextBags.isEmpty {
            result *= nextBags
                .reduce(1) { i, next in i + bagsIn(next) }
        }

        return result
    }

    func doPart1(withLog log: Log) {
        let result = map
            .filter { k, v in v.contains { b in b.clr == clr } }
            .keys
            .reduce([String]()) { a, c in a + bagsHaving(c) }
        log.solution(theMessage: "The number of bags that can directly or indirectly contain a shiny gold bag is \(Set(result).count).")
    }

    func doPart2(withLog log: Log) {
        let result = map[clr]!
            .compactMap { b in bagsIn(b) }
            .reduce(0) { t, b in t + b }
        log.solution(theMessage: "The number of bags that a shiny gold bag can directly or indirectly contain is \(result).")
    }
}

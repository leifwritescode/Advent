//
//  SolverY2020D21.swift
//  aoclib
//
//  Created by Leif Walker-Grant on 21/12/2020.
//

import Foundation

class SolverY2020D21 : Solvable {
    static var description = "Allergen Assessment"

    let lines: [String:[[String]]]

    required init(withLog log: Log, andInput input: String) {
        lines = input.components(separatedBy: .newlines)
            .reduce([String:[[String]]]()) { dict, line in
                var dict = dict
                let allergens = line.groups(for: #"\(contains\s([^\)]+)\)"#)
                    .first!
                    .first!
                    .components(separatedBy: ", ")
                let ingredients = line.groups(for: #"^(.*?)\s\("#)
                    .first!
                    .first!
                    .components(separatedBy: .whitespaces)

                allergens.forEach { a in
                    var curr = dict[a] ?? [[String]]()
                    curr.append(ingredients)
                    dict[a] = curr
                }

                return dict
            }
    }

    func establishAllergens() -> [String:Set<String>] {
        // reduce all into the sets of potential allergens.
        var sets = lines.reduce([String:Set<String>]()) { dict, kvp in
            var dict = dict
            dict[kvp.key] = kvp.value.reduce(Set(kvp.value.first!)) { set, arr in
                set.intersection(arr)
            }
            return dict
        }

        // establish allergens by process of elimination.
        while !sets.allSatisfy({ k, v in v.count == 1 }) {
            sets.filter { k, v in v.count == 1}
                .forEach { k, v in
                    sets.forEach { j, b in
                        if j == k { return }
                        else {
                            var b2 = b
                            b2.remove(v.first!)
                            sets[j] = b2
                        }
                    }
                }
        }

        return sets
    }

    func doPart1(withLog log: Log) {
        // take the set of the allergens themselves.
        let allergens = establishAllergens().values
            .reduce(Set<String>()) { r, s in r.union(s) }

        // take the set of foodstuffs.
        let foodstuffs = lines.reduce(Set<[String]>()) { r, kvp in
            var r = r
            kvp.value.forEach { a in r.insert(a) }
            return r
        }

        // find count of all ingredients that are not allergens.
        let result = foodstuffs.reduce(0) { r, f in
            r + f.filter { i in !allergens.contains(i) }.count
        }

        log.solution(theMessage: "The non-allergenic ingredients appear \(result) times.")
    }

    func doPart2(withLog log: Log) {
        let allergens = establishAllergens()

        // sort allergens by key and then join the values.
        let cdi = allergens.sorted(by: { a, b in a.key < b.key })
            .compactMap { kvp in kvp.value.first! }
            .joined(separator: ",")

        log.solution(theMessage: "The canonical dangerous ingredient list is '\(cdi)'.")
    }
}

//
//  SolverY2019D22.swift
//  aoc
//
//  Created by Leif Walker-Grant on 16/11/2020.
//

import Foundation

fileprivate enum Technique : String {
    case cut = "cut"
    case dealWithIncrement = "deal with increment"
    case dealIntoNewStack = "deal into new stack"
}

class SolverY2019D22 : Solvable {
    static var description = "Slam Shuffle"

    let shuffles: [[String]]

    required init(withLog log: Log, andInput input: String) {
        shuffles = input.groups(for: #"([^\d\n-]+)([-\d]+)?"#).compactMap { a in
            a.compactMap{ b in
                b.trimmingCharacters(in: .whitespaces)
            }
        }
    }

    fileprivate func dealIntoNewStack(_ deck: [Int]) -> [Int] {
        return deck.reversed()
    }

    fileprivate func dealWithIncrement(_ n: Int, _ deck: [Int]) -> [Int] {
        var result = [Int](repeating: -1, count: deck.count)

        var pos = 0
        for card in deck {
            result[pos] = card
            pos = (pos + n) % deck.count
        }

        guard result.allSatisfy({ i in i > -1 }) else {
            print("Deck has unset positions...")
            return []
        }

        return result
    }

    fileprivate func cut(_ n: Int, _ deck: [Int]) -> [Int] {
        let result: [Int]

        guard deck.count >= abs(n) else {
            print("Deck isn't large enough to cut by \(n).")
            return []
        }

        if n < 0 {
            // cut from bottom, place on top
            result = Array(deck.suffix(abs(n)) + deck.dropLast(abs(n)))
        } else {
            // cut from top, place on bottom
            result = Array(deck.dropFirst(n) + deck.prefix(n))
        }

        return result
    }

    fileprivate func shuffle(_ deck: [Int], _ log: Log) -> [Int] {
        var temp = deck

        for shuffle in shuffles {
            let technique = Technique.init(rawValue: shuffle.first!)
            let n = Int(shuffle.last!)

            log.debug(theMessage: "Shuffling with \(shuffle.first!), n=\(n != nil ? String(n!) : "N/A").")
            switch technique {
            case .cut:
                temp = cut(n!, temp)
            case .dealIntoNewStack:
                temp = dealIntoNewStack(temp)
            case .dealWithIncrement:
                temp = dealWithIncrement(n!, temp)
            default:
                log.error(theMessage: "Encountered an unknown technique.")
            }
        }

        return temp
    }

    func doPart1(withLog log: Log) {
        let index = shuffle(Array(0..<10007), log).firstIndex(of: 2019) ?? -1
        log.solution(theMessage: "The card \(2019) is at position \(index).")
    }

    func doPart2(withLog log: Log) {
        log.info(theMessage: "Not yet implemented.")
    }
}

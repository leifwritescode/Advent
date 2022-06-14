//
//  SolverY2020D11.swift
//  aoclib
//
//  Created by Leif Walker-Grant on 11/12/2020.
//

import Foundation

class SolverY2020D11 : Solvable {
    static var description = "Seating System"

    let extents: Coordinate
    let occupied: [Coordinate:Bool]
    let offsets = [
        Coordinate(1, 0),
        Coordinate(-1, 0),
        Coordinate(0, 1),
        Coordinate(0, -1),
        Coordinate(1, 1),
        Coordinate(1, -1),
        Coordinate(-1, 1),
        Coordinate(-1, -1)
    ]

    required init(withLog log: Log, andInput input: String) {
        var temp = [Coordinate:Bool]()
        let rows = input.components(separatedBy: .newlines)
        for y in 0..<rows.count {
            let cols = Array(rows[y])
            for x in 0..<cols.count {
                if cols[x] == "L" {
                    temp[Coordinate(x, y)] = false
                } else if cols[x] == "#" {
                    temp[Coordinate(x, y)] = true
                }
            }
        }
        occupied = temp
        extents = Coordinate(rows[0].count, rows.count)
    }

    func rFirstVis(_ field: [Coordinate:Bool], _ coord: Coordinate, _ offset: Coordinate) -> Coordinate? {
        let next = coord + offset
        if (next < Coordinate.zero ||
            next > extents ) {
            return nil
        }

        return field.keys.contains(next) ? next : rFirstVis(field, next, offset)
    }

    func getFirstVisAdjacents(_ me: Coordinate, _ layout: [Coordinate:Bool]) -> Int {
        // This can be optimised further.
        return offsets.reduce(0) { r, c in r + (layout[rFirstVis(layout, me, c) ?? Coordinate(-1, -1)] ?? false ? 1 : 0) }
    }

    func getAdjacents(_ me: Coordinate, _ layout: [Coordinate:Bool]) -> Int {
        return offsets.reduce(0) { r, c in r + (layout[me + c] ?? false ? 1 : 0) }
    }

    func doPart1(withLog log: Log) {
        var current = occupied
        var applied = [Coordinate:Bool]()

        while current != applied {
            // apply after first run
            if applied.count > 0 {
                current = applied
            }

            current.forEach { seat, state in
                let adjacents = getAdjacents(seat, current)

                // A seat becomes occupied if it is empty and no occupied seats adjacent
                // A seat becomes vacant if > 3 occupied seats adjacent
                // Else, no change
                applied[seat] = (!state && adjacents == 0 ) || (state && adjacents > 3) ? !state : state
            }
        }

        log.solution(theMessage: "The occupied seats total \(current.filter { _, v in v }.count)")
    }
    
    func doPart2(withLog log: Log) {
        var current = occupied
        var applied = [Coordinate:Bool]()

        while current != applied {
            // apply after first run
            if applied.count > 0 {
                current = applied
            }

            current.forEach { seat, state in
                let adjacents = getFirstVisAdjacents(seat, current)

                // A seat becomes occupied if it is empty and no occupied seats adjacent
                // A seat becomes vacant if > 3 occupied seats adjacent
                // Else, no change
                applied[seat] = (!state && adjacents == 0 ) || (state && adjacents > 4) ? !state : state
            }
        }

        log.solution(theMessage: "The occupied seats total \(current.filter { _, v in v }.count)")
    }
}

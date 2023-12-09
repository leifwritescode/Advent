//
//  Coordinate.swift
//  aoc
//
//  Created by Leif Walker-Grant on 15/11/2020.
//

import Foundation

typealias Point = Coordinate

struct Coordinate : Hashable, Comparable {
    var x: Int, y: Int

    static var zero = Coordinate(0, 0)

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }

    static func + (_ lhs: Coordinate, _ rhs: Coordinate) -> Coordinate {
        return Coordinate(lhs.x + rhs.x, lhs.y + rhs.y)
    }

    static func += (_ lhs: inout Coordinate, _ rhs: Coordinate) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }

    static func < (_ lhs: Coordinate, _ rhs: Coordinate) -> Bool {
        return (lhs.x < rhs.x) || (lhs.y < rhs.y)
    }

    static func * (_ lhs: Coordinate, _ rhs: Int) -> Coordinate {
        return Coordinate(lhs.x * rhs, lhs.y * rhs)
    }
}

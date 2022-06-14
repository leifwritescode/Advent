//
//  Vector2.swift
//  aoc
//
//  Created by Leif Walker-Grant on 22/10/2020.
//

import Foundation

struct Vector2 {
    var x: Float
    var y: Float

    init (xy: Float) {
        self.x = xy;
        self.y = xy;
    }

    init (x: Float, y: Float)
    {
        self.x = x;
        self.y = y;
    }
}

extension Vector2 : AdditiveArithmetic {
    static func - (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func -= (lhs: inout Vector2, rhs: Vector2) {
        lhs.x = lhs.x - rhs.x
        lhs.y = lhs.y - rhs.y
    }

    static func + (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func += (lhs: inout Vector2, rhs: Vector2) {
        lhs.x = lhs.x + rhs.x
        lhs.y = lhs.y + rhs.y
    }

    static var zero: Vector2 {
        return Vector2(xy: 0)
    }
}

extension Vector2 : Equatable {
    static func == (lhs: Vector2, rhs: Vector2) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y)
    }
}

extension Vector2 : Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

extension Vector2 : CustomStringConvertible {
    public var description: String {
        return "(x: \(x), y: \(y))"
    }
}

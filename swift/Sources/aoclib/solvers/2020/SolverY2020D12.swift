//
//  SolverY2020D12.swift
//  aoclib
//
//  Created by Leif Walker-Grant on 11/12/2020.
//

import Foundation

fileprivate enum Direction {
    case north(num: Int),
         east(num: Int),
         south(num: Int),
         west(num: Int),
         left(num: Int),
         right(num: Int),
         forward(num: Int)

    mutating func rotateRight(_ degrees: Int) {
        let rotations = degrees / 90

        for _ in 0..<rotations {
            switch self {
                case .north:
                    self = .east(num: 0)
                case .east:
                    self = .south(num: 0)
                case .south:
                    self = .west(num: 0)
                case .west:
                    self = .north(num: 0)
                default:
                    break
            }
        }
    }

    mutating func rotateLeft(_ degrees: Int) {
        let rotations = degrees / 90

        for _ in 0..<rotations {
            switch self {
                case .north:
                    self = .west(num: 0)
                case .east:
                    self = .north(num: 0)
                case .south:
                    self = .east(num: 0)
                case .west:
                    self = .south(num: 0)
                default:
                    break
            }
        }
    }
}

fileprivate extension Coordinate {
    mutating func move(in direction: Direction, by: Int) {
        switch direction {
            case .north:
                self.y += by
            case .east:
                self.x += by
            case .south:
                self.y -= by
            case .west:
                self.x -= by
            default:
                break
        }
    }

    mutating func offset(_ by: Coordinate) {
        self = self + by
    }

    mutating func rotateAbout(_ coord: Coordinate, by degrees: Int) {
        /* This doesn't seem to work, and I can't quite place why.
        let s = Int(sin(Double(abs(degrees)) * Double.pi / 180))
        let c = Int(cos(Double(abs(degrees)) * Double.pi / 180))
        self.x = self.x * c - self.y * s
        self.y = self.x * s + self.y * c
        */

        // A simpler one.
        // a right rotation by 90 degrees is simply defined as
        // y = -x
        // x = y
        // to achieve the same, but left, just add two 4 rotations
        let theta = degrees < 0 ? degrees + 360 : degrees
        for _ in 0..<theta/90 {
            let t = self.y
            self.y = -self.x
            self.x = t
        }
    }
}

class SolverY2020D12 : Solvable {
    static var description = "Rain Risk"

    private let movements: [Direction]

    required init(withLog log: Log, andInput input: String) {
        movements = input.components(separatedBy: .newlines).compactMap { line in
            let val = Int(line.dropFirst())!
            switch line.first! {
                case "N":
                    return .north(num: val)
                case "E":
                    return .east(num: val)
                case "S":
                    return .south(num: val)
                case "W":
                    return .west(num: val)
                case "L":
                    return .left(num: val)
                case "R":
                    return .right(num: val)
                case "F":
                    return .forward(num: val)
                default:
                    return nil
            }
        }
    }

    func doPart1(withLog log: Log) {
        var current = Direction.east(num: 0)
        var position = Coordinate.zero
        movements.forEach { action in
            switch action {
                case .forward(let num):
                    position.move(in: current, by: num)
                case .left(let num):
                    current.rotateLeft(num)
                case .right(let num):
                    current.rotateRight(num)
                case .north(let num),
                     .east(let num),
                     .south(let num),
                     .west(let num):
                    position.move(in: action, by: num)
            }
        }
        log.solution(theMessage: "The manhattan distance is \(abs(position.x) + abs(position.y)).")
    }

    func doPart2(withLog log: Log) {
        var position = Coordinate.zero
        var waypoint = Coordinate(10, 1)
        movements.forEach{ action in
            log.debug(theMessage: "\(action).")
            switch action {
                case .forward(let num):
                    position.offset(waypoint * num)
                case .left(let num):
                    waypoint.rotateAbout(position, by: -num)
                case .right(let num):
                    waypoint.rotateAbout(position, by: num)
                case .north(let num),
                     .east(let num),
                     .south(let num),
                     .west(let num):
                    waypoint.move(in: action, by: num)
            }
            log.debug(theMessage: "\(action) -> waypoint is now \(waypoint), position is \(position).")
        }
        log.solution(theMessage: "The manhattan distance is \(abs(position.x) + abs(position.y)).")
    }
}

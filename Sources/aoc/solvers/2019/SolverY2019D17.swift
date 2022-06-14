//
//  SolverY2019D17.swift
//  aoc
//
//  Created by Leif Walker-Grant on 15/11/2020.
//

import Foundation

fileprivate enum Direction : String {
    case north = "^", south = "v", west = ">", east = "<"
}

fileprivate extension Direction {
    func left() -> Direction {
        switch (self) {
        case .north:
            return .west
        case .east:
            return .north
        case .south:
            return .east
        case .west:
            return .south
        }
    }

    func right() -> Direction {
        switch (self) {
        case .north:
            return .east
        case .east:
            return .south
        case .south:
            return .west
        case .west:
            return .north
        }
    }
}

fileprivate extension Coordinate {
    func ifMove(_ d: Direction) -> Coordinate {
        let coord: Coordinate
        switch d {
        case .north:
            coord = Coordinate(x, y - 1)
        case .east:
            coord = Coordinate(x + 1, y)
        case .south:
            coord = Coordinate(x, y + 1)
        case .west:
            coord = Coordinate(x - 1, y)
        }
        return coord
    }
}

class SolverY2019D17 : Solvable {
    static var description = "Set and Forget"

    let program: [Int]

    required init(withLog log: Log, andInput input: String) {
        program = input.split(separator: ",").compactMap { i in Int(i)! }
    }

    func printBuffer(_ buffer: [Coordinate], _ log: Log) {
        let extents = getExtents(buffer)
        for y in extents.0.y...extents.1.y {
            var str = ""
            for x in extents.0.x...extents.1.x {
                if buffer.contains(Coordinate(x, y)) {
                    str += "#"
                } else {
                    str += "."
                }
            }
            log.info(theMessage: str)
        }
    }

    func getExtents(_ segments: [Coordinate]) -> (Coordinate, Coordinate) {
        return (
            Coordinate(
                segments.min { a, b in a.x < b.x }!.x,
                segments.min { a, b in a.y < b.y }!.y
            ),
            Coordinate(
                segments.max { a, b in a.x < b.x }!.x,
                segments.max { a, b in a.y < b.y }!.y
            )
        )
    }

    fileprivate func getPathSegments(_ log: Log) -> (startDir: Direction, startCoord: Coordinate, segments: [Coordinate]) {
        let vm = IntcodeVM(log: log, program: program)

        var direction = Direction.north
        var start = Coordinate.zero
        var segments = [Coordinate]()
        var x = 0
        var y = 0

        loop: while (true) {
            do {
                try vm.run()
                break loop
            } catch IntcodeStatus.ioInterruptWrite {
                if let d = try? vm.pop() {
                    switch d {
                    case Functions.cToA("\n"):
                        y += 1
                        x = 0
                        continue loop
                    case Functions.cToA("#"):
                        segments.append(Coordinate(x, y))
                    case Functions.cToA("."):
                        break
                    default:
                        direction = Direction(rawValue: Functions.aToC(d))!
                        start = Coordinate(x, y)
                    }
                    x += 1
                }
            } catch let error {
                log.error(theMessage: "\(error)")
                break loop
            }
        }

        return (direction, start, segments)
    }

    func getIntersections(_ segments: [Coordinate]) -> [Coordinate] {
        let set = Set(segments)
        return set.filter { coord in
            [Direction.north, .east, .south, .west].allSatisfy { direction in
                set.contains(coord.ifMove(direction))
            }
        }
    }

    func doPart1(withLog log: Log) {
        let world = getPathSegments(log)
        let coords = getIntersections(world.segments)
        let apSum = coords.compactMap { coord in coord.x * coord.y }.reduce(0, +)
        log.solution(theMessage: "The sum of the alignment parameters is \(apSum).")

        // Uncomment to print a visualisation of $world.
        // printBuffer(world.segments, log)
    }

    func doPart2(withLog log: Log) {
    }
}

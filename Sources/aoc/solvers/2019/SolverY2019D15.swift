//
//  SolverY2019D15.swift
//  aoc
//
//  Created by Leif Walker-Grant on 14/11/2020.
//

import Foundation

fileprivate enum Tile : Int {
    case wall = 0, corridor = 1, oxygen = 2
}

fileprivate enum Direction : Int {
    case north = 1, south = 2, west = 3, east = 4
}

fileprivate struct Coordinate : Hashable {
    var x: Int, y: Int

    static var zero = Coordinate(0, 0)

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

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

    func directionTo(_ rhs: Coordinate) -> Direction {
        var direction = Direction.north
        if self.x < rhs.x {
            direction = Direction.east
        } else if self.x > rhs.x {
            direction = Direction.west
        } else if self.y < rhs.y {
            direction = Direction.south
        } else if self.y > rhs.y {
            direction = Direction.north
        }
        return direction
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.x)
        hasher.combine(self.y)
    }
}

class SolverY2019D15 : Solvable {
    static var description = "Oxygen System"

    let program: [Int]

    required init(withLog log: Log, andInput input: String) {
        program = input.split(separator: ",").compactMap { i in Int(i)! }
    }

    fileprivate func routeAlong(_ path: [Coordinate:Coordinate], _ from: Coordinate) -> [Coordinate] {
        var current = from
        var result = [Coordinate]()
        while let next = path[current] {
            result.append(current)
            current = next
        }
        return result.reversed()
    }

    fileprivate func breadthFirstMaxDepth(in world: [Coordinate:Tile], from: Coordinate) -> Int {
        var coords = [Coordinate]()
        var visited = [Coordinate]()
        var maxDepth = -1

        coords.append(from)
        visited.append(from)

        while !coords.isEmpty {
            var nextCoords = [Coordinate]()
            while let next = coords.popFirst() {
                for d in [Direction.north, .east, .south, .west] {
                    let neighbour = next.ifMove(d)
                    if visited.contains(neighbour) {
                        continue
                    }

                    visited.append(neighbour)
                    if world[neighbour] == .corridor {
                        nextCoords.append(neighbour)
                    }
                }
            }
            coords.append(contentsOf: nextCoords)
            maxDepth += 1
        }

        return maxDepth
    }

    fileprivate func breadthFirstSearch(for tile: Tile?, in world: [Coordinate:Tile], from: Coordinate) -> [Coordinate] {
        var coords = [Coordinate]()          // candidates for search
        var visited = Set<Coordinate>()      // coords we've visited
        var path = [Coordinate:Coordinate]() // the path we've constructed
        var result = [Coordinate]()

        coords.append(from)
        visited.insert(from)

        while let next = coords.popFirst() {
            let atFoot = world[next]
            if atFoot == tile {
                result = routeAlong(path, next)
                break
            } else if atFoot != .wall {
                for d in [Direction.north, .east, .south, .west] {
                    let neighbour = next.ifMove(d)
                    if visited.contains(neighbour) {
                        continue
                    }

                    visited.insert(neighbour)
                    coords.append(neighbour)
                    path.updateValue(next, forKey: neighbour)
                }
            }
        }

        return result
    }

    fileprivate func breadthFirstExplore(_ log: Log) -> [Coordinate:Tile] {
        var world = [Coordinate:Tile]()
        var planned = [Coordinate]()
        var myDirection = Direction.north
        var myPosition = Coordinate.zero
        let vm = IntcodeVM(log: log, program: program)

        world.updateValue(.corridor, forKey: Coordinate.zero)
        planned.append(myPosition.ifMove(.north))

        loop: while (true) {
            do {
                try vm.run()
                break loop
            } catch IntcodeStatus.ioInterruptRead {
                // Wants next move
                if let destination = planned.popFirst() {
                    myDirection = myPosition.directionTo(destination)
                    vm.push(myDirection.rawValue)
                } else {
                    log.error(theMessage: "The planned path was unexpectedly empty!")
                    break loop
                }
            } catch IntcodeStatus.ioInterruptWrite {
                if let last = try? vm.pop() {
                    // Outcome of the last move.
                    let tile = Tile(rawValue: last)!
                    let destination = myPosition.ifMove(myDirection)
                    if tile != .wall {
                        myPosition = destination
                    }
                    world.updateValue(tile, forKey: destination)
                    if planned.isEmpty {
                        // plan a new route.
                        planned = breadthFirstSearch(for: nil, in: world, from: myPosition)
                        // if the route is still empty, we're finished.
                        if planned.isEmpty {
                            break loop
                        }
                    }
                }
            } catch let error {
                log.error(theMessage: "An unexpected error occured in the ICVM: \(error).")
                break loop
            }
        }

        return world
    }

    fileprivate func printWorld(_ log: Log, _ world: [Coordinate:Tile]) {
        let min = Coordinate(world.min { $0.key.x < $1.key.x }!.key.x,
                             world.min { $0.key.y < $1.key.y }!.key.y)
        let max = Coordinate(world.max { $0.key.x < $1.key.x }!.key.x,
                             world.max { $0.key.y < $1.key.y }!.key.y)
        for y in min.y...max.y {
            var row = ""
            for x in min.x...max.x {
                let tile = world[Coordinate(x, y)]
                switch tile {
                case .wall:
                    row.append("X")
                case .corridor:
                    row.append(" ")
                case .oxygen:
                    row.append("O")
                default:
                    row.append("?")
                }
            }
            log.debug(theMessage: row)
        }
    }

    func doPart1(withLog log: Log) {
        log.info(theMessage: "Mapping. This might take a while...")

        let world = breadthFirstExplore(log)
        let path = breadthFirstSearch(for: .oxygen, in: world, from: Coordinate.zero)

        log.solution(theMessage: "The shortest path is \(path.count).")

        // Print in debug.
        printWorld(log, world)
    }

    func doPart2(withLog log: Log) {
        log.info(theMessage: "Mapping. This might take a while...")

        let world = breadthFirstExplore(log)
        let oxygen = world.first { _, v in v == .oxygen }!.key
        let depth = breadthFirstMaxDepth(in: world, from: oxygen)

        log.solution(theMessage: "The time to reach optimal oxygen saturation is \(depth) minutes.")

        // Print in debug.
        printWorld(log, world)
    }
}

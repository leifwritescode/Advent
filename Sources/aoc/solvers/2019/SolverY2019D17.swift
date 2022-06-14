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

fileprivate enum Command : String {
    case RotateLeft = "L", RotateRight = "R", StepForward = "1"
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

    fileprivate func convert(_ commands: [Command]) -> [String] {
        return commands.compactMap { cmd in cmd.rawValue }
            .joined()
            .splitOnNewCharacter()
            .compactMap { a in "\(a.first!)" == Command.StepForward.rawValue ? "\(a.count)" : "\(a.first!)" }
    }

    fileprivate func computeWalkInstructions(_ startDirection: Direction,
                                             _ startCoord: Coordinate,
                                             _ segments: [Coordinate],
                                             _ log: Log) -> [String] {
        var cmds = [Command]()
        var cPos = startCoord
        var cDir = startDirection

        repeat {
            var nPos = cPos
            var nDir = cDir
            let tPos = cPos.ifMove(cDir)
            let lRot = cDir.left()
            let rRot = cDir.right()

            if segments.contains(tPos) {
                nPos = tPos
                cmds.append(.StepForward)
            } else {
                if segments.contains(cPos.ifMove(lRot)) {
                    nDir = lRot
                    cmds.append(.RotateLeft)
                } else if segments.contains(cPos.ifMove(rRot)) {
                    nDir = rRot
                    cmds.append(.RotateRight)
                } else {
                    log.error(theMessage: "The was nowhere to go?")
                }
            }

            cPos = nPos
            cDir = nDir
        } while cmds.filter { c in c == .StepForward }.count < segments.count

        return convert(cmds)
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
        let world = getPathSegments(log)
        // the world segments need to be doubled up where they intersect.
        let complete = world.segments + getIntersections(world.segments)
        let instructions = computeWalkInstructions(world.startDir, world.startCoord, complete, log)

        // I cheated here and worked out the groups by hand. They are:
        let subA = ["L", "4", "L", "4", "L", "10", "R", "4"],
            subB = ["R", "4", "L", "4", "L", "4", "R", "8", "R", "10"],
            subC = ["R", "4", "L", "10", "R", "10"]
        let main = instructions.joined(separator: ",")
            .replacingOccurrences(of: subA.joined(separator: ","), with: "A")
            .replacingOccurrences(of: subB.joined(separator: ","), with: "B")
            .replacingOccurrences(of: subC.joined(separator: ","), with: "C")

        // Print to log since it's helpful.
        log.debug(theMessage: """
            -- INFO --
            The walk produced the following instructions:
            \(instructions)
            This breaks down into the following groups:
            A = \(subA)
            B = \(subB)
            C = \(subC)
            Producing the application:
            MAIN = \(main)
            """)

        // Construct the application
        var application = ""
        application += main + "\n"                          // MAIN
        application += subA.joined(separator: ",") + "\n"   // A
        application += subB.joined(separator: ",") + "\n"   // B
        application += subC.joined(separator: ",") + "\n"   // C
        application += "n\n"                                // NO VIDEO

        // Prpeare the robot
        let ascii = Functions.sToA(application)
        let vm = IntcodeVM(log: log, program: program)
        ascii.forEach { char in vm.push(char) }
        vm.memset(0, 2)

        var vmStdout = [Int]()
        loop: while (true) {
            do {
                try vm.run()
                break loop
            } catch IntcodeStatus.ioInterruptWrite {
                if let d = try? vm.pop() {
                    if d > UInt8.max {
                        // success, clear the display.
                        vmStdout.removeAll()
                    }
                    vmStdout.append(d)
                }
            } catch let error {
                log.error(theMessage: "\(error)")
                break loop
            }
        }

        if vmStdout.count > 1 {
            log.error(theMessage: Functions.aToS(vmStdout))
        } else {
            log.solution(theMessage: "The amount of space dust vacuumed is \(vmStdout.first!).")
        }
    }
}

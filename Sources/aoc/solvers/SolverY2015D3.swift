//
//  SolverY2015D3.swift
//  aoc
//
//  Created by Leif Walker-Grant on 22/10/2020.
//

import Foundation

class SolverY2015D3 : Solvable {
    let instructions: [Vector2]

    required init(withLog log: Log, andInput input: String) {
        instructions = Array(input).compactMap { c in
            switch (c) {
            case "^":
                return Vector2(x: 0, y: 1)
            case ">":
                return Vector2(x: 1, y: 0)
            case "v":
                return Vector2(x: 0, y: -1)
            case "<":
                return Vector2(x: -1, y: 0)
            default:
                log.debug(theMessage: "Found an instruction, '\(c)', that we don't understand.")
                return nil
            }
        }
    }

    func doPart1(withLog log: Log) {
        _ = timed(toLog: log) {
            var position = Vector2.zero
            var visited: Set<Vector2> = [position]

            instructions.forEach { v in
                position += v
                visited.insert(position)
                log.debug(theMessage: "Santa visits \(position).")
            }

            log.solution(theMessage: "The number of houses that received at least one gift from Santa is \(visited.count).")
        }
    }

    func doPart2(withLog log: Log) {
        _ = timed(toLog: log) {
            var posSanta = Vector2.zero
            var posRoboSanta = Vector2.zero

            // ArraySlice affords us popFirst, which returns the optional type needed for a conditional unwrap.
            var tempInstructions = ArraySlice(instructions)

            // Both actors visit the same spot, but it will only be counted once.
            var visited: Set<Vector2> = [Vector2.zero]

            while (!tempInstructions.isEmpty) {
                if let santaNextInstruction = tempInstructions.popFirst() {
                    posSanta += santaNextInstruction
                    visited.insert(posSanta)
                    log.debug(theMessage: "Santa visits \(posSanta).")
                }

                if let roboSantaNextInstruction = tempInstructions.popFirst() {
                    posRoboSanta += roboSantaNextInstruction
                    visited.insert(posRoboSanta)
                    log.debug(theMessage: "Robo-Santa visits \(posRoboSanta).")
                }
            }

            log.solution(theMessage: "The number of houses that received at least one gift from Santa or Robo-Santa present is \(visited.count).")
        }
    }
}

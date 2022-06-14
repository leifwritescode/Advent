//
//  main.swift
//  aoc
//
//  Created by Leif Walker-Grant on 19/10/2020.
//

import Foundation
import ArgumentParser

let minDay = 1
let maxDay = 25
let minYear = 2015
let maxYear = 2020

enum SolverBehaviour : String, EnumerableFlag {
    case both, first, second

    static func name(for value: SolverBehaviour) -> NameSpecification {
        return .long
    }

    static func help(for value: SolverBehaviour) -> ArgumentHelp? {
        var help: String
        switch (value) {
        case .both:
            help = "Run the complete solver."
        case .first:
            help = "Run first half of the solver only."
        case .second:
            help = "Run second half of the solver only."
        }
        return ArgumentHelp(stringLiteral: help)
    }
}

struct Aoc: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Leif Walker-Grant's Advent of Code solutions in Swift.",
        version: "v20.11",
        subcommands: [List.self, Solve.self],
        defaultSubcommand: List.self
    )
}

extension Aoc {
    struct List: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "List all available solvers."
        )

        mutating func run() throws {
            for year in minYear...maxYear {
                print("Event Year \(year):")

                var list = [String]()
                for day in minDay...maxDay {
                    let fqcn = "aoc.SolverY\(year)D\(day)"
                    if let cls = NSClassFromString(fqcn) as? Solvable.Type {
                        list.append("\tDay \(day): \(cls.description).")
                    }
                }

                if list.count != 0 {
                    list.forEach { s in print(s) }
                } else {
                    print("\tNone.")
                }

                print("")
            }
        }
    }
}

extension Aoc {
    struct Solve: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Run a solver."
        )

        @Option(name: .shortAndLong, help: "The year from which to run a puzzle solver, between \(minYear) and \(maxYear) inclusive.")
        var year: Int = minYear

        @Option(name: .shortAndLong, help: "The day for which to run the puzzle solver, between \(minDay) and \(maxDay) inclusive.")
        var day: Int = minDay

        @Flag(exclusivity: FlagExclusivity.exclusive)
        var behaviour: SolverBehaviour = .both

        @Flag(name: .shortAndLong, help: "Include additional debug information in puzzle solver output.")
        var verbose = false

        mutating func validate() throws {
            guard Array(minYear...maxYear).contains(year) else {
                throw ValidationError("'<year>' must be between \(minYear) and \(maxYear), inclusive.")
            }

            guard Array(minDay...maxDay).contains(day) else {
                throw ValidationError("'<day>' must be between \(minDay) and \(maxDay), inclusive.");
            }
        }

        mutating func run() throws {
            let fqcn = "aoc.SolverY\(year)D\(day)"
            let dataFilePath = "data/\(year)/day\(day).in"
            let log = ConsoleLog(enableDebug: verbose)

            guard let cls = NSClassFromString(fqcn) as? Solvable.Type else {
                log.error(theMessage: "No solver was found for \(day)/12/\(year)'s puzzle.")
                return
            }

            guard var input = try? String(contentsOfFile: dataFilePath) else {
                log.error(theMessage: "Unable to read the input data file '\(dataFilePath)'.")
                return
            }

            input = input.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let solver = cls.init(withLog: log, andInput: input)

            print("Event Year \(year); Day \(day): \(cls.description).\n")

            if (behaviour == .first || behaviour == .both) {
                Functions.timed(toLog: log) {
                    solver.doPart1(withLog: log)
                }
            }

            if (behaviour == .second || behaviour == .both) {
                Functions.timed(toLog: log) {
                    solver.doPart2(withLog: log)
                }
            }
        }
    }
}

Aoc.main()

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

struct Aoc: ParsableCommand {
    @Option(name: .shortAndLong, help: "The year from which to run a puzzle solver, between \(minYear) and \(maxYear) inclusive.")
    var year: Int

    @Option(name: .shortAndLong, help: "The day for which to run the puzzle solver, between \(minDay) and \(maxDay) inclusive.")
    var day: Int

    @Flag(name: .shortAndLong, help: "Include additional debug information in puzzle solver output.")
    var verbose = false

    @Flag(name: .shortAndLong, help: "Run the first half of the solution only.")
    var first: Bool = false

    @Flag(name: .shortAndLong, help: "Run the second half of the solution only.")
    var second: Bool = false

    mutating func validate() throws {
        guard Array(minYear...maxYear).contains(year) else {
            throw ValidationError("'<year>' must be between \(minYear) and \(maxYear), inclusive.")
        }

        guard Array(minDay...maxDay).contains(day) else {
            throw ValidationError("'<day>' must be between \(minDay) and \(maxDay), inclusive.");
        }

        guard !(first && second) else {
            throw ValidationError("[--first] and [--second] are mutually exclusive.")
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

        guard let input = try? String(contentsOfFile: dataFilePath) else {
            log.error(theMessage: "Unable to read the input data file '\(dataFilePath)'.")
            return
        }

        let solver = cls.init(withLog: log, andInput: input)

        if (first || !second) {
            solver.doPart1(withLog: log)
        }

        if (second || !first) {
            solver.doPart2(withLog: log)
        }
    }
}

Aoc.main()

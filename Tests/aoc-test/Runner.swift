//
//  Runner.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 07/12/2020.
//

import XCTest
@testable import aoclib

func run(_ solver: Solvable.Type, using input: String, expecting exp1: String? = nil, and exp2: String? = nil) {
    let log = MockLog(enableDebug: false)

    if exp1 != nil {
        log.clear()
        let a = solver.init(withLog: log, andInput: input)
        a.doPart1(withLog: log)
        XCTAssertTrue(log.checkSolution(exp1!), log.message)
    }

    if exp2 != nil {
        log.clear()
        let b = solver.init(withLog: log, andInput: input)
        b.doPart2(withLog: log)
        XCTAssertTrue(log.checkSolution(exp2!), log.message)
    }
}

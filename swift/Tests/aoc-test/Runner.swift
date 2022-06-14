//
//  Runner.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 07/12/2020.
//

import XCTest
@testable import aoclib

func run(_ solver: Solvable.Type,
         using input: String,
         expecting theFirstSolution: String? = nil,
         and theSecondSolution: String? = nil) {
    let mockLog = MockLog(enableDebug: false)

    if theFirstSolution != nil {
        mockLog.clear()
        let firstSolver = solver.init(withLog: mockLog, andInput: input)
        firstSolver.doPart1(withLog: mockLog)
        XCTAssertTrue(mockLog.checkSolution(theFirstSolution!), mockLog.message)
    }

    if theSecondSolution != nil {
        mockLog.clear()
        let secondSolver = solver.init(withLog: mockLog, andInput: input)
        secondSolver.doPart2(withLog: mockLog)
        XCTAssertTrue(mockLog.checkSolution(theSecondSolution!), mockLog.message)
    }
}

func runDependent(_ solver: Solvable.Type,
                  using input: String,
                  expecting theFirstSolution: String,
                  and theSecondSolution: String) {
    let mockLog = MockLog(enableDebug: false)

    mockLog.clear()
    let theSolver = solver.init(withLog: mockLog, andInput: input)
    theSolver.doPart1(withLog: mockLog)
    XCTAssertTrue(mockLog.checkSolution(theFirstSolution), mockLog.message)

    mockLog.clear()
    theSolver.doPart2(withLog: mockLog)
    XCTAssertTrue(mockLog.checkSolution(theSecondSolution), mockLog.message)
}

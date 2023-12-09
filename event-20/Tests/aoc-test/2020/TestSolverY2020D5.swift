//
//  TestSolverY2020D5.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 07/12/2020.
//

import XCTest
@testable import aoclib

class TestSolverY2020D5: XCTestCase {
    func test_ka__e1_p1() throws {
        aoc_test.run(SolverY2020D5.self,
                     using: "BFFFBBFRRR",
                     expecting: "567")
    }

    func test_ka__e2_p1() throws {
        aoc_test.run(SolverY2020D5.self,
                     using: "FFFBBBFRRR",
                     expecting: "119")
    }

    func test_ka__e3_p1() throws {
        aoc_test.run(SolverY2020D5.self,
                     using: "BBFFBBFRLL",
                     expecting: "820")
    }

    func test_ka__e4_p1p2() throws {
        aoc_test.run(SolverY2020D5.self,
                     using: """
                        BBFFBBFRLL
                        BBFFBBFRRL
                        """,
                     expecting: "822",
                     and: "821")
    }
}

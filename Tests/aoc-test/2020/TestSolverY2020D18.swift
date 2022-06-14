//
//  TestSolverY2020D18.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 18/12/2020.
//

import XCTest
@testable import aoclib

class TestSolverY2020D18: XCTestCase {
    func test_ka__e1_p1p2() throws {
        aoc_test.run(SolverY2020D18.self,
                     using: """
                     1 + 2 * 3 + 4 * 5 + 6
                     """,
                     expecting: "71",
                     and: "231")
    }

    func test_ka__e2_p1p2() throws {
        aoc_test.run(SolverY2020D18.self,
                     using: """
                     1 + (2 * 3) + (4 * (5 + 6))
                     """,
                     expecting: "51",
                     and: "51")
    }

    func test_ka__e3_p1p2() throws {
        aoc_test.run(SolverY2020D18.self,
                     using: """
                     2 * 3 + (4 * 5)
                     """,
                     expecting: "26",
                     and: "46")
    }

    func test_ka__e4_p1p2() throws {
        aoc_test.run(SolverY2020D18.self,
                     using: """
                     5 + (8 * 3 + 9 + 3 * 4 * 3)
                     """,
                     expecting: "437",
                     and: "1445")
    }

    func test_ka__e5_p1p2() throws {
        aoc_test.run(SolverY2020D18.self,
                     using: """
                     5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))
                     """,
                     expecting: "12240",
                     and: "669060")
    }

    func test_ka__e6_p1p2() throws {
        aoc_test.run(SolverY2020D18.self,
                     using: """
                     ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
                     """,
                     expecting: "13632",
                     and: "23340")
    }
}

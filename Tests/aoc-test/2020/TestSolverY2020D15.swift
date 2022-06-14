//
//  TestSolverY2020D15.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 11/12/2020.
//

import XCTest
@testable import aoclib

class TestSolverY2020D15: XCTestCase {
    func test_ka__e1_p1p2() throws {
        aoc_test.run(SolverY2020D15.self,
                using: """
                0,3,6
                """,
                expecting: "436")
    }

    func test_ka__e2_p1p2() throws {
        aoc_test.run(SolverY2020D15.self,
                using: """
                1,3,2
                """,
                expecting: "1")
    }

    func test_ka__e3_p1p2() throws {
        aoc_test.run(SolverY2020D15.self,
                using: """
                2,1,3
                """,
                expecting: "10")
    }

    func test_ka__e4_p1p2() throws {
        aoc_test.run(SolverY2020D15.self,
                using: """
                1,2,3
                """,
                expecting: "27")
    }

    func test_ka__e5_p1p2() throws {
        aoc_test.run(SolverY2020D15.self,
                using: """
                2,3,1
                """,
                expecting: "78")
    }

    func test_ka__e6_p1p2() throws {
        aoc_test.run(SolverY2020D15.self,
                using: """
                3,2,1
                """,
                expecting: "438")
    }

    func test_ka__e7_p1p2() throws {
        aoc_test.run(SolverY2020D15.self,
                using: """
                3,1,2
                """,
                expecting: "1836")
    }
}

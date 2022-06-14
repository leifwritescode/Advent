//
//  TestSolverY2020D13.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 11/12/2020.
//

import XCTest
@testable import aoclib

class TestSolverY2020D13: XCTestCase {
    func test_ka__e1_p1() throws {
        aoc_test.run(SolverY2020D13.self,
                using: """
                939
                7,13,x,x,59,x,31,19
                """,
                expecting: "295")
    }

    func test_ka__e1_p2() throws {
        aoc_test.run(SolverY2020D13.self,
                using: """
                939
                7,13,x,x,59,x,31,19
                """,
                expecting: nil,
                and: "1068781")
    }

    func test_ka__e2_p2() throws {
        aoc_test.run(SolverY2020D13.self,
                using: """
                939
                17,x,13,19
                """,
                expecting: nil,
                and: "3417")
    }

    func test_ka__e3_p2() throws {
        aoc_test.run(SolverY2020D13.self,
                using: """
                939
                67,7,59,61
                """,
                expecting: nil,
                and: "754018")
    }

    func test_ka__e4_p2() throws {
        aoc_test.run(SolverY2020D13.self,
                using: """
                939
                67,x,7,59,61
                """,
                expecting: nil,
                and: "779210")
    }

    func test_ka__e5_p2() throws {
        aoc_test.run(SolverY2020D13.self,
                using: """
                939
                67,7,x,59,61
                """,
                expecting: nil,
                and: "1261476")
    }

    func test_ka__e6_p2() throws {
        aoc_test.run(SolverY2020D13.self,
                using: """
                939
                1789,37,47,1889
                """,
                expecting: nil,
                and: "1202161486")
    }
}

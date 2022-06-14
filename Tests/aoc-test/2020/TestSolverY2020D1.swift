//
//  TestSolverY2020D1.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 07/12/2020.
//

import XCTest
@testable import aoclib

class TestSolverY2020D1: XCTestCase {
    func test_ka__e1_p1p2() throws {
        aoc_test.run(SolverY2020D1.self,
                using: """
                1721
                979
                366
                299
                675
                1456
                """,
                expecting: "514579",
                and: "241861950")
    }
}

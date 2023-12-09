//
//  TestSolverY2020D12.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 11/12/2020.
//

import XCTest
@testable import aoclib

class TestSolverY2020D12: XCTestCase {
    func test_ka__e1_p1() throws {
        aoc_test.run(SolverY2020D12.self,
                using: """
                F10
                N3
                F7
                R90
                F11
                """,
                expecting: "25")
    }

    func test_ka__e1_p2() throws {
        aoc_test.run(SolverY2020D12.self,
                using: """
                F10
                N3
                F7
                R90
                F11
                """,
                expecting: nil,
                and: "286")
    }
}

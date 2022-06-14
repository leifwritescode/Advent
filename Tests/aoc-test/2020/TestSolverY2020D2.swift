//
//  TestSolverY2020D2.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 07/12/2020.
//

import XCTest
@testable import aoclib

class TestSolverY2020D2: XCTestCase {
    func test_ka__e1_p1p2() throws {
        aoc_test.run(SolverY2020D2.self,
                using: """
                1-3 a: abcde
                1-3 b: cdefg
                2-9 c: ccccccccc
                """,
                expecting: "2",
                and: "1")
    }
}

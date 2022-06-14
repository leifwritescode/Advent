//
//  TestSolverY2020D14.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 11/12/2020.
//

import XCTest
@testable import aoclib

class TestSolverY2020D14: XCTestCase {
    func test_ka__e1_p1() throws {
        aoc_test.run(SolverY2020D14.self,
                using: """
                mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
                mem[8] = 11
                mem[7] = 101
                mem[8] = 0
                """,
                expecting: "165")
    }

    func test_ka__e1_p2() throws {
        aoc_test.run(SolverY2020D14.self,
                using: """
                mask = 000000000000000000000000000000X1001X
                mem[42] = 100
                mask = 00000000000000000000000000000000X0XX
                mem[26] = 1
                """,
                expecting: nil,
                and: "208")
    }
}

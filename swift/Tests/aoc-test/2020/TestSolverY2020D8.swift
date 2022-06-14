//
//  TestSolverY2020D8.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 07/12/2020.
//

import XCTest
@testable import aoclib

class TestSolverY2020D8: XCTestCase {
    func test_ka__e1_p1p2() throws {
        aoc_test.run(SolverY2020D8.self,
                using: """
                nop +0
                acc +1
                jmp +4
                acc +3
                jmp -3
                acc -99
                acc +1
                jmp -4
                acc +6
                """,
                expecting: "5",
                and: "8")
    }
}

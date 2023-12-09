//
//  TestSolverY2020D9.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 09/12/2020.
//

import XCTest
@testable import aoclib

class TestSolverY2020D9: XCTestCase {
    func test_ka__e2m_p1p2() throws {
        aoc_test.runDependent(SolverY2020D9.self,
                using: """
                4
                12
                22
                17
                14
                19
                13
                24
                6
                21
                8
                1
                11
                16
                23
                18
                3
                10
                2
                9
                7
                15
                5
                20
                25
                102
                """,
                expecting: "102",
                and: "204")
    }
}

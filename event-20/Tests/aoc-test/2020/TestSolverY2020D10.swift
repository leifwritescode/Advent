//
//  TestSolverY2020D10.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 10/12/2020.
//

import XCTest
@testable import aoclib

class TestSolverY2020D10: XCTestCase {
    func test_ka__e1_p1() throws {
        aoc_test.run(SolverY2020D10.self,
                using: """
                16
                10
                15
                5
                1
                11
                7
                19
                6
                12
                4
                """,
                expecting: "35")
    }

    func test_ka__e2_p1() throws {
        aoc_test.run(SolverY2020D10.self,
                using: """
                28
                33
                18
                42
                31
                14
                46
                20
                48
                47
                24
                23
                49
                45
                19
                38
                39
                11
                1
                32
                25
                35
                8
                17
                7
                9
                4
                2
                34
                10
                3
                """,
                expecting: "220")
    }

    func test_ka__e1_p2() throws {
        aoc_test.run(SolverY2020D10.self,
                using: """
                16
                10
                15
                5
                1
                11
                7
                19
                6
                12
                4
                """,
                expecting: nil, // don't run part 1 for this
                and: "8")
    }

    func test_ka__e2_p2() throws {
        aoc_test.run(SolverY2020D10.self,
                using: """
                28
                33
                18
                42
                31
                14
                46
                20
                48
                47
                24
                23
                49
                45
                19
                38
                39
                11
                1
                32
                25
                35
                8
                17
                7
                9
                4
                2
                34
                10
                3
                """,
                expecting: nil, // don't run part 1 for this
                and: "19208")
    }
}

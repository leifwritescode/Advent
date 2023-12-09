//
//  TestSolverY2020D6.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 06/12/2020.
//

import XCTest
@testable import aoclib

class TestSolverY2020D6: XCTestCase {
    func test_ka__e1_p1p2() throws {
        aoc_test.run(SolverY2020D6.self,
                     using: """
                        abc

                        a
                        b
                        c

                        ab
                        ac

                        a
                        a
                        a
                        a

                        b
                        """,
                    expecting: "11",
                    and: "6")
    }
}

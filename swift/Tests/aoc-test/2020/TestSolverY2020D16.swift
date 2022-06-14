//
//  TestSolverY2020D16.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 16/12/2020.
//

import XCTest
@testable import aoclib

class TestSolverY2020D16: XCTestCase {
    func test_ka__e1_p1() throws {
        aoc_test.run(SolverY2020D16.self,
                     using: """
                     class: 1-3 or 5-7
                     row: 6-11 or 33-44
                     seat: 13-40 or 45-50

                     your ticket:
                     7,1,14

                     nearby tickets:
                     7,3,47
                     40,4,50
                     55,2,20
                     38,6,12
                     """,
                     expecting: "71")
    }

    func test_ka__e2_p2() throws {
        // Uses a modified version of example 2.
        aoc_test.run(SolverY2020D16.self,
                     using: """
                     departure class: 0-1 or 4-19
                     row: 0-5 or 8-19
                     departure seat: 0-13 or 16-19

                     your ticket:
                     11,12,13

                     nearby tickets:
                     3,9,18
                     15,1,5
                     5,14,9
                     """,
                     expecting: nil,
                     and: "156")
    }
}

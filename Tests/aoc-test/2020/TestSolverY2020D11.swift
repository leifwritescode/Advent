//
//  TestSolverY2020D11.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 11/12/2020.
//

import XCTest
@testable import aoclib

class TestSolverY2020D11: XCTestCase {
    func test_ka__e1_p1() throws {
        aoc_test.run(SolverY2020D11.self,
                using: """
                L.LL.LL.LL
                LLLLLLL.LL
                L.L.L..L..
                LLLL.LL.LL
                L.LL.LL.LL
                L.LLLLL.LL
                ..L.L.....
                LLLLLLLLLL
                L.LLLLLL.L
                L.LLLLL.LL
                """,
                expecting: "37")
    }

    func test_ka__e1_p2() throws {
        aoc_test.run(SolverY2020D11.self,
                using: """
                L.LL.LL.LL
                LLLLLLL.LL
                L.L.L..L..
                LLLL.LL.LL
                L.LL.LL.LL
                L.LLLLL.LL
                ..L.L.....
                LLLLLLLLLL
                L.LLLLLL.L
                L.LLLLL.LL
                """,
                expecting: nil,
                and: "26")
    }
}

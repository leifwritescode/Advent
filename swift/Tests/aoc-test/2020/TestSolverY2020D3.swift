//
//  TestSolverY2020D3.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 07/12/2020.
//

import XCTest
@testable import aoclib

class TestSolverY2020D3: XCTestCase {
    func test_ka__e1_p1p2() throws {
        aoc_test.run(SolverY2020D3.self,
                using: """
                ..##.......
                #...#...#..
                .#....#..#.
                ..#.#...#.#
                .#...##..#.
                ..#.##.....
                .#.#.#....#
                .#........#
                #.##...#...
                #...##....#
                .#..#...#.#
                """,
                expecting: "7",
                and: "336")
    }
}

//
//  TestSolverY2020D21.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 21/12/2020.
//

import XCTest
@testable import aoclib

class TestSolverY2020D21: XCTestCase {
    func test_ka__e1_p1p2() throws {
        aoc_test.run(SolverY2020D21.self,
                     using: """
                     mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
                     trh fvjkl sbzzf mxmxvkd (contains dairy)
                     sqjhc fvjkl (contains soy)
                     sqjhc mxmxvkd sbzzf (contains fish)
                     """,
                     expecting: "5",
                     and: "mxmxvkd,sqjhc,fvjkl")
    }
}

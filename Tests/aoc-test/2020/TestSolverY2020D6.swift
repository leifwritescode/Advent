//
//  TestSolverY2020D6.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 06/12/2020.
//

import XCTest

class TestSolverY2020D6: XCTestCase {
    let log = MockLog(enableDebug: false)

    func testExample1() throws {
        XCTAssertNoThrow() {
            let solver = SolverY2020D6(withLog: self.log, andInput: "abc\n\na\nb\nc\n\nab\nac\n\na\na\na\na")

            self.log.clear()
            solver.doPart1(withLog: self.log)
            XCTAssertTrue(self.log.checkSolution("11"))

            self.log.clear()
            solver.doPart2(withLog: self.log)
            XCTAssertTrue(self.log.checkSolution("6"))
        }
    }
}

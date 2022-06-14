//
//  TestSolverY2020D5.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 07/12/2020.
//

import XCTest

class TestSolverY2020D5: XCTestCase {
    let log = MockLog(enableDebug: false)

    func testPart1Example1() throws {
        XCTAssertNoThrow() {
            let solver = SolverY2020D5(withLog: self.log, andInput: "BFFFBBFRRR")

            self.log.clear()
            solver.doPart1(withLog: self.log)
            XCTAssertTrue(self.log.checkSolution("567"))
        }
    }

    func testPart1Example2() throws {
        XCTAssertNoThrow() {
            let solver = SolverY2020D5(withLog: self.log, andInput: "FFFBBBFRRR")

            self.log.clear()
            solver.doPart1(withLog: self.log)
            XCTAssertTrue(self.log.checkSolution("119"))
        }
    }

    func testPart1Example3() throws {
        XCTAssertNoThrow() {
            let solver = SolverY2020D5(withLog: self.log, andInput: "BBFFBBFRLL")

            self.log.clear()
            solver.doPart1(withLog: self.log)
            XCTAssertTrue(self.log.checkSolution("820"))
        }
    }

    func testPart2Example1() throws {
        XCTAssertNoThrow() {
            let solver = SolverY2020D5(withLog: self.log, andInput: "BBFFBBFRLL\nBBFFBBFRRL")

            self.log.clear()
            solver.doPart2(withLog: self.log)
            XCTAssertTrue(self.log.checkSolution("821"))
        }
    }
}

//
//  TestIntcodeVM.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 13/11/2020.
//

import XCTest
@testable import aoc

class TestIntcodeVM: XCTestCase {
    let log = ConsoleLog(enableDebug: true)

    func variantWrite(_ program: [Int], _ expected: Int) throws {
        // Arrange
        let vm = IntcodeVM(log: log, program: program)

        // Act
        XCTAssertThrowsError(try vm.run()) { (err) in
            XCTAssertEqual((err as! IntcodeStatus), IntcodeStatus.ioInterruptWrite)
        }
        var actual = 0
        XCTAssertNoThrow(actual = try vm.pop())

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func variantNoThrow(_ program: [Int], _ expected: Int) throws {
        // Arrange
        let vm = IntcodeVM(log: log, program: program)

        // Act
        var actual = 0
        XCTAssertNoThrow(actual = try vm.run())

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func variantThrows(_ program: [Int], _ expected: IntcodeStatus) throws {
        // Arrange
        let vm = IntcodeVM(log: log, program: program)

        // Act + Assert
        XCTAssertThrowsError(try vm.run()) { (err) in
            XCTAssertEqual((err as! IntcodeStatus), expected)
        }
    }

    func variantParameterMode(_ progImm: [Int], _ progPos: [Int], _ progRel: [Int]) throws {
        // Arrange
        let expected1 = 111
        let vm1 = IntcodeVM(log: log, program: progImm)
        let expected2 = 100
        let vm2 = IntcodeVM(log: log, program: progPos)
        let expected3 = 300
        let vm3 = IntcodeVM(log: log, program: progRel)

        // Act
        var actual1 = 0
        XCTAssertNoThrow(actual1 = try vm1.run())
        var actual2 = 0
        XCTAssertNoThrow(actual2 = try vm2.run())
        var actual3 = 0
        XCTAssertNoThrow(actual3 = try vm3.run())

        // Assert
        XCTAssertEqual(actual1, expected1)
        XCTAssertEqual(actual2, expected2)
        XCTAssertEqual(actual3, expected3)
    }

    func testAddition() throws {
        try variantNoThrow([1, 5, 6, 0, 99, 10, 20], 30)
    }

    func testMultiplication() throws {
        try variantNoThrow([2, 5, 6, 0, 99, 10, 20], 200)
    }

    func testWriteMemoryWithSinglePush() throws {
        // Arrange
        let expected = 30
        let vm = IntcodeVM(log: log, program: [3, 0, 99])
        vm.push(expected)

        // Act
        var actual = 0
        XCTAssertNoThrow(actual = try vm.run())

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func testMultipleWriteMemoryWithSinglePushThrows() throws {
        // Arrange
        let vm = IntcodeVM(log: log, program: [3, 0, 3, 0, 99])
        vm.push(30)

        // Act + Assert
        XCTAssertThrowsError(try vm.run()) { (err) in
            XCTAssertEqual((err as! IntcodeStatus), IntcodeStatus.ioInterruptRead)
        }
    }

    func testIfNoPushWriteMemoryThrows() throws {
        try variantThrows([3, 0, 99], IntcodeStatus.ioInterruptRead)
    }

    func testSingleReadMemoryWithSinglePop() throws {
        try variantWrite([4, 0, 99], 4)
    }

    func testSingleReadMemoryWithMultiplePopsThrows() throws {
        // Arrange
        let expected = 4
        let vm = IntcodeVM(log: log, program: [4, 0, 99])

        // Act
        XCTAssertThrowsError(try vm.run()) { (err) in
            XCTAssertEqual((err as! IntcodeStatus), IntcodeStatus.ioInterruptWrite)
        }
        var actual = 0
        XCTAssertNoThrow(actual = try vm.pop())

        // Assert
        XCTAssertEqual(actual, expected)
        XCTAssertThrowsError(try vm.pop()) { (err) in
            XCTAssertEqual((err as! IntcodeStatus), IntcodeStatus.outputIsEmpty)
        }
    }

    func testIfNoReadMemoryPopThrows() throws {
        // Arrange
        let vm = IntcodeVM(log: log, program: [99])

        // Act
        XCTAssertNoThrow(try vm.run())

        // Assert
        XCTAssertThrowsError(try vm.pop()) { (err) in
            XCTAssertEqual((err as! IntcodeStatus), IntcodeStatus.outputIsEmpty)
        }
    }

    func testJumpIfNotZeroJumps() throws {
        try variantWrite([5, 11, 9, 4, 1, 99, 4, 0, 99, 6, 0, 1], 5)
    }

    func testJumpIfNotZeroDoesNotJump() throws {
        try variantWrite([5, 10, 9, 4, 1, 99, 4, 0, 99, 6, 0, 1], 10)
    }

    func testJumpIfZeroJumps() throws {
        try variantWrite([6, 10, 9, 4, 1, 99, 4, 0, 99, 6, 0, 1], 6)
    }

    func testJumpIfZeroDoesNotJump() throws {
        try variantWrite([6, 11, 9, 4, 1, 99, 4, 0, 99, 6, 0, 1], 11)
    }

    func testLessThan() throws {
        try variantNoThrow([7, 1, 2, 0, 99], 1)
    }

    func testNotLessThan() throws {
        try variantNoThrow([7, 1, 3, 0, 99], 0)
    }

    func testEqual() throws {
        try variantNoThrow([8, 1, 1, 0, 99], 1)
    }

    func testNotEqual() throws {
        try variantNoThrow([8, 1, 3, 0, 99], 0)
    }

    func testRelativeBaseOffset() throws {
        try variantNoThrow([9, 7, 201, 0, 0, 0, 99, 6], 108)
    }

    func testUnknownOpCodeThrows() throws {
        try variantThrows([90], IntcodeStatus.unrecognisedOpcode(90))
    }

    func testResumeAfterReadMemory() throws {
        // Arrange
        let expected = 1000
        let vm = IntcodeVM(log: log, program: [3, 0, 4, 0, 99])

        // Act
        XCTAssertThrowsError(try vm.run()) { (err) in
            XCTAssertEqual((err as! IntcodeStatus), IntcodeStatus.ioInterruptRead)
        }
        vm.push(expected)
        XCTAssertThrowsError(try vm.run()) { (err) in
            XCTAssertEqual((err as! IntcodeStatus), IntcodeStatus.ioInterruptWrite)
        }
        var actual = 0
        XCTAssertNoThrow(actual = try vm.pop())

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func testFirstParameterMode() throws {
        try variantParameterMode(
            [101, 10, 0, 0, 99],
            [1, 4, 0, 0, 99],
            [9, 7, 201, 0, 2, 0, 99, 6])
    }

    func testSecondParameterMode() throws {
        try variantParameterMode(
            [1001, 0, -890, 0, 99],
            [1, 0, 4, 0, 99],
            [9, 7, 2001, 2, 1, 0, 99, 7, -1701])
    }

    func testThirdParameterMode() throws {
        try variantParameterMode(
            [10001, 5, 4, 0, 99, 12],
            [1, 4, 0, 0, 99],
            [9, 7, 20001, 2, 8, -6, 99, 6, -19701])
    }

    func testSelfReplication() throws {
        // Arrange
        let expected = [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]
        let vm = IntcodeVM(log: log, program: expected)

        // Act
        var actual = [Int]()
        loop: while (true) {
            do {
                try vm.run()
                break loop
            } catch IntcodeStatus.ioInterruptWrite {
                actual.append(try vm.pop())
                continue
            } catch {
                XCTFail()
            }
        }

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func test64BitOutput() throws {
        try variantWrite([104, 1125899906842624, 99], 1125899906842624)
    }

    func test64BitArithmetic() throws {
        try variantWrite([1102, 34915192, 34915192, 7, 4, 7, 99, 0], 1219070632396864)
    }

    func testBOOST() throws {
        // Arrange
        let expected = [3241900951]
        let boost = [
            1102,34463338,34463338,63,1007,63,34463338,63,1005,63,53,1101,0,3,1000,109,988,209,12,9,
            1000,209,6,209,3,203,0,1008,1000,1,63,1005,63,65,1008,1000,2,63,1005,63,904,1008,1000,0,
            63,1005,63,58,4,25,104,0,99,4,0,104,0,99,4,17,104,0,99,0,0,1102,1,29,1011,1102,1,27,1009,
            1101,23,0,1008,1101,0,25,1017,1102,1,36,1016,1101,0,31,1018,1102,35,1,1012,1101,28,0,1004,
            1101,779,0,1024,1102,403,1,1026,1101,0,33,1010,1102,37,1,1015,1101,32,0,1014,1101,0,752,
            1023,1101,0,30,1013,1102,21,1,1001,1102,1,1,1021,1102,1,34,1002,1102,400,1,1027,1101,0,22,
            1007,1102,1,567,1028,1101,558,0,1029,1102,26,1,1006,1102,39,1,1005,1102,1,0,1020,1101,0,
            38,1000,1101,0,755,1022,1102,1,770,1025,1102,1,24,1003,1102,20,1,1019,109,28,21107,40,41,
            -9,1005,1019,199,4,187,1106,0,203,1001,64,1,64,1002,64,2,64,109,-30,2107,38,7,63,1005,63,
            221,4,209,1105,1,225,1001,64,1,64,1002,64,2,64,109,-5,2102,1,8,63,1008,63,21,63,1005,63,
            251,4,231,1001,64,1,64,1106,0,251,1002,64,2,64,109,21,1207,-7,21,63,1005,63,267,1105,1,
            273,4,257,1001,64,1,64,1002,64,2,64,109,-1,1201,-7,0,63,1008,63,29,63,1005,63,293,1106,0,
            299,4,279,1001,64,1,64,1002,64,2,64,109,-4,1202,-3,1,63,1008,63,28,63,1005,63,319,1106,0,
            325,4,305,1001,64,1,64,1002,64,2,64,109,14,1206,-3,343,4,331,1001,64,1,64,1106,0,343,1002,
            64,2,64,109,-14,2108,21,-8,63,1005,63,361,4,349,1105,1,365,1001,64,1,64,1002,64,2,64,109,
            -9,1201,9,0,63,1008,63,27,63,1005,63,391,4,371,1001,64,1,64,1106,0,391,1002,64,2,64,109,
            27,2106,0,0,1106,0,409,4,397,1001,64,1,64,1002,64,2,64,109,-20,2101,0,0,63,1008,63,22,63,
            1005,63,431,4,415,1105,1,435,1001,64,1,64,1002,64,2,64,109,-7,1202,7,1,63,1008,63,22,63,
            1005,63,457,4,441,1105,1,461,1001,64,1,64,1002,64,2,64,109,8,1208,0,23,63,1005,63,479,4,
            467,1106,0,483,1001,64,1,64,1002,64,2,64,109,20,1205,-8,495,1105,1,501,4,489,1001,64,1,64,
            1002,64,2,64,109,-26,1208,4,28,63,1005,63,521,1001,64,1,64,1105,1,523,4,507,1002,64,2,64,
            109,15,21102,41,1,-2,1008,1015,41,63,1005,63,545,4,529,1106,0,549,1001,64,1,64,1002,64,2,
            64,109,18,2106,0,-7,4,555,1001,64,1,64,1106,0,567,1002,64,2,64,109,-30,1207,-3,35,63,1005,
            63,585,4,573,1105,1,589,1001,64,1,64,1002,64,2,64,109,14,1206,2,605,1001,64,1,64,1106,0,
            607,4,595,1002,64,2,64,109,-3,1205,5,621,4,613,1106,0,625,1001,64,1,64,1002,64,2,64,109,
            -5,21107,42,41,2,1005,1013,645,1001,64,1,64,1106,0,647,4,631,1002,64,2,64,109,-11,2108,42,
            5,63,1005,63,663,1106,0,669,4,653,1001,64,1,64,1002,64,2,64,109,4,21102,43,1,9,1008,1013,
            40,63,1005,63,693,1001,64,1,64,1106,0,695,4,675,1002,64,2,64,109,-1,2107,22,-2,63,1005,63,
            715,1001,64,1,64,1106,0,717,4,701,1002,64,2,64,109,7,21101,44,0,0,1008,1010,45,63,1005,63,
            741,1001,64,1,64,1106,0,743,4,723,1002,64,2,64,109,9,2105,1,4,1106,0,761,4,749,1001,64,1,
            64,1002,64,2,64,109,10,2105,1,-5,4,767,1001,64,1,64,1105,1,779,1002,64,2,64,109,-22,21108,
            45,43,10,1005,1017,799,1001,64,1,64,1105,1,801,4,785,1002,64,2,64,109,16,21101,46,0,-8,
            1008,1015,46,63,1005,63,827,4,807,1001,64,1,64,1105,1,827,1002,64,2,64,109,-7,2101,0,-7,63,
            1008,63,29,63,1005,63,851,1001,64,1,64,1106,0,853,4,833,1002,64,2,64,109,-5,2102,1,-3,63,
            1008,63,22,63,1005,63,877,1001,64,1,64,1106,0,879,4,859,1002,64,2,64,109,9,21108,47,47,-5,
            1005,1015,897,4,885,1105,1,901,1001,64,1,64,4,64,99,21102,27,1,1,21101,0,915,0,1105,1,922,
            21201,1,61784,1,204,1,99,109,3,1207,-2,3,63,1005,63,964,21201,-2,-1,1,21101,942,0,0,1105,1,
            922,22102,1,1,-1,21201,-2,-3,1,21102,1,957,0,1106,0,922,22201,1,-1,-2,1105,1,968,22101,0,
            -2,-2,109,-3,2105,1,0
        ]
        let vm = IntcodeVM(log: log, program: boost)
        vm.push(1)

        // Act
        var actual = [Int]()
        loop: while (true) {
            do {
                try vm.run()
                break loop
            } catch IntcodeStatus.ioInterruptWrite {
                actual.append(try vm.pop())
                continue
            } catch {
                XCTFail()
            }
        }

        // Assert
        XCTAssertEqual(actual, expected)
    }
}

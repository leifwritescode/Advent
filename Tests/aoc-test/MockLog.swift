//
//  MockLog.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 06/12/2020.
//

import Foundation

class MockLog : Log {
    private var lastSolution: String

    required init(enableDebug: Bool) {
        lastSolution = ""
    }
    func log(theMessage message: String, inCategory category: LogCategory) {
        if (category == .Solution) {
            lastSolution = message
        }
    }

    func checkSolution(_ result: String) -> Bool {
        lastSolution.contains(result)
    }

    func clear() {
        lastSolution = ""
    }
}

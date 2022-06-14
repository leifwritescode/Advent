//
//  MockLog.swift
//  aoc-test
//
//  Created by Leif Walker-Grant on 06/12/2020.
//

import Foundation
@testable import aoclib

class MockLog : Log {
    private var lastSolution: String?

    var message: String { get { lastSolution ?? "No solution was found." } }

    required init(enableDebug: Bool) {
        lastSolution = nil
    }

    func log(theMessage message: String, inCategory category: LogCategory) {
        if (category == .Solution) {
            lastSolution = message
        }
    }

    func checkSolution(_ result: String) -> Bool {
        return lastSolution?.matches("\\b\(result)\\b") ?? false
    }

    func clear() {
        lastSolution = nil
    }
}

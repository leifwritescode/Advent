//
//  ConsoleLog.swift
//  aoc
//
//  Created by Leif Walker-Grant on 19/10/2020.
//

import Foundation
import Rainbow
import aoclib

class ConsoleLog : Log {
    let debug: Bool

    required init (enableDebug: Bool = false) {
        self.debug = enableDebug
    }

    func log(theMessage message: String, inCategory category: LogCategory = .Info) -> Void {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSSS"
        let output = "[\(formatter.string(from: Date()))] \(message)"

        switch category {
        case .Debug:
            if (debug) { print(output) }
        case .Info:
            print(debug ? output.cyan : output)
        case .Solution:
            print(output.bold.lightGreen.bold)
        case .Error:
            print(output.bold.red.bold)
        }
    }
}

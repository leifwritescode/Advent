//
//  Log.swift
//  aoc
//
//  Created by Leif Walker-Grant on 19/10/2020.
//

public enum LogCategory {
    case Debug
    case Info
    case Error
    case Solution
}

public protocol Log {
    init(enableDebug: Bool)

    func log(theMessage message: String, inCategory category: LogCategory) -> Void;
}

public extension Log{
    func debug(theMessage message: String) -> Void {
        log(theMessage: message, inCategory: .Debug)
    }

    func info(theMessage message: String) -> Void {
        log(theMessage: message, inCategory: .Info)
    }

    func error(theMessage message: String) -> Void {
        log(theMessage: message, inCategory: .Error)
    }

    func solution(theMessage message: String) -> Void {
        log(theMessage: message, inCategory: .Solution)
    }
}

//
//  Array.swift
//  aoc
//
//  Created by Leif Walker-Grant on 13/11/2020.
//

import Foundation

extension Array {
    mutating func popFirst() -> Element? {
        return isEmpty ? nil : removeFirst()
    }
}

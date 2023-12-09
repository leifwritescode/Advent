//
//  Bool.swift
//  aoc
//
//  Created by Leif Walker-Grant on 02/12/2020.
//

import Foundation

extension Bool {
    static func ^ (lhs: Bool, rhs: Bool) -> Bool {
        return lhs != rhs
    }
}

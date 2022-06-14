//
//  Dictionary.swift
//  aoc
//
//  Created by Leif Walker-Grant on 15/11/2020.
//

import Foundation

extension Dictionary where Value: Equatable {
    func key(forValue value: Value) -> Key? {
        return self.first { _, v in v == value }?.key
    }
}

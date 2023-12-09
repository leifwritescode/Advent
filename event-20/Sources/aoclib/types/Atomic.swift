//
//  Atomic.swift
//  aoc
//
//  Created by Leif Walker-Grant on 23/10/2020.
//

import Foundation

@propertyWrapper
struct Atomic<Type> {
    private let queue: DispatchQueue = DispatchQueue(label: "Atomic")
    private var _value: Type

    var wrappedValue: Type {
        get {
            queue.sync { return _value }
        }
        set {
            queue.sync { _value = newValue }
        }
    }

    init (wrappedValue value: Type) {
        _value = value
    }
}

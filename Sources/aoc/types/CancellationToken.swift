//
//  CancellationToken.swift
//  aoc
//
//  Created by Leif Walker-Grant on 23/10/2020.
//

import Foundation

class CancellationToken {
    @Atomic private (set) var isCancelled: Bool = false
    
    func reset() {
        isCancelled = false
    }

    func cancel() {
        isCancelled = true
    }
}

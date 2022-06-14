//
//  Functions.swift
//  aoc
//
//  Created by Leif Walker-Grant on 23/10/2020.
//

import Foundation

func timed(toLog log: Log, _ closure: () -> Void) -> TimeInterval {
    log.debug(theMessage: "Starting timed execution.")

    let start = Date()
    closure()
    let end = Date()
    
    let delta = end.timeIntervalSince(start)
    let deltaAsString: String
    if (delta < 1) {
        deltaAsString = "<1s"
    } else {
        let f = DateComponentsFormatter()
        f.unitsStyle = .full
        f.allowedUnits = [.hour, .minute, .second]
        deltaAsString = f.string(from: delta)!
    }

    log.info(theMessage: "Done. Execution took \(deltaAsString).")
    return delta
}

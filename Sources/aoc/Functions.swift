//
//  Functions.swift
//  aoc
//
//  Created by Leif Walker-Grant on 23/10/2020.
//

import Foundation

class Functions {
    @discardableResult
    static func timed(toLog log: Log, _ closure: () -> Void) -> TimeInterval {
        log.info(theMessage: "Starting timed execution.")

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

    static func transpose1d<Type>(array: [Type], width: Int, height: Int) -> [Type] {
        guard width * height == array.count else {
            return []
        }

        let defaultValue = array[0]
        var transposed = [Type](repeating: defaultValue, count: width * height)
        for c in stride(from: 0, through: width - 1, by: 1) {
            for r in stride(from: 0, through: height - 1, by: 1) {
                transposed[c * height + r] = array[r * width + c]
            }
        }

        return transposed
    }

    /**
     transposes an 2d array of w x h to a 2d array of h x w
     */
    static func transpose2d<Type>(array: [[Type]], width: Int, height: Int) -> [[Type]] {
        guard array.count > 0 else {
            return [[]]
        }

        let arraySize = array.count * array[0].count
        guard width * height == arraySize else {
            return [[]]
        }

        // transpose the array from w x h to h x w
        let defaultValue = array[0][0]
        var transposed = [[Type]](repeating: Array(repeating: defaultValue, count: height), count: width)
        for c in stride(from: 0, through: width - 1, by: 1) {
            for r in stride(from: 0, through: height - 1, by: 1) {
                transposed[c][r] = array[r][c]
            }
        }

        return transposed
    }
}

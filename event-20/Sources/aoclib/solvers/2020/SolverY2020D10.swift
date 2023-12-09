//
//  SolverY2020D10.swift
//  aoclib
//
//  Created by Leif Walker-Grant on 10/12/2020.
//

import Foundation

class SolverY2020D10 : Solvable {
    static var description = "Adapter Array"

    let adapters: [Int]

    required init(withLog log: Log, andInput input: String) {
        var temp = [0]
        temp.append(contentsOf: input.components(separatedBy: .newlines)
            .compactMap { Int($0)! }
            .sorted())
        temp.append(temp.last! + 3)
        adapters = temp
    }

    func doPart1(withLog log: Log) {
        let eAdapters = adapters.enumerated().dropLast()
        let diffOfOne = eAdapters.filter { e in adapters[e.offset + 1] - e.element == 1 }.count
        let diffOfTwo = eAdapters.filter { e in adapters[e.offset + 1] - e.element == 3 }.count
        log.solution(theMessage: "The product of differences is \(diffOfOne * diffOfTwo)")
    }

    /*
    func countPathsDepthFirst(_ branch: Int, _ verts: [Int]) -> Int {
        if branch == adapters.last! { // last 'adapter' is the device
            return 1
        }

        var result = 0
        let children = verts.filter { v in v > branch && v <= branch + 3 }
        if !children.isEmpty { // if not the device, and no children, it's a dead end.
            result = children.reduce(0) { r, c in r + countPathsDepthFirst(c, verts.filter { v in v > c })}
        }

        return result
    }
    */

    func doPart2(withLog log: Log) {
        // Works for (small) test data, but complexity grows exponentioally. Horribly sub-optimal.
        // let count = countPathsDepthFirst(adapters.first!, adapters)

        // However, reframing the issue, there's a better way.
        // For any given adapter there are at most three adapters that can connect to it.
        // The total possible combinations to reach the same is the sum of the combinations to reach any of the three which lead to it.
        // As a result, discounting the first (as we know it's 1), each subsequent adapter n in combinations C can be described as
        // C[n] = C[n - 1] + C[n - 2] + C[n - 3]
        // The problem space, therefore, is a geometric series similar to the tribonacci sequence, just with some 'undefined' terms.
        var C = [Int:Int]()
        C[0] = 1
        adapters.dropFirst().forEach { n in
            C[n] = (C[n - 1] ?? 0) + (C[n - 2] ?? 0) + (C[n - 3] ?? 0)
        }
        log.solution(theMessage: "The maximum combinations is \(C[adapters.last!]!).")
    }
}

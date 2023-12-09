//
//  SolverY2019D7.swift
//  aoc
//
//  Created by Leif Walker-Grant on 13/11/2020.
//

import Foundation

class SolverY2019D7 : Solvable {
    static var description = "Amplification Circuit"

    let program: [Int]

    required init(withLog log: Log, andInput input: String) {
        program = input.split(separator: ",").compactMap { i in Int(i)! }
    }

    func doPart1(withLog log: Log) {
        let variants = [
            [0,1,2,3,4],[0,1,2,4,3],[0,1,3,2,4],[0,1,3,4,2],[0,1,4,2,3],[0,1,4,3,2],[0,2,1,3,4],[0,2,1,4,3],[0,2,3,1,4],[0,2,3,4,1],[0,2,4,1,3],[0,2,4,3,1],
            [0,3,1,2,4],[0,3,1,4,2],[0,3,2,1,4],[0,3,2,4,1],[0,3,4,1,2],[0,3,4,2,1],[0,4,1,2,3],[0,4,1,3,2],[0,4,2,1,3],[0,4,2,3,1],[0,4,3,1,2],[0,4,3,2,1],
            [1,0,2,3,4],[1,0,2,4,3],[1,0,3,2,4],[1,0,3,4,2],[1,0,4,2,3],[1,0,4,3,2],[1,2,0,3,4],[1,2,0,4,3],[1,2,3,0,4],[1,2,3,4,0],[1,2,4,0,3],[1,2,4,3,0],
            [1,3,0,2,4],[1,3,0,4,2],[1,3,2,0,4],[1,3,2,4,0],[1,3,4,0,2],[1,3,4,2,0],[1,4,0,2,3],[1,4,0,3,2],[1,4,2,0,3],[1,4,2,3,0],[1,4,3,0,2],[1,4,3,2,0],
            [2,0,1,3,4],[2,0,1,4,3],[2,0,3,1,4],[2,0,3,4,1],[2,0,4,1,3],[2,0,4,3,1],[2,1,0,3,4],[2,1,0,4,3],[2,1,3,0,4],[2,1,3,4,0],[2,1,4,0,3],[2,1,4,3,0],
            [2,3,0,1,4],[2,3,0,4,1],[2,3,1,0,4],[2,3,1,4,0],[2,3,4,0,1],[2,3,4,1,0],[2,4,0,1,3],[2,4,0,3,1],[2,4,1,0,3],[2,4,1,3,0],[2,4,3,0,1],[2,4,3,1,0],
            [3,0,1,2,4],[3,0,1,4,2],[3,0,2,1,4],[3,0,2,4,1],[3,0,4,1,2],[3,0,4,2,1],[3,1,0,2,4],[3,1,0,4,2],[3,1,2,0,4],[3,1,2,4,0],[3,1,4,0,2],[3,1,4,2,0],
            [3,2,0,1,4],[3,2,0,4,1],[3,2,1,0,4],[3,2,1,4,0],[3,2,4,0,1],[3,2,4,1,0],[3,4,0,1,2],[3,4,0,2,1],[3,4,1,0,2],[3,4,1,2,0],[3,4,2,0,1],[3,4,2,1,0],
            [4,0,1,2,3],[4,0,1,3,2],[4,0,2,1,3],[4,0,2,3,1],[4,0,3,1,2],[4,0,3,2,1],[4,1,0,2,3],[4,1,0,3,2],[4,1,2,0,3],[4,1,2,3,0],[4,1,3,0,2],[4,1,3,2,0],
            [4,2,0,1,3],[4,2,0,3,1],[4,2,1,0,3],[4,2,1,3,0],[4,2,3,0,1],[4,2,3,1,0],[4,3,0,1,2],[4,3,0,2,1],[4,3,1,0,2],[4,3,1,2,0],[4,3,2,0,1],[4,3,2,1,0]
        ]
        var signals = Array(repeating: 0, count: variants.count)

        DispatchQueue.concurrentPerform(iterations: variants.count) { i in
            let variant = variants[i]
            var signal = 0
            do {
                for j in variant {
                    var io = [j, signal]
                    let vm = IntcodeVM(log: log, program: program)
                    loop: while (true) {
                        do {
                            try vm.run()
                            break loop
                        } catch IntcodeStatus.ioInterruptRead {
                            vm.push(io.removeFirst())
                        } catch IntcodeStatus.ioInterruptWrite {
                            signal = try vm.pop()
                        }
                    }
                }

                signals[i] = signal
                log.info(theMessage: "The final signal was \(signal) for amp circuit #\(i + 1).")
            } catch let error {
                log.error(theMessage: "The vm crashed with error: '\(error).'")
            }
        }

        let maxSignal = signals.max()
        log.solution(theMessage: "The strongest signal was \(maxSignal!).")
    }

    func doPart2(withLog log: Log) {
        let variants = [
            [5,6,7,8,9],[5,6,7,9,8],[5,6,8,7,9],[5,6,8,9,7],[5,6,9,7,8],[5,6,9,8,7],[5,7,6,8,9],[5,7,6,9,8],[5,7,8,6,9],[5,7,8,9,6],[5,7,9,6,8],[5,7,9,8,6],
            [5,8,6,7,9],[5,8,6,9,7],[5,8,7,6,9],[5,8,7,9,6],[5,8,9,6,7],[5,8,9,7,6],[5,9,6,7,8],[5,9,6,8,7],[5,9,7,6,8],[5,9,7,8,6],[5,9,8,6,7],[5,9,8,7,6],
            [6,5,7,8,9],[6,5,7,9,8],[6,5,8,7,9],[6,5,8,9,7],[6,5,9,7,8],[6,5,9,8,7],[6,7,5,8,9],[6,7,5,9,8],[6,7,8,5,9],[6,7,8,9,5],[6,7,9,5,8],[6,7,9,8,5],
            [6,8,5,7,9],[6,8,5,9,7],[6,8,7,5,9],[6,8,7,9,5],[6,8,9,5,7],[6,8,9,7,5],[6,9,5,7,8],[6,9,5,8,7],[6,9,7,5,8],[6,9,7,8,5],[6,9,8,5,7],[6,9,8,7,5],
            [7,5,6,8,9],[7,5,6,9,8],[7,5,8,6,9],[7,5,8,9,6],[7,5,9,6,8],[7,5,9,8,6],[7,6,5,8,9],[7,6,5,9,8],[7,6,8,5,9],[7,6,8,9,5],[7,6,9,5,8],[7,6,9,8,5],
            [7,8,5,6,9],[7,8,5,9,6],[7,8,6,5,9],[7,8,6,9,5],[7,8,9,5,6],[7,8,9,6,5],[7,9,5,6,8],[7,9,5,8,6],[7,9,6,5,8],[7,9,6,8,5],[7,9,8,5,6],[7,9,8,6,5],
            [8,5,6,7,9],[8,5,6,9,7],[8,5,7,6,9],[8,5,7,9,6],[8,5,9,6,7],[8,5,9,7,6],[8,6,5,7,9],[8,6,5,9,7],[8,6,7,5,9],[8,6,7,9,5],[8,6,9,5,7],[8,6,9,7,5],
            [8,7,5,6,9],[8,7,5,9,6],[8,7,6,5,9],[8,7,6,9,5],[8,7,9,5,6],[8,7,9,6,5],[8,9,5,6,7],[8,9,5,7,6],[8,9,6,5,7],[8,9,6,7,5],[8,9,7,5,6],[8,9,7,6,5],
            [9,5,6,7,8],[9,5,6,8,7],[9,5,7,6,8],[9,5,7,8,6],[9,5,8,6,7],[9,5,8,7,6],[9,6,5,7,8],[9,6,5,8,7],[9,6,7,5,8],[9,6,7,8,5],[9,6,8,5,7],[9,6,8,7,5],
            [9,7,5,6,8],[9,7,5,8,6],[9,7,6,5,8],[9,7,6,8,5],[9,7,8,5,6],[9,7,8,6,5],[9,8,5,6,7],[9,8,5,7,6],[9,8,6,5,7],[9,8,6,7,5],[9,8,7,5,6],[9,8,7,6,5]
        ]
        var signals = Array(repeating: 0, count: variants.count)

        for i in 0..<variants.count {
            let variant = variants[i]
            var vms = [IntcodeVM]()

            for j in 0..<variant.count {
                vms.append(IntcodeVM(log: log, program: program))
                vms[j].push(variant[j])
            }
            vms[0].push(0)

            var tempSignals = [Int]()
            log.info(theMessage: "Dispatching variation \(i + 1).")
            DispatchQueue.concurrentPerform(iterations: variant.count) { k in
                loop: while (true) {
                    do {
                        try vms[k].run()
                        break loop
                    } catch IntcodeStatus.ioInterruptRead {
                        // wait until a signal is received
                    } catch IntcodeStatus.ioInterruptWrite {
                        // push into the next vm in series
                        if let sig = try? vms[k].pop() {
                            tempSignals.append(sig)
                            vms[(k + 1) % variant.count].push(sig)
                        }
                    } catch let error {
                        log.error(theMessage: "\(error)")
                        break loop
                    }
                }
            }

            signals.append(tempSignals.max()!)
        }

        let maxSignal = signals.max()
        log.solution(theMessage: "The strongest signal from the feedback loop was \(maxSignal!).")
    }
}

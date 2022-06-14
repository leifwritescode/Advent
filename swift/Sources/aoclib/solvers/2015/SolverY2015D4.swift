//
//  SolverY2015D4.swift
//  aoc
//
//  Created by Leif Walker-Grant on 22/10/2020.
//

import Foundation

class SolverY2015D4 : Solvable {
    static var description = "The Ideal Stocking Stuffer"

    private let sema: DispatchSemaphore
    private let secretKey: String

    private let cToken: CancellationToken = CancellationToken()
    private let atomic = DispatchQueue(label: "Suffix")
    private let queue = DispatchQueue(label: "Solver", attributes: .concurrent)
    private let group = DispatchGroup()
    @Atomic private var suffix: Int = Int.max

    required init(withLog log: Log, andInput input: String) {
        secretKey = input
        sema = DispatchSemaphore(value: ProcessInfo().activeProcessorCount)
    }

    private func doTaskQueued(prefix: String, log: Log, start: Int, offset: Int) {
        log.debug(theMessage: "Spawning thread for range \(start) ... \(start + offset).")

        queue.async {
            self.group.enter()

            if (!self.cToken.isCancelled) {
                for value in start ... (start + offset) {
                    let digest = (self.secretKey + String(value)).MD5
                    if (digest.starts(with: prefix)) {
                        self.cToken.cancel()
                        self.suffix = value
                        break
                    }
                }
                log.debug(theMessage: "Finished testing range \(start) ... \(start + offset).")
            } else {
                log.error(theMessage: "Cancelling thread spawn for range \(start) ... \(start + offset).")
            }

            self.sema.signal()
            self.group.leave()
        }
    }

    private func doTask(withPrefix prefix: String, andLog log: Log, searchRange: Int) {
        if #available(OSX 10.15, *) {
            var currOffset = 1

            suffix = Int.max
            cToken.reset()

            repeat {
                sema.wait()

                doTaskQueued(prefix: prefix,
                             log: log,
                             start: currOffset,
                             offset: searchRange)

                currOffset += searchRange
            } while !cToken.isCancelled

            log.info(theMessage: "A solution is available. Waiting for remaining solvers to finish, as a smaller solution may be found.")
            group.wait()

            log.solution(theMessage: "The lowest possible number to produce a digest beginning with \(prefix) is \(suffix).")
        } else {
            log.error(theMessage: "SolverY2015D4 cannot be run on macOS < 10.15.")
        }
    }

    func doPart1(withLog log: Log) {
        doTask(withPrefix: "00000", andLog: log, searchRange: 10000)
    }

    func doPart2(withLog log: Log) {
        doTask(withPrefix: "000000", andLog: log, searchRange: 10000)
    }
}

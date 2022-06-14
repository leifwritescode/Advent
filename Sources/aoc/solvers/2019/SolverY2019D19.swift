//
//  SolverY2019D19.swift
//  aoc
//
//  Created by Leif Walker-Grant on 15/11/2020.
//

import Foundation

class SolverY2019D19 : Solvable {
    static var description = "Tractor Beam"

    let program: [Int]

    required init(withLog log: Log, andInput input: String) {
        program = input.split(separator: ",").compactMap { i in Int(i)! }
    }

    func r2d(_ rad: Float) -> Float {
        return rad * 180 / .pi
    }

    func doPart1(withLog log: Log) {
        var world = [Coordinate:Bool]()
        let w = 50, h = 50

        let queue = DispatchQueue(label: "aoc_synch_world")
        DispatchQueue.concurrentPerform(iterations: w * h) { index in
            let coord = Coordinate(index % w, index / w)
            let res = scanCoord(coord, log)
            _ = queue.sync {
                world.updateValue(res, forKey: coord)
            }
        }

        let affected = world.values.filter { v in v }.count
        log.solution(theMessage: "The number of points affected by the tractor beam is \(affected).")

        for y in 0..<h {
            var str = ""
            for x in 0..<w {
                if let val = world[Coordinate(x, y)] {
                    str += val ? "#" : "."
                }
            }
            log.info(theMessage: str)
        }
    }

    func scanCoord(_ coord: Coordinate, _ log: Log) -> Bool {
        var res = false
        let vm = IntcodeVM(log: log, program: program)
        vm.push(coord.x)
        vm.push(coord.y)
        loop: while (true) {
            do {
                try vm.run()
                break loop
            } catch IntcodeStatus.ioInterruptWrite {
                if let pulled = try? vm.pop() {
                    res = pulled != 0
                }
            } catch let error {
                log.error(theMessage: "\(error)")
                break loop
            }
        }
        return res
    }

    func doPart2(withLog log: Log) {
        var x2 = 0, y1 = 0
        while !scanCoord(Coordinate(x2 + 99, y1), log) { // scan each row until the right-top extent fits
            y1 += 1
            while !scanCoord(Coordinate(x2, y1 + 99), log) { // scan each column till the left-bottom extent fits
                x2 += 1
            }
        }
        log.solution(theMessage: "The sum of x * 10000 + y is \(x2*10000+y1).")
    }
}

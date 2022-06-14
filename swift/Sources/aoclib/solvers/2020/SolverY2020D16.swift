//
//  SolverY2020D16.swift
//  aoclib
//
//  Created by Leif Walker-Grant on 16/12/2020.
//

import Foundation

class SolverY2020D16 : Solvable {
    static var description = "Ticket Translation"

    let ranges: [String:Set<Int>]
    let myTicket: [Int]
    let tickets: [[Int]]

    required init(withLog log: Log, andInput input: String) {
        var sections = input.components(separatedBy: .newlines).split(separator: "")

        ranges = sections.removeFirst()
            .reduce([String:Set<Int>]()) { dict, line in
            var dict = dict
            let groups = line.groups(for: #"([\w\s]+):\s(\d+)-(\d+)\sor\s(\d+)-(\d+)"#).first!
            dict[groups[0]] = Set(Array(Int(groups[1])!...Int(groups[2])!) + Array(Int(groups[3])!...Int(groups[4])!))
            return dict
        }

        myTicket = sections.removeFirst()
            .last!
            .split(separator: ",")
            .compactMap { s in Int(s)! }

        tickets = sections.removeFirst()
            .dropFirst()
            .compactMap { a in a.split(separator: ",").compactMap { s in Int(s)! } }
    }

    func doPart1(withLog log: Log) {
        let error = tickets.enumerated().reduce(0) { tErr, ticket in
            tErr + ticket.element.reduce(0) { err, field in
                err + (ranges.allSatisfy { _, v in !v.contains(field) } ? field : 0)
            }
        }
        log.solution(theMessage: "The error rate is \(error).")
    }

    func doPart2(withLog log: Log) {
        log.info(theMessage: "Filtering invalid tickets...")
        let candidates = tickets.filter { ticket in
            // Filter out any ticket with a value that satisfies no field constraints.
            ticket.filter { value in ranges.allSatisfy { _, v in !v.contains(value) }}.isEmpty
        }
        log.info(theMessage: "Done!")

        // Track the assigned fields.
        var assigned = [(String, Int)]()

        // Cache the column enumerators.
        var columns = [EnumeratedSequence<[Int]>]()
        for i in 0..<candidates.first!.count {
            columns.append(candidates.reduce([Int]()) { r, a in r + [a[i]] }.enumerated())
        }

        var cycle = 1
        outer: while assigned.count != ranges.count {
            log.info(theMessage: "Starting reduction cycle \(cycle).")
            // Create a set of the unassigned fields.
            var unassigned = Set(ranges.keys).subtracting(assigned.compactMap { $0.0 })
            // Create a set of all columns, then subtract all assigned columns and iterate.
            let range = Set(0..<candidates.first!.count).subtracting(assigned.compactMap { $0.1 })
            inner: for i in range {
                // Get an iterator from the cached columns
                var iter = columns[i].makeIterator()
                var curr = iter.next()
                while curr != nil {
                    // Find all potential fields for this row, and intersect with the unassigned fields.
                    // The result is potential fields that all processed rows can be.
                    let potentials = ranges.filter { k, v in v.contains(curr!.element) }
                    unassigned = unassigned.intersection(potentials.keys)

                    // Once unassigned has been reduced to just one value, we've got our answer for the column.
                    if unassigned.count == 1 {
                        // Log, record, break to the outer loop.
                        log.info(theMessage: "Finished. Position #\(i + 1) encodes \(unassigned.first!).")
                        assigned.append((unassigned.first!, i))
                        break inner
                    }

                    // Investigate the next row.
                    curr = iter.next()
                }
            }

            // If the assignment count isn't equal to the present cycle, we've gone wrong.
            if assigned.count != cycle {
                log.error(theMessage: "No new field was encoded!")
                break outer
            }

            log.debug(theMessage: "Assigned: \(assigned).")
            cycle += 1
        }

        let result = assigned
            .filter { $0.0.contains("departure") }
            .reduce(1) { r, e in r * myTicket[e.1] }
        log.solution(theMessage: "The product of departure values is \(result).")
    }
}

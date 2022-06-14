//
//  SolverY2016D4.swift
//  aoc
//
//  Created by Leif Walker-Grant on 28/10/2020.
//

import Foundation

fileprivate class Room {
    let encryptedName: String
    let sectorId: Int
    let checksum: String

    init (_ c: String, _ n: String, _ cs: String) {
        encryptedName = c
        sectorId = Int(n) ?? 0
        checksum = cs
    }

    func isChecksumValid(_ log: Log) -> Bool {
        let aCode = String(encryptedName.filter { e in e != "-" }.sorted())
            .splitOnNewCharacter()
            .sorted { a, b in a.count > b.count }
            .prefix(checksum.count)
            .compactMap { s in String(s.first!) }
            .joined()

        let isValid = aCode == checksum
        log.debug(theMessage: "The computed checksum of '\(encryptedName)' is '\(aCode).' It is \(isValid ? "valid" : "invalid").")
        return isValid
    }

    func decrypt(_ log: Log) -> String {
        let decrypted = encryptedName.utf8.compactMap { e in
            if e == UnicodeScalar("-").value {
                return " "
            } else {
                let v = (Int(e) - 97 + sectorId) % 26
                return String(UnicodeScalar(v + 97)!)
            }
        }.joined()
        log.debug(theMessage: "The string '\(encryptedName)' decrypts to '\(decrypted).'")
        return decrypted
    }
}

class SolverY2016D4 : Solvable {
    private var rooms: [Room]

    required init(withLog log: Log, andInput input: String) {
        let tRooms = input.groups(for: #"(\w.+)-(\d.+)\[(\w.+)\]"#)
        rooms = tRooms.compactMap { line in
            Room(line[0], line[1], line[2])
        }.filter { r in
            r.isChecksumValid(log)
        }
    }

    func doPart1(withLog log: Log) {
        _ = timed(toLog: log) {
            var sum = 0
            rooms.forEach { room in
                sum += room.sectorId
            }
            log.solution(theMessage: "The sum of the sectorIds of real rooms is \(sum).")
        }
    }

    func doPart2(withLog log: Log) {
        _ = timed(toLog: log) {
            let name = "northpole object storage"
            if let room = rooms.first(where: { r in r.decrypt(log) == name }) {
                log.solution(theMessage: "The north pole objects are stored in sector ID \(room.sectorId).")
            } else {
                log.error(theMessage: "No north pole object storage was found.")
            }
        }
    }
}

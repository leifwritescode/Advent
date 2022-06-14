//
//  SolverY2020D4.swift
//  aoc
//
//  Created by Leif Walker-Grant on 04/12/2020.
//

import Foundation

fileprivate class Validator {
    let required: Bool
    let validate: (String) -> Bool

    init(_ required: Bool, _ validator: @escaping (String) -> Bool) {
        self.required = required
        self.validate = validator
    }
}

class SolverY2020D4 : Solvable {
    static var description = "Passport Processing"

    var passports = [[String:String]]()
    fileprivate let fields = [
        "byr": Validator(true, {s in
            let i = Int(s)!
            return Functions.clamp(i, 1920, 2002) == i
        }),
        "iyr": Validator(true, {s in
            let i = Int(s)!
            return Functions.clamp(i, 2010, 2020) == i
        }),
        "eyr": Validator(true, {s in
            let i = Int(s)!
            return Functions.clamp(i, 2020, 2030) == i
        }),
        "hgt": Validator(true, {s in
            if s.matches(#"(\d+)(cm|in)"#) {
                let groups = s.groups(for: #"(\d+)(cm|in)"#).first!
                let num = Int(groups[0])!
                let unit = groups[1]
                switch (unit) {
                    case "cm":
                        return Functions.clamp(num, 150, 193) == num
                    case "in":
                        return Functions.clamp(num, 59, 76) == num
                    default:
                        return false
                }
            }
            return false
        }),
        "hcl": Validator(true, {s in
            s.matches(#"#[0-9a-f]{6}"#)
        }),
        "ecl": Validator(true, {s in
            s.matches(#"(amb|blu|brn|gry|grn|hzl|oth){1}"#)
        }),
        "pid": Validator(true, {s in
            s.matches(#"^[0-9]{9}$"#)
        }),
        "cid": Validator(false, {s in
            true
        })
    ]

    required init(withLog log: Log, andInput input: String) {
        var currPassport = [String:String]()
        input.components(separatedBy: .newlines).forEach { line in
            if (line.isEmpty) {
                passports.append(currPassport)
                currPassport = [String:String]()
            } else {
                line.groups(for: #"(\w{3}):([\w#]+)[\s\r\n]?"#).forEach { grp in
                    currPassport.updateValue(grp[1], forKey: grp[0])
                }
            }
        }
        passports.append(currPassport)
    }

    func doPart1(withLog log: Log) {
        let valid = passports.filter { passport in
            fields.allSatisfy { field in
                return !field.value.required || passport.keys.contains(field.key)
            }
        }.count
        log.solution(theMessage: "There are \(valid) valid passports.")
    }

    func doPart2(withLog log: Log) {
        let valid = passports.filter { passport in
            fields.allSatisfy { field in
                if field.value.required {
                 return passport.keys.contains(field.key) && field.value.validate(passport[field.key]!)
                }
                return true
            }
        }.count
        log.solution(theMessage: "There are \(valid) valid passports.")
    }
}

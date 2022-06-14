//
//  String.swift
//  aoc
//
//  Created by Leif Walker-Grant on 24/10/2020.
//

import Foundation
import CryptoKit

extension String {
    func groups(for regexPattern: String) throws -> [String] {
        let regex = try NSRegularExpression(pattern: regexPattern)
        let matches = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
 
        if (matches.isEmpty) {
            return []
        }

        let match = matches[0]
        return (1..<match.numberOfRanges).map {
            let rangeBounds = match.range(at: $0)
            guard let range = Range(rangeBounds, in: self) else {
                return ""
            }
            return String(self[range])
        }
    }

    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression) != nil
    }

    var MD5: String {
        var result = ""
        if #available(OSX 10.15, *) {
            result = Insecure.MD5
                .hash(data: self.data(using: .utf8)!)
                .map { String(format: "%02hhx", $0) }
                .joined()
        }
        return result
    }
}

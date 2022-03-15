//
//  File.swift
//  
//
//  Created by ILIYA on 30.10.2021.
//

import Foundation

public struct Suffix {
    public var suffix: String
    public var count: Int
    public var description: String {
        return "\(suffix) - \(count)"
    }
}

extension Suffix: Hashable {
    public static func == (lhs: Suffix, rhs: Suffix) -> Bool {
        return lhs.suffix == rhs.suffix && lhs.count == rhs.count
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(suffix)
        hasher.combine(count)
    }
}

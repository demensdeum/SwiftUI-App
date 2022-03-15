//
//  File.swift
//  
//
//  Created by ILIYA on 31.10.2021.
//

import Foundation

public struct SuffixArray {
    public let string: String
    lazy var suffixes: [String] = {
        var suffixes: [String] = []
        let sequence = SuffixSequence(string: self.string)
        for suffix in sequence {
            suffixes.append(String(suffix))
        }
        return suffixes
    }()
}

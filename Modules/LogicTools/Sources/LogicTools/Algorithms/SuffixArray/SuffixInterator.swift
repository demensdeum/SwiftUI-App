//
//  File.swift
//  
//
//  Created by ILIYA on 31.10.2021.
//

import Foundation

struct SuffixIterator: IteratorProtocol {
    private let string: String
    private var start: String.Index
    private var end: String.Index
    
    init(string: String) {
        self.string = string
        self.start = string.startIndex
        self.end = string.endIndex
    }
    
    mutating func next() -> Substring? {
        guard start < end else { return nil }
        let substring = string[start..<end]
        string.formIndex(after: &start)
        return substring
    }
}

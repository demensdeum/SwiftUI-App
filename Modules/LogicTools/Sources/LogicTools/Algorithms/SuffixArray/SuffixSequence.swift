//
//  File.swift
//  
//
//  Created by ILIYA on 31.10.2021.
//

import Foundation

struct SuffixSequence: Sequence {
    let string: String
    func makeIterator() -> SuffixIterator {
        return SuffixIterator(string: string)
    }
}

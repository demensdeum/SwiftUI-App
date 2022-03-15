//
//  File.swift
//  
//
//  Created by ILIYA on 31.10.2021.
//

import Foundation

public extension String {
    func suffixes() -> [String] {
        var suffixesArray = SuffixArray(string: self)
        return suffixesArray.suffixes
    }
}

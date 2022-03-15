//
//  File.swift
//  
//
//  Created by ILIYA on 30.10.2021.
//

import Foundation

// suffixesAsc, suffixesDesc, top10threeCharactersSuffixes, moreThanThreeSymbolsSuffixes, moreThanThreeSymbolsSuffixesInfo
public typealias SuffixesTextParserCompletion = (([Suffix], [Suffix], [Suffix], [Suffix], String, TimeInterval)->())

public class SuffixesTextParser {
    
    public init() {}
    
    public func parse(
        text: String,
        searchText: String,
        completion: SuffixesTextParserCompletion?
    ) {
        let rawSuffixes = parseSuffixesIn(text: text)
        let searchText = searchText.uppercased()
        var suffixes = rawSuffixes
        if searchText.count > 0 {
            suffixes = rawSuffixes.filter { $0.suffix.uppercased().contains(searchText) }
        }
        
        let suffixesGrouped = Dictionary(
            grouping: suffixes,
            by: { $0.count }
        )
        let sortedKeys: [Int] = Array(suffixesGrouped.keys).sorted { $0 < $1 }
        var suffixesAsc: [Suffix] = []
        for key in sortedKeys {
            let sortedSuffixes = suffixesGrouped[key]?.sorted { $0.suffix < $1.suffix }
            guard let sortedSuffixes = sortedSuffixes, sortedSuffixes.count > 0 else { continue }
            suffixesAsc.append(contentsOf: sortedSuffixes)
        }
        let suffixesDesc = Array(suffixesAsc.reversed())
        
        let threeCharactersSuffixes = suffixesDesc.filter{ $0.suffix.count == 3 }
        let top10threeCharactersSuffixes = Array(threeCharactersSuffixes.prefix(10))
        
        let moreThanThreeSymbolsSuffixes = suffixesDesc.filter { $0.suffix.count > 3 }
        let moreThanThreeSymbolsSuffixesInfo: String = Array(moreThanThreeSymbolsSuffixes.prefix(3)).compactMap { $0.description }.joined(separator: " ")
        debugPrint(moreThanThreeSymbolsSuffixesInfo)
        completion?(
            suffixesAsc,
            suffixesDesc,
            top10threeCharactersSuffixes,
            moreThanThreeSymbolsSuffixes,
            moreThanThreeSymbolsSuffixesInfo,
            0
        )
    }
    
    private func parseSuffixesIn(text: String) -> [Suffix] {
        let words = text.components(separatedBy: " ")
        var suffixesToCountMap: [String : Int] = [:]
        for word in words {
            let suffixes = word.suffixes()
            suffixes.forEach { suffix in
                let count: Int = suffixesToCountMap[suffix] ?? 0
                suffixesToCountMap[suffix] = count + 1
            }
        }
        let suffixes = suffixesToCountMap.map { Suffix(suffix: $0, count: $1) }
        return suffixes
    }
}

//
//  File.swift
//  
//
//  Created by ILIYA on 10.11.2021.
//

import Foundation

public class SuffixesTextParserJob: Job {
    
    private let parser: SuffixesTextParser = .init()
    private let text: String
    private let searchText: String
    private let completion: SuffixesTextParserCompletion
    private var startDate: Date?
    
    public init(
        text: String,
        searchText: String,
        completion: @escaping SuffixesTextParserCompletion
    )
    {
        self.text = text
        self.searchText = searchText
        self.completion = completion
    }
    
    public func perform(completion: (() -> ())?) {
        startDate = Date()
        parser.parse(
            text: text,
            searchText: searchText) { [weak self]
                suffixesAsc,
                suffixesDesc,
                top10threeCharactersSuffixes,
                moreThanThreeSymbolsSuffixes,
                moreThanThreeSymbolsSuffixesInfo,
                timeDiff in
                
                DispatchQueue.main.async { [weak self] in
                    guard let startDate = self?.startDate else { return }
                    let timeDiff = Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
                    self?.completion(
                        suffixesAsc,
                        suffixesDesc,
                        top10threeCharactersSuffixes,
                        moreThanThreeSymbolsSuffixes,
                        moreThanThreeSymbolsSuffixesInfo,
                        timeDiff
                    )
                    completion?()
                }
            }
    }
}

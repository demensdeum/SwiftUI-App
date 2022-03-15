//
//  File.swift
//  
//
//  Created by ILIYA on 10.11.2021.
//

import Foundation
import SwiftUI

class SearchHistory: ObservableObject {
    @Published var feed: [(String, TimeInterval)] = [] {
        didSet {
            sortedFeed = feed.sorted { $0.1 < $1.1 } 
        }
    }
    @Published var sortedFeed: [(String, TimeInterval)] = []
    
    func add(_ item: (String, TimeInterval)) {
        guard feed.contains(where: { $0.0 == item.0 }) == false else { return }
        guard item.0.count > 0 else { return }
        feed.append(item)
    }
}


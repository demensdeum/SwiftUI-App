//
//  File.swift
//  
//
//  Created by ILIYA on 10.11.2021.
//

import Foundation
import SwiftUI

public struct SearchHistoryScreen: View {
    
    @ObservedObject var viewModel: SearchHistoryViewModel
    
    public var body: some View {
        VStack {
            Text("Search History")
            if viewModel.searchHistory.sortedFeed.count > 0 {
                List {
                    ForEach(Array($viewModel.searchHistory.sortedFeed.enumerated()), id: \.element.0.wrappedValue) { index, element in
                        Text("\(element.0.wrappedValue) - \(element.1.wrappedValue)")
                            .foregroundColor(index > viewModel.searchHistory.sortedFeed.count / 2 ? Color.red : Color.green)
                    }
                }
            }
            else {
                Text("No items in search")
            }
        }
    }
    
}

class SearchHistoryViewModel: ObservableObject {
    @ObservedObject var searchHistory: SearchHistory
    
    init(searchHistory: SearchHistory) {
        self.searchHistory = searchHistory
    }
}

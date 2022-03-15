//
//  File.swift
//
//
//  Created by ILIYA on 29.10.2021.
//

import Foundation
import SwiftUI
import LogicTools
import Core
import Combine

struct TextInputScreen: View
{
    @ObservedObject var textObserver: TextFieldObserver
    @StateObject var viewModel: TextInputScreenViewModel
    var body: some View {
        VStack {
            Picker("Picker", selection: $viewModel.selectedTab) {
                Text("Suffixes Viewer")
                    .tag(TextInputScreenTabs.suffixesViewer)
                Text("Top 10 Three Characters")
                    .tag(TextInputScreenTabs.top10threeCharactersSuffixes)
            }
            .pickerStyle(.segmented)
            
            switch $viewModel.selectedTab.wrappedValue {
            case .suffixesViewer:
                Picker("Order", selection: $viewModel.selectedOrder) {
                    Text("ASC")
                        .tag(TextInputScreenOrder.asc)
                    Text("DESC")
                        .tag(TextInputScreenOrder.desc)
                }
                .pickerStyle(.segmented)
                VStack {
                    List {
                        switch viewModel.selectedOrder {
                        case .asc:
                            ForEach($viewModel.suffixesAsc, id: \.self) {
                                let title = "\($0.suffix.wrappedValue) \($0.count.wrappedValue)"
                                Text(title)
                            }
                        case .desc:
                            ForEach($viewModel.suffixesDesc, id: \.self) {
                                let title = "\($0.suffix.wrappedValue) \($0.count.wrappedValue)"
                                Text(title)
                            }
                        }
                        if $viewModel.suffixesAsc.count < 1 {
                            Text("0 result")
                        }
                    }
                }
            case .top10threeCharactersSuffixes:
                List {
                    ForEach($viewModel.top10threeCharactersSuffixes, id: \.self) {
                        let title = "\($0.suffix.wrappedValue) \($0.count.wrappedValue)"
                        Text(title)
                    }
                }
            }
            Text("Text:")
            TextField("Text", text: $textObserver.text)
                .padding(64)
            TextField("Search", text: $textObserver.searchText)
                .padding(64)
        }
    }
}

enum TextInputScreenOrder {
    case asc
    case desc
}

enum TextInputScreenTabs {
    case suffixesViewer
    case top10threeCharactersSuffixes
}

class TextInputScreenViewModel: ObservableObject {
    private let jobScheduler: JobScheduler = .init()
    private let suffixesTextParser = SuffixesTextParser()
    @ObservedObject private var searchHistory: SearchHistory
    @Published var searchText: String  = "" {
        didSet {
            parse(text: text, searchText: searchText)
        }
    }
    @Published var text: String = "" {
        didSet {
            parse(text: text, searchText: searchText)
        }
    }
    @Published var selectedTab: TextInputScreenTabs
    @Published var suffixesAsc: [Suffix] = []
    @Published var suffixesDesc: [Suffix] = []
    @Published var top10threeCharactersSuffixes: [Suffix] = []
    @Published var moreThanThreeSymbolsSuffixes: [Suffix] = []
    @Published var selectedOrder: TextInputScreenOrder = .desc
    
    init(
        selectedTab: TextInputScreenTabs,
        searchHistory: SearchHistory
    ) {
        self.selectedTab = selectedTab
        self.searchHistory = searchHistory
    }
    
    private func parse(
        text: String,
        searchText: String
    )
    {
        let job = SuffixesTextParserJob(
            text: text,
            searchText: searchText) { [weak self]
                suffixesAsc,
                suffixesDesc,
                top10threeCharactersSuffixes,
                moreThanThreeSymbolsSuffixes,
                moreThanThreeSymbolsSuffixesInfo,
                timeDiff in
                
                self?.suffixesAsc = suffixesAsc
                self?.suffixesDesc = suffixesDesc
                self?.top10threeCharactersSuffixes = top10threeCharactersSuffixes
                self?.moreThanThreeSymbolsSuffixes = moreThanThreeSymbolsSuffixes
                
                debugPrint(timeDiff)
                
                let userDefaults = UserDefaults(
                    suiteName: "group.com.demensdeum.swiftuiapp"
                )
                
                userDefaults?.set(
                    moreThanThreeSymbolsSuffixesInfo,
                    forKey: "moreThanThreeSymbolsSuffixesInfo"
                )
                
                self?.searchHistory.add((searchText, timeDiff))
            }
        jobScheduler.add(job: job)
    }
}

class TextFieldObserver : ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var debouncedSearchText = ""
    @Published var searchText = ""
    
    @Published var debouncedText = ""
    @Published var text = ""
    
    init(viewModel: TextInputScreenViewModel) {
        $text
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newValue in
                self?.debouncedText = newValue
                viewModel.text = newValue
            } )
            .store(in: &subscriptions)
        
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newValue in
                self?.debouncedSearchText = newValue
                viewModel.searchText = newValue
            } )
            .store(in: &subscriptions)
    }
}


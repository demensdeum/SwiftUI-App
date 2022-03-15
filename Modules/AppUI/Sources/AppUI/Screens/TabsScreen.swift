//
//  TabsScreen.swift
//  SwiftUI-App
//
//  Created by ILIYA on 29.09.2021.
//

import SwiftUI
import UITools
import Core

public enum TabsScreenTabs: String {
    case API
    case customNavigation
    case textInput
    case searchHistory
    case mlScreen
}

public struct TabsScreen: View {
    public var apiPickerTemporaryData: ApiPickerTemporaryData
    @ObservedObject var viewModel: TabsScreenViewModel = .init()
    
    public init(
        apiPickerTemporaryData: ApiPickerTemporaryData
    )
    {
        self.apiPickerTemporaryData = apiPickerTemporaryData
    }
    
    public var body: some View {
        VStack {
            TabView(selection: $viewModel.selectedTab) {
                ApiPickerScreen(
                    viewModel: ApiPickerScreenViewModel(
                        apiPickerTemporaryData: apiPickerTemporaryData
                    )
                )
                    .tabItem {
                        Image(systemName: "network")
                        Text("API")
                    }
                    .tag(TabsScreenTabs.API.rawValue)
                CustomNavScreen()
                    .tabItem {
                        Image(systemName: "car")
                        Text("Custom Navigation")
                    }
                    .tag(TabsScreenTabs.customNavigation.rawValue)
                TextInputScreen(
                    textObserver: TextFieldObserver(viewModel: viewModel.textInputScreenViewModel),
                    viewModel: viewModel.textInputScreenViewModel
                )
                    .tabItem {
                        Image(systemName: "book")
                        Text("Text Input")
                    }
                    .tag(TabsScreenTabs.textInput.rawValue)
                SearchHistoryScreen(
                    viewModel: SearchHistoryViewModel(
                        searchHistory: viewModel.searchHistory
                    )
                )
                    .tabItem {
                        Image(systemName: "eye")
                        Text("Search History")
                    }
                    .tag(TabsScreenTabs.searchHistory.rawValue)
                MLScreen()
                    .tabItem {
                        Image(systemName: "moon.zzz")
                        Text("ML Screen")
                    }
                    .tag(TabsScreenTabs.mlScreen.rawValue)
            }
        }
        .onOpenURL { url in
            let absoluteString = url.absoluteString
            let selectedTab = String(absoluteString.dropFirst(7))
            debugPrint(selectedTab)
            viewModel.selectedTab = selectedTab
        }
    }
}

class TabsScreenViewModel: ObservableObject {
    @Published public var selectedTab: String = TabsScreenTabs.API.rawValue
    @Published private(set) var searchHistory: SearchHistory
    
    var textInputScreenViewModel: TextInputScreenViewModel
    
    init() {
        let searchHistory = SearchHistory()
        self.searchHistory = searchHistory
        textInputScreenViewModel = TextInputScreenViewModel(
            selectedTab: .suffixesViewer,
            searchHistory: searchHistory
        )
    }
}

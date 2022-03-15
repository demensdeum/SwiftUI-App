//
//  ApiScreen.swift
//  SwiftUI-App
//
//  Created by ILIYA on 19.09.2021.
//

import SwiftUI
import Core

struct ApiPickerScreen: View {
    @ObservedObject var viewModel: ApiPickerScreenViewModel
    var body: some View {
        VStack {
            Picker("News", selection: $viewModel.selectedArticlesScreenViewModel) {
                ForEach($viewModel.articelsViewModels, id: \.self) {
                    Text($0.name.wrappedValue).tag($0.name.wrappedValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            ArticlesScreen(
                viewModel: viewModel.selectedArticlesScreenViewModel
            )
        }
    }
}

public class ApiPickerTemporaryData {
    @Published public var selectedArticlesTabName: String
    
    public init(selectedArticlesTabName: String) {
        self.selectedArticlesTabName = selectedArticlesTabName
    }
}

class ApiPickerScreenViewModel: ObservableObject {
    var apiPickerTemporaryData: ApiPickerTemporaryData
    
    @Published public var articelsViewModels: [ArticlesScreenViewModel] = []
    @Published public var selectedArticlesScreenViewModel: ArticlesScreenViewModel {
        didSet {
            selectedArticlesScreenViewModel.loadPage(ifEmpty: true)
            apiPickerTemporaryData.selectedArticlesTabName = selectedArticlesScreenViewModel.name
        }
    }
    
    init(apiPickerTemporaryData: ApiPickerTemporaryData) {
        self.apiPickerTemporaryData = apiPickerTemporaryData
        let articlesViewModels = [
            ArticlesScreenViewModel(name: "Moscow"),
            ArticlesScreenViewModel(name: "London"),
            ArticlesScreenViewModel(name: "Tokyo"),
            ArticlesScreenViewModel(name: "Cupertino")
        ]
        self.articelsViewModels = articlesViewModels
        self.selectedArticlesScreenViewModel = articlesViewModels.first {
            $0.name == apiPickerTemporaryData.selectedArticlesTabName
        } ??  articlesViewModels.first!
        self.selectedArticlesScreenViewModel.loadPage(ifEmpty: true)
    }
}

//
//  ContentView.swift
//  SwiftUI-App
//
//  Created by ILIYA on 28.08.2021.
//

import SwiftUI
import UITools
import AppUI
import Core

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel = .init()
    var body: some View {
        NavControllerView {
            TabsScreen(
                apiPickerTemporaryData: ApiPickerTemporaryData(selectedArticlesTabName: "Moscow")
            )
        }
    }
}

class ContentViewModel: ObservableObject {
    init() {
        Configurator.registerStandardServices()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

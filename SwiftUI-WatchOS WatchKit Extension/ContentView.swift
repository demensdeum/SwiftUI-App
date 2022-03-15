//
//  ContentView.swift
//  SwiftUI-WatchOS WatchKit Extension
//
//  Created by ILIYA on 06.01.2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        ScrollView {
            Text(viewModel.author)
            Text(viewModel.quote)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                viewModel.load()
            }
        }
    }
}

class ContentViewModel: ObservableObject {
    
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    
    @Published var quote = "Quote Of The Day..."
    @Published var author = "Loading!"
    
    func load() {
        dataTask?.cancel()
        guard var urlComponents = URLComponents(string: "https://quotes.rest/qod") else { return }
        urlComponents.query = "language=en"
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        dataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            guard error == nil,
                  let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let json = String(data: data, encoding: .utf8) else { return }
            
            let quote = json.matches(#"quote": ".*"#).at(0) ?? "?"
            let author = json.matches(#"author": ".*"#).at(0) ?? "?"
            
            DispatchQueue.main.async { [weak self] in
                self?.quote = "\"\(quote.capitalized)"
                self?.author = "\"\(author.capitalized)"
            }
        }
        dataTask?.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Array {
    func at(_ index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
    }
}

extension String {
    // https://stackoverflow.com/questions/27880650/swift-extract-regex-matches
    func matches(_ regex: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: [.caseInsensitive]) else { return [] }
        let matches  = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
        return matches.map { match in
            return String(self[Range(match.range, in: self)!])
        }
    }
}

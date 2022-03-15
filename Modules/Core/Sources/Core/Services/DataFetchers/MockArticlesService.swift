//
//  File.swift
//  
//
//  Created by ILIYA on 29.09.2021.
//

import Foundation
import Networking

public final class MockArticlesService: DataFetcherService<Article> {
    
    public override func fetch(
        query: String,
        page: Int,
        completion: (([Article], Error?) -> Void)?
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            var articles: [Article] = []
            for z in 1...20 {
                let i = (page - 1) * 20 + z
                let article = Article(
                    author: "Mock author \(i)",
                    title: "Mock title \(i) for \(query)",
                    description: "Mock description",
                    url: "http://google.com",
                    urlToImage: "",
                    publishedAt: "2021-04-01",
                    content: "Mock content \(i)"
                )
                articles.append(article)
            }
            completion?(articles, nil)
        }
    }
}

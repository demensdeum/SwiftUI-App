//
//  File.swift
//  
//
//  Created by ILIYA on 29.09.2021.
//

import Foundation
import Networking

public final class StandardArticlesService: DataFetcherService<Article> {
    private let apiKey: String
    
    init(
        apiKey: String
    )
    {
        self.apiKey = apiKey
    }
    
    public override func fetch(
        query: String,
        page: Int,
        completion: (([Article], Error?) -> Void)?
    ) {
        ArticlesAPI.articlesList(
            q: query,
            pageSize: 20,
            language: "en",
            page: page,
            apiKey: apiKey
        ) { root, error in
            completion?(root?.articles ?? [], error)
        }
    }
}

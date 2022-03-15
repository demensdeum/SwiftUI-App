//
//  File.swift
//  
//
//  Created by ILIYA on 29.09.2021.
//

import Networking

public class DataFetcherService<T: Any> {
    
    public func fetch(
        query: String,
        page: Int,
        completion: (([T], Error?) -> Void)?
    )
    {
        fatalError("Unimplemented")
    }
    
}

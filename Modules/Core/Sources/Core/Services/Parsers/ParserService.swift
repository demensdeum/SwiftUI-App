//
//  File.swift
//  
//
//  Created by ILIYA on 30.09.2021.
//

import Foundation

class ParserService {
    public func encode<T: Any>(_ item: T) -> String? where T: Codable {
        fatalError("Unimplemented")
    }
    
    public func decode<T: Any>(_ item: String) -> T? where T: Codable {
        fatalError("Unimplemented")
    }
}

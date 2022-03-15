//
//  File.swift
//  
//
//  Created by ILIYA on 30.09.2021.
//

import Foundation

class JSONParserService: ParserService {
    
    override public func encode<T: Any>(_ item: T) -> String? where T: Codable {
        guard let data = try? JSONEncoder().encode(item) else { return nil }
        let string = String(data: data, encoding: .utf8)
        return string
    }

    override public func decode<T: Any>(_ item: String) -> T? where T: Codable {
        guard let data = item.data(using: .utf8) else { return nil }
        let decoded: T? = try? JSONDecoder().decode(T.self, from: data)
        return decoded
    }
    
}

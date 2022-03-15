//
//  File.swift
//  
//
//  Created by ILIYA on 29.09.2021.
//

import Foundation
import LogicTools

public class UserDefaultsStorageService: StorageService {
    
    @Injected var parserService: ParserService?
    
    private let prefix: String
    
    init(
        prefix: String
    )
    {
        self.prefix = prefix
    }
    
    override public func create<T: Any>(_ item: T) where T: StorageItem {
        let string = parserService?.encode(item)
        UserDefaults.standard.set(string, forKey: "\(prefix)_\(item.id)")
    }
    
    public override func read<T: Any>(id: String) -> T? where T: Codable {
        guard let string = UserDefaults.standard.string(forKey: "\(prefix)_\(id)") else { return nil }
        let decoded: T? = parserService?.decode(string)
        return decoded
    }
    
    public override func update<T: Any>(_ item: T) where T: StorageItem {
        UserDefaults.standard.set(item, forKey: "\(prefix)_\(item.id)")
    }
    
    override public func delete(id: String) {
        UserDefaults.standard.removeObject(forKey: "\(prefix)_\(id)")
    }
    
}

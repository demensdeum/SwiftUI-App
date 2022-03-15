//
//  File.swift
//  
//
//  Created by ILIYA on 29.09.2021.
//

import Foundation

public typealias StorageItem = (Identifiable & Codable)

public class StorageService {
    
    public func create<T: Any>(_ item: T) where T: StorageItem {
        fatalError("Unimplemented")
    }
    
    public func read<T: Any>(id: String) -> T? where T: Codable {
        fatalError("Unimplemented")
    }
    
    public func update<T: Any>(_ item: T) where T: StorageItem {
        fatalError("Unimplemented")
    }
    
    public func delete(id: String) {
        fatalError("Unimplemented")
    }
    
    
}

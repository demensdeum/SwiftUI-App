//
//  File.swift
//  
//
//  Created by ILIYA on 30.09.2021.
//

import Foundation

public struct StorageValueWrapper<T: Codable>: StorageItem {
    public let id: String
    public let value: T
    
    public init(
        id: String,
        value: T
    )
    {
        self.id = id
        self.value = value
    }
}

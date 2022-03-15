//
//  File.swift
//  
//
//  Created by ILIYA on 29.09.2021.
//

import Foundation

public final class DIBridge {
    
    public static let shared = DIBridge()
    public let serviceLocator = ServiceLocator()
    
    public func register<T:AnyObject>(_ service: T) {
        serviceLocator.set(service)
    }
    
    public func clear() {
        serviceLocator.clear()
    }
    
}

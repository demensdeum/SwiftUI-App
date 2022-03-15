//
//  File.swift
//  
//
//  Created by ILIYA on 29.09.2021.
//

import Foundation

public final class ServiceLocator {
    private var services: [String: AnyObject] = [:]
    
    public func set<T:AnyObject>(_ service: T) {
        services["\(T.self)"] = service
    }
    
    public func get<T:AnyObject>(_ type: T.Type) -> T? {
        return services["\(T.self)"] as? T
    }
    
    public func clear() {
        services.removeAll()
    }
}

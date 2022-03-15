//
//  File.swift
//  
//
//  Created by ILIYA on 29.09.2021.
//

import Foundation

@propertyWrapper
public struct Injected<Service: AnyObject> {
    private var service: Service?
    private weak var serviceLocator = DIBridge.shared.serviceLocator
    
    public init() {} // compiler public constructor workaround
    
    public var wrappedValue: Service? {
        mutating get {
            if service == nil {
                service = serviceLocator?.get(Service.self)
            }
            return service
        }
        mutating set {
            service = newValue
        }
    }
    
    public var projectedValue: Injected<Service> {
        mutating set { self = newValue }
        get { return self }
    }
}

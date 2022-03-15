//
//  Configurator.swift
//  SwiftUI-App
//
//  Created by ILIYA on 29.09.2021.
//

import Foundation
import LogicTools

public final class Configurator {

    public init() {}
    
    public static func registerDefaultServices() {
        DIBridge.shared.clear()
        DIBridge.shared.register(
            JSONParserService() as ParserService
        )
    }
    
    public static func registerStandardServices() {
        registerDefaultServices()
        DIBridge.shared.register(
            StandardArticlesService(
                apiKey: "445938e7b4214f4988780151868665cc"
            ) as DataFetcherService
        )
        DIBridge.shared.register(
            UserDefaultsStorageService(prefix: "Standard") as StorageService
        )
    }
    
    public static func registerMockServices() {
        registerDefaultServices()
        DIBridge.shared.register(
            MockArticlesService() as DataFetcherService
        )
        DIBridge.shared.register(
            UserDefaultsStorageService(prefix: "Mock") as StorageService
        )
    }
    
}

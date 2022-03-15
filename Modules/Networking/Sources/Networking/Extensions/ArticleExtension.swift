//
//  ArticleExtension.swift
//  SwiftUI-App
//
//  Created by ILIYA on 24.09.2021.
//

extension Article: Identifiable {
    public var id: String { "\(String(describing: title))-\(String(describing: url))" }
}

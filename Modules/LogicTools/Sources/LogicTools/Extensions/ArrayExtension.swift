//
//  ArrayExtension.swift
//  SwiftUI-App
//
//  Created by ILIYA on 21.09.2021.
//

import Foundation

public extension Array where Self.Element: Identifiable {
    
    func isLast(_ element: Element) -> Bool {
        guard let last = self.last else { return false }
        return last.id == element.id
    }
    
}

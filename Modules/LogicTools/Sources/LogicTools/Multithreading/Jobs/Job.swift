//
//  File.swift
//  
//
//  Created by ILIYA on 10.11.2021.
//

import Foundation

public protocol Job {
    func perform(completion:(()->())?)
}

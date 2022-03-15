//
//  File.swift
//  
//
//  Created by ILIYA on 10.11.2021.
//

import Foundation

public class JobScheduler {
    private var jobQueue: JobQueue = .init()
    
    public init() {}
    
    public func add(job: Job) {
        jobQueue.push(job: job)
    }
}

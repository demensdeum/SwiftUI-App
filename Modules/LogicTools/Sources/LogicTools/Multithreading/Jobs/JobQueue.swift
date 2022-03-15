//
//  File.swift
//  
//
//  Created by ILIYA on 10.11.2021.
//

import Foundation

class JobQueue {
    
    private var jobs: [Job] = []
    private var currentJob: Job?
    
    func push(job: Job) {
        DispatchQueue.main.async { [weak self] in
            self?.jobs.append(job)
            self?.popIfNeeded()
        }
    }
    
    private func popIfNeeded() {
        DispatchQueue.main.async { [weak self] in
            guard self?.currentJob == nil else { return }
            guard self?.jobs.count ?? 0 > 0 else { return }
            self?.currentJob = self?.jobs.removeFirst()
            self?.currentJob?.perform(completion: { [weak self] in
                DispatchQueue.main.async {
                    self?.currentJob = nil
                    self?.popIfNeeded()
                }
            })
        }
    }
    
}

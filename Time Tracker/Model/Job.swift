//
//  Job.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 16/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

/// Structure which defines a single job with multiple timespans
struct Job: Codable {
    // MARK: - Stored Properties
    /// Job's name
    var name: String
    
    /// Collection of job's timespans
    var timespans: [Timespan]
    
    // MARK: - Computed Properties
    /// Current duration of the job = sum of durations of the timespans
    var duration: TimeInterval {
        return timespans.reduce(0) { $0 + $1.duration }
    }
    
    /// True if at least one timespan is running
    var isRunning: Bool {
        return timespans.reduce(false) { $0 || $1.isRunning }
    }
    
    /// Returns indexes of running timespans
    var indexesOfRunningTimespans: [Int] {
        let indexes = timespans.enumerated().filter({ $0.element.isRunning }).map { $0.offset }
        return indexes
    }
    
    init(name: String, timespans: [Timespan] = []) {
        self.name = name
        self.timespans = timespans
    }
    
    /// Start new timespan
    mutating func startNewTimespan(in section: Int) {
        // stop all timespans and create new timespan
        stop()
        let name = "Task #\(section + 1).\(timespans.count + 1)"
        let timespan = Timespan(named: name, status: .running)
        timespans.append(timespan)
    }
    
    /// Stop this job
    mutating func stop() {
        // stop all timespans
        for index in 0 ..< timespans.count {
            timespans[index].stop()
        }
    }
}

// MARK: - extension [Job]
extension Array where Element == Job {
    /// True if at least one job is running
    var areRunning: Bool {
        return reduce(false) { $0 || $1.isRunning }
    }
    
    /// Encoded with property list encoder
    var encoded: Data? {
        let encoder = PropertyListEncoder()
        return try? encoder.encode(self)
    }
    
    /// Initialize from data encoded with property list encoder
    ///
    /// - Parameter data: encoded data
    init?(from data: Data?) {
        guard let data = data else { return nil }
        
        let decoder = PropertyListDecoder()
        guard let jobs = try? decoder.decode([Element].self, from: data) else { return nil }
        
        self = jobs
    }
    
    /// Create and start a new job
    mutating func startNewJob() {
        // create and start a new job
        if let lastJob = last, lastJob.timespans.isEmpty {
            let section = count - 1
            self[section].startNewTimespan(in: section)
        } else {
            let section = count
            var job = Job(name: "Job #\(section + 1)")
            job.startNewTimespan(in: section)
            append(job)
        }
        
    }
    
    /// Stop all jobs
    mutating func stop() {
        for index in 0 ..< count {
            self[index].stop()
        }
    }
}

//
//  Timespan.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 16/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

/// Structure which defines the timespan with start and end time
struct Timespan: Codable {
    
    // MARK: - Enums
    /// Coding Keys to match plist keys with property names
    enum CodingKeys: String, CodingKey {
        case name
        case privateEndTime = "endTime"
        case startTime
        case status
    }
    
    /// Enum which defines the current status of a timespan
    ///
    /// - running: timespan is currently counting
    /// - stopped: timespan not started or alredy finished
    enum Status: Int, Codable {
        case running
        case stopped
    }
    
    // MARK: - Stored Properties
    /// Timespan's end time
    var endTime: Date {
        get {
            return isRunning ? Date() : privateEndTime
        }
        
        set {
            privateEndTime = newValue
        }
    }
    
    /// Optional name of a timespan
    var name: String?
    
    /// Timespan's private end time
    private var privateEndTime: Date
    
    /// Timespan's start time
    var startTime: Date
    
    /// Timespan's current status
    var status: Status
    
    // MARK: - Computed Properties
    /// Current duration of the timespan
    var duration: TimeInterval {
        return endTime.timeIntervalSince(startTime)
    }
    
    /// True if status is .running
    var isRunning: Bool {
        if status == .running {
            return true
        } else {
            return false
        }
    }
    
    /// Initialize timespan with current date as start and end time
    ///
    /// - Parameters:
    ///   - status: timespan's status, .stopped by default
    ///   - name: optional name of the timespan's
    init(status: Status = .stopped, name: String? = nil) {
        self.status = status
        self.name = name
        startTime = Date()
        privateEndTime = startTime
    }
    
    /// Start this timespan
    mutating func start() {
        if status == .stopped {
            startTime = Date()
            status = .running
        }
        endTime = Date()
    }
    
    /// Stop this timespan
    mutating func stop() {
        if status == .running {
            endTime = Date()
            status = .stopped
        }
    }
}

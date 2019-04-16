//
//  FormattedDuration.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 16/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

protocol FormattedDuration {
    var duration: TimeInterval { get }
    var formattedDuration: String { get }
}

// MARK: - implementation
extension FormattedDuration {
    var formattedDuration: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration) ?? "\(duration)"
    }
}

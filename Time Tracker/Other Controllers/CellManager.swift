//
//  CellManager.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 16/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class CellManager {
    func configure(_ cell: UITableViewCell, with timespan: Timespan) {
        var timespan = timespan
        var formattedTime = timespan.startTime.formatted
        
        if case .running = timespan.status {
            timespan.endTime = Date()
            formattedTime = "started \(formattedTime)"
        } else {
            formattedTime += " — \(timespan.endTime.formatted(with: timespan.startTime))"
        }
        
        cell.textLabel?.text = "\(timespan.formattedDuration) (\(formattedTime))"
        cell.detailTextLabel?.text = timespan.name
    }
}

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
        
        let startTime = timespan.startTime
        let endTime = timespan.endTime
        
        let formattedStartTime = startTime.formatted
        let formattedEndTime = endTime.formatted(with: startTime)
        let formattedTime: String
        
        if timespan.status == .running {
            timespan.endTime = Date()
            formattedTime = "since \(formattedStartTime)"
        } else {
            formattedTime = "(\(formattedStartTime) — \(formattedEndTime))"
        }
        
        cell.textLabel?.text = "\(timespan.formattedDuration) \(formattedTime)"
        cell.detailTextLabel?.text = timespan.name
    }
}

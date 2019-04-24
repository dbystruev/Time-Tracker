//
//  CellManager.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 16/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class CellManager {
    func configure(_ headerView: HeaderView, with job: Job, inSection section: Int) {
        let isRunning = job.isRunning
        
        headerView.contentView.backgroundColor = isRunning ? #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        headerView.controlButton.isSelected = isRunning
        headerView.detailLabel.text = job.duration.formatted
        headerView.section = section
        headerView.titleLabel.text = job.name
        headerView.titleLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        headerView.setEditing(headerView.isEditing)
    }
    
    func configure(_ cell: UITableViewCell, with timespan: Timespan) {
        var timespan = timespan
        
        let startTime = timespan.startTime
        let endTime = timespan.endTime
        
        let formattedStartTime = startTime.formatted
        let formattedEndTime = endTime.formatted(with: startTime)
        let formattedTime: String
        
        if timespan.status == .running {
            cell.textLabel?.textColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            formattedTime = "since \(formattedStartTime)"
        } else {
            cell.textLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            formattedTime = "(\(formattedStartTime) … \(formattedEndTime))"
        }
        
        cell.textLabel?.text = timespan.name
        cell.detailTextLabel?.text = "\(timespan.duration.formatted) \(formattedTime)"
    }
}

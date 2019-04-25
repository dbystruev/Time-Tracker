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
        let backgroundColor = isRunning ? UIColor.Header.Background.running : UIColor.Header.Background.stopped
        let textColor = isRunning ? UIColor.Header.Text.running : UIColor.Header.Text.stopped
        
        headerView.contentView.backgroundColor = backgroundColor
        headerView.controlButton.isSelected = isRunning
        headerView.detailLabel.text = job.duration.formatted
        headerView.detailLabel.textColor = textColor
        headerView.section = section
        headerView.titleLabel.text = job.name
        headerView.titleLabel.textColor = textColor
        
        headerView.setEditing(headerView.isEditing)
    }
    
    func configure(_ cell: UITableViewCell, with timespan: Timespan) {
        let isRunning = timespan.status == .running
        let startTime = timespan.startTime
        let endTime = timespan.endTime
        
        let formattedStartTime = startTime.formatted
        let formattedEndTime = endTime.formatted(with: startTime)
        let formattedTime = isRunning ? "since \(formattedStartTime)" : "(\(formattedStartTime) … \(formattedEndTime))"
        
        let backgroundColor = isRunning ? UIColor.Cell.Background.running : UIColor.Cell.Background.stopped
        let textColor = isRunning ? UIColor.Cell.Text.running : UIColor.Cell.Text.stopped
        
        cell.backgroundColor = backgroundColor
        cell.detailTextLabel?.text = "\(timespan.duration.formatted) \(formattedTime)"
        cell.detailTextLabel?.textColor = textColor
        cell.textLabel?.text = timespan.name
        cell.textLabel?.textColor = textColor
    }
}

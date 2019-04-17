//
//  DetailViewController.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 17/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

/// Controls the second screen with details of particular time span of a job
class DetailViewController: UITableViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    // MARK: - Stored Properties
    /// Job to show/change
    var job: Job!
    
    /// Timespan's index to show/change
    var timespanIndex: Int!
    
    // MARK: - Computed Properties
    var timespan: Timespan {
        return job.timespans[timespanIndex]
    }
}

// MARK: - Custom Methods
extension DetailViewController {
    func updateUI() {
        jobNameLabel.text = job.name
        startTimeLabel.text = "Started: \(timespan.startTime.formatted)"
        
        if timespan.isRunning {
            
            endTimeLabel.text = "Status: \(timespan.status)"
            durationLabel.text = "Duration: \(timespan.formattedDuration) and counting"
            
        } else {
            
            endTimeLabel.text = "Finished: \(timespan.endTime.formatted)"
            durationLabel.text = "Duration: \(timespan.formattedDuration)"
            
        }
    }
}

// MARK: - Table View Data Source
extension DetailViewController /*: UITableViewDataSource */ {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let title: String?
        
        switch section {
            
        case 1:
            title = "Timespan # \(timespanIndex + 1) of \(job.timespans.count)"
            
        default:
            title = super.tableView(tableView, titleForHeaderInSection: section)
            
        }
        
        return title
    }
}

// MARK: - UI View Controller
extension DetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
}

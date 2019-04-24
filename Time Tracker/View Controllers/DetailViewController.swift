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
    // MARK: - Stored Properties
    /// Job to show/change
    var job: Job!
    
    /// Timespan's index to show/change
    var selectedTimespan: Int?
}

// MARK: - Table View Data Source
extension DetailViewController /*: UITableViewDataSource */ {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return selectedTimespan == nil ? job.timespans.count + 1 : 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        let section = indexPath.section
        let text: String?
        
        switch section {
        case 0:
            text = job.name
            
        case 1...:
            let timespan = selectedTimespan == nil ? job.timespans[section - 1] : job.timespans[selectedTimespan!]
            
            switch indexPath.row {
                
            case 0:
                text = "Started: \(timespan.startTime.formatted)"
                
            case 1:
                text = timespan.isRunning ?
                    "Status: \(timespan.status)" :
                    "Finished: \(timespan.endTime.formatted)"
                
            case 2:
                text = timespan.isRunning ?
                    "Duration: \(timespan.duration.formatted) and counting" :
                    "Duration: \(timespan.duration.formatted)"
                
            default:
                text = nil
                
            }
            
        default:
            text = nil
        }
        
        cell.textLabel?.text = text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1...:
            return 3
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let title: String?
        
        switch section {
            
        case 0:
            title = "Job"
            
        case 1...:
            let timespanNumber = selectedTimespan == nil ? section : selectedTimespan! + 1
            title = "Timespan # \(timespanNumber) of \(job.timespans.count)"
            
        default:
            title = nil
            
        }
        
        return title
    }
}

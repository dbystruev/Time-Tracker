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

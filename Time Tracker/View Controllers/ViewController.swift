//
//  ViewController.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 16/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    /// Manager to setup the cells
    let manager = CellManager()
    
    /// Timer to update the table once a second
    var timer: Timer!
    
    /// Jobs data source
    var jobs = [Job]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateTable()
        }
    }
    
    func updateTable() {
        if jobs.areRunning {
            var pathsToUpdate = [IndexPath]()
            
            for (section, job) in jobs.enumerated() {
                if job.isRunning {
                    job.indexesOfRunningTimespans.forEach {
                        let pathToUpdate = IndexPath(row: $0, section: section)
                        pathsToUpdate.append(pathToUpdate)
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: pathsToUpdate, with: .automatic)
            }
        }
    }
}

// MARK: - Table View Data Source
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimespanCell")!
        let job = jobs[indexPath.section]
        let timespan = job.timespans[indexPath.row]
        manager.configure(cell, with: timespan)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let job = jobs[section]
        return job.timespans.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let job = jobs[section]
        var headerName = job.name
        
        if !job.isRunning {
            headerName += " (\(job.formattedDuration))"
        }
        
        return headerName
    }
}

// MARK: - Table View Delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = jobs[indexPath.section]
        let timespan = job.timespans[indexPath.row]
        
        switch timespan.status {
            
        case .running:
            jobs[indexPath.section].stop()
            
        case .stopped:
            jobs[indexPath.section].startNewTimespan()
        }
        
        tableView.reloadSections([indexPath.section], with: .automatic)
    }
}

// MARK: - IB Action
extension ViewController {
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        jobs.startNewJob()
        tableView.reloadData()
    }
}

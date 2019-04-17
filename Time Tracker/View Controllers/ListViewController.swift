//
//  ListViewController.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 16/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

/// Controls the first screen with the list of jobs
class ListViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Stored Properties
    /// Permanet storage key for UserDefaults
    let storageKey = "TimeTrackerKey"
    
    /// Manager to setup the cells
    let manager = CellManager()
    
    /// Timer to update the table once a second
    var timer: Timer!
    
    /// Flag to indicate that permanent storage data were just loaded
    var justLoaded = false
    
    /// Jobs data source
    var jobs = [Job]() {
        didSet {
            if justLoaded {
                justLoaded = false
            } else {
                if let encoded = jobs.encoded {
                    UserDefaults.standard.set(encoded, forKey: storageKey)
                }
            }
        }
    }
}


// MARK: - IB Actions
extension ListViewController {
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        jobs.startNewJob()
        tableView.reloadData()
    }
}

// MARK: - Custom Methods
extension ListViewController {
    func updateTable() {
        if jobs.areRunning && !isEditing {
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

// MARK: - Header View Delegate
extension ListViewController: HeaderViewDelegate {
    func controlButtonPressed(_ sender: HeaderView) {
        guard let section = sender.section else { return }
        guard section < jobs.count else { return }
        
        let job = jobs[section]
        
        if job.isRunning {
            jobs[section].stop()
        } else {
            jobs[section].startNewTimespan()
        }
        
        tableView.reloadSections([section], with: .automatic)
    }
    
    func textFieldEdited(_ sender: HeaderView) {
        guard let name = sender.titleField.text else { return }
        guard let section = sender.section else { return }
        guard section < jobs.count else { return }
        
        jobs[section].name = name
        tableView.reloadSections([section], with: .automatic)
    }
    
    func title(for section: Int?) -> String? {
        guard let section = section else { return nil }
        guard section < jobs.count else { return nil }
        
        let job = jobs[section]
        let name = job.name
        
        return name
    }
}

// MARK: - Navigation
extension ListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "DetailViewControllerSegue" else { return }
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        
        let section = selectedIndexPath.section
        let job = jobs[section]
        let timespanIndex = selectedIndexPath.row
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.navigationItem.title = job.name
        detailViewController.job = job
        detailViewController.timespanIndex = timespanIndex
    }
}

// MARK: - Table View Data Source
extension ListViewController: UITableViewDataSource {
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
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
            
        case .delete:
            let section = indexPath.section
            let row = indexPath.row
            
            jobs[section].timespans.remove(at: row)
            
            if jobs[section].timespans.isEmpty {
                jobs.remove(at: section)
                tableView.reloadData()
            } else {
                if jobs[section].isRunning {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    tableView.reloadSections([section], with: .fade)
                }
            }
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let section = indexPath.section
//        let job = jobs[section]
//        let timespan = job.timespans[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let job = jobs[section]
        var headerName = job.name
        
        if !job.isRunning {
            headerName += " (\(job.formattedDuration))"
        }
        
        let headerView = HeaderView()
        headerView.controlButton.isSelected = job.isRunning
        headerView.delegate = self
        headerView.section = section
        headerView.titleLabel.text = headerName
        
        return headerView
    }
}

// MARK: - UI View Controller
extension ListViewController {
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = UserDefaults.standard.data(forKey: storageKey)
        if let jobs = [Job](from: data) {
            justLoaded = true
            self.jobs = jobs
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateTable()
        }
    }
}

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
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Stored Properties (Constants)
    /// Manager to setup the cells
    let manager = CellManager()
    
    /// Permanet storage key for UserDefaults
    let storageKey = "TimeTrackerKey"
    
    // MARK: - Stored Properties (Variables)
    /// Rect with header view which is being edited
    var editedHeaderView: HeaderView?
    
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
    
    /// Flag to indicate that permanent storage data were just loaded
    var justLoaded = false
    
    /// Timer to update the table once a second
    var timer: Timer!
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

// MARK: - Keyboard
// https://github.com/dbystruev/Angular-Acceleration/blob/master/Angular%20Acceleration/ViewController.swift
extension ListViewController {
    func addKeyboardObservers() {
        let names: [NSNotification.Name] = [
            UIResponder.keyboardWillShowNotification,
            UIResponder.keyboardWillHideNotification
        ]
        
        for name in names {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillResize),
                name: name,
                object: nil
            )
        }
    }
    
    @objc func keyboardWillResize(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] else { return }
        guard let keyboardFrameValue = keyboardFrame as? NSValue else { return }
        
        let keyboardSize = keyboardFrameValue.cgRectValue
        let constant: CGFloat
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            constant = keyboardSize.height
        } else {
            constant = 0
        }
        
        tableViewBottomConstraint.constant = constant
    }
}

// MARK: - Header View Delegate
extension ListViewController: HeaderViewDelegate {
    func headerView(_ headerView: HeaderView, beginEditing field: UITextField) {
        editedHeaderView = headerView
    }
    
    func headerView(_ headerView: HeaderView, didSelect section: Int) {
        let indexPath = IndexPath(row: 0, section: section)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        performSegue(withIdentifier: "DetailViewControllerSectionSegue", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func headerView(_ headerView: HeaderView, endEditing field: UITextField) {
        if editedHeaderView == headerView {
            editedHeaderView = nil
        }
        
        guard let section = headerView.section else { return }
        guard let name = field.text else { return }
        guard section < jobs.count else { return }
        
        jobs[section].name = name
        tableView.reloadSections([section], with: .automatic)
    }
    
    func headerView(_ headerView: HeaderView, pressed button: UIButton) {
        guard let section = headerView.section else { return }
        guard section < jobs.count else { return }
        
        let job = jobs[section]
        
        if job.isRunning {
            jobs[section].stop()
        } else {
            jobs[section].startNewTimespan()
        }
        
        tableView.reloadSections([section], with: .automatic)
    }
    
    func headerView(titleFor section: Int?) -> String? {
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
        let allowedSegues = ["DetailViewControllerRowSegue", "DetailViewControllerSectionSegue"]
        
        guard let identifier = segue.identifier else { return }
        guard allowedSegues.contains(identifier) else { return }
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        
        let section = selectedIndexPath.section
        let job = jobs[section]
        let selectedTimespan = identifier == "DetailViewControllerSectionSegue" ? nil : selectedIndexPath.row
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.navigationItem.title = job.name
        detailViewController.job = job
        detailViewController.selectedTimespan = selectedTimespan
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
            headerName += " (\(job.duration.formatted))"
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
        
        addKeyboardObservers()
        navigationItem.leftBarButtonItem = editButtonItem
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateTable()
        }
    }
    
    /// Scroll to edited cell when rotating device
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let editedHeaderView = editedHeaderView else { return }
        
        let bounds = editedHeaderView.titleField.bounds
        let rect = editedHeaderView.titleField.convert(bounds, to: tableView)
        
        tableView.scrollRectToVisible(rect, animated: true)
    }
}

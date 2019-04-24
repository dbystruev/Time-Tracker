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
            let sectionsToUpdate = IndexSet(jobs.enumerated().filter{ $0.element.isRunning }.map{ $0.offset })
            
            DispatchQueue.main.async {
                self.tableView.reloadSections(sectionsToUpdate, with: .none)
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

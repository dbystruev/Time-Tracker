//
//  ListViewController.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 16/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UI View Controller
extension ListViewController {
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        tableView.reloadData()
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

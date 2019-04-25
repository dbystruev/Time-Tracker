//
//  ListViewController+UI.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 16/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Methods
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

//
//  ListViewController+Navigation.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 16/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

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

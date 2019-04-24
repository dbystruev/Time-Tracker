//
//  ListViewController.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 16/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

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
        guard !name.isEmpty else { return }
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
            jobs[section].startNewTimespan(in: section)
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

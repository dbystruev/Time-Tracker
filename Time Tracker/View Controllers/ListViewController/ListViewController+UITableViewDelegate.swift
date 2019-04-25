//
//  ListViewController+UITableViewDelegate.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 16/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView()
        headerView.delegate = self
        headerView.isEditing = isEditing
        
        let job = jobs[section]
        manager.configure(headerView, with: job, inSection: section)
        
        return headerView
    }
}

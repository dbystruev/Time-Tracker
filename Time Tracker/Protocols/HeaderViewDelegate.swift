//
//  HeaderViewDelegate.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 17/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate {
    func headerView(_ headerView: HeaderView, beginEditing field: UITextField)
    func headerView(_ headerView: HeaderView, didSelect section: Int)
    func headerView(_ headerView: HeaderView, endEditing field: UITextField)
    func headerView(_ headerView: HeaderView, pressed button: UIButton)
    func headerView(titleFor section: Int?) -> String?
}

//
//  HeaderViewDelegate.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 17/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate {
    func controlButtonPressed(_ sender: HeaderView)
    func textFieldEdited(_ sender: HeaderView)
    func title(for section: Int?) -> String?
}

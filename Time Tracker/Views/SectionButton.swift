//
//  SectionButton.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 17/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class SectionButton: UIButton {
    var delegate: SectionButtonDelegate?
    var section: Int!
}

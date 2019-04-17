//
//  HeaderView.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 17/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    @IBOutlet var contentView: HeaderView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var plusButton: SectionButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
    }
    
    func loadFromNib() {
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        plusButton.delegate?.sectionButtonPressed(plusButton)
    }
}

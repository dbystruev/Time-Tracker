//
//  HeaderView.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 17/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    @IBOutlet var singleTapRecognizer: UITapGestureRecognizer!
    @IBOutlet var contentView: HeaderView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var plusButton: UIButton!
    
    var delegate: HeaderViewDelegate?
    var section: Int?
    
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
    
    func fieldEditingEnded() {
        singleTapRecognizer.isEnabled = false
        titleLabel.isHidden = false
        titleField.isHidden = true
        delegate?.textFieldEdited(self)
    }
    
    @IBAction func beginEditingGestureRecognized(_ sender: Any) {
        singleTapRecognizer.isEnabled = true
        titleLabel.isHidden = true
        titleField.isHidden = false
        titleField.text = delegate?.title(for: section) ?? ""
    }
    
    @IBAction func endEditingGestureRecognized(_ sender: Any) {
        fieldEditingEnded()
    }
    
    @IBAction func editingEnded(_ sender: UITextField) {
        fieldEditingEnded()
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        delegate?.plusButtonPressed(self)
    }
}

//
//  HeaderView.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 17/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    // MARK: - IB Outlets
    @IBOutlet var singleTapRecognizer: UITapGestureRecognizer!
    @IBOutlet var doubleTapRecognizer: UITapGestureRecognizer!
    @IBOutlet var contentView: HeaderView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var controlButton: UIButton!
    
    // MARK: - Stored Properties
    var delegate: HeaderViewDelegate?
    var isEditing = false {
        didSet {
            titleLabel.isHidden = isEditing
            titleField.isHidden = !isEditing
        }
    }
    var section: Int?
    
    // MARK: - Custom Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
    }
    
    func fieldEditingEnded() {
        isEditing = false
        delegate?.headerView(self, endEditing: titleField)
    }
    
    func loadFromNib() {
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        singleTapRecognizer.require(toFail: doubleTapRecognizer)
    }
    
    // MARK: - IB Actions
    @IBAction func beginEditingGestureRecognized(_ sender: Any) {
        delegate?.headerView(self, beginEditing: titleField)
        isEditing = true
        titleField.text = delegate?.headerView(titleFor: section) ?? titleField.text
    }
    
    @IBAction func editingEnded(_ sender: UITextField) {
        fieldEditingEnded()
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        delegate?.headerView(self, pressed: controlButton)
    }
    
    @IBAction func singleTapGestureRecognized(_ sender: UITapGestureRecognizer) {
        if isEditing {
            fieldEditingEnded()
        } else {
            guard let section = section else { return }
            delegate?.headerView(self, didSelect: section)
        }
    }
}

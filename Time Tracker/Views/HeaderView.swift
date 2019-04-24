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
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var controlButton: UIButton!
    
    // MARK: - Stored Properties
    var delegate: HeaderViewDelegate?
    var isEditing: Bool!
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
    
    func loadFromNib() {
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        singleTapRecognizer.require(toFail: doubleTapRecognizer)
    }
    
    func setEditing(_ editing: Bool) {
        isEditing = editing
        
        if editing {
            titleField.text = delegate?.headerView(titleFor: section) ?? titleLabel.text
            delegate?.headerView(self, beginEditing: titleField)
        } else {
            delegate?.headerView(self, endEditing: titleField)
        }
        
        detailLabel.isHidden = editing
        titleLabel.isHidden = editing
        titleField.isHidden = !editing
    }
    
    // MARK: - IB Actions
    @IBAction func beginEditingGestureRecognized(_ sender: Any) {
        setEditing(true)
    }
    
    @IBAction func editingEnded(_ sender: UITextField) {
        setEditing(false)
    }
    
    @IBAction func controlButtonPressed(_ sender: UIButton) {
        delegate?.headerView(self, pressed: controlButton)
    }
    
    @IBAction func singleTapGestureRecognized(_ sender: UITapGestureRecognizer) {
        if isEditing {
            setEditing(false)
        } else {
            guard let section = section else { return }
            delegate?.headerView(self, didSelect: section)
        }
    }
}

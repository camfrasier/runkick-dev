//
//  CommentInputTextView.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 10/4/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit

class CommentInputTextView: UITextView {
    
    // MARK: - Properties

    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter comment..."
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInputTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    
    @objc func handleInputTextChange() {
        // the placeholder is hidden is equal to whatever the value is going to evaluate. when text is empty the isHidden will be equal to true
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
}

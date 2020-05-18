//
//  AdminProfileCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 4/14/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

protocol AdminProfileCellDelegate {
    func presentPhotoProfileView(withProfileCell post: Post)
}

class AdminProfileCell: UICollectionViewCell {
    
    var post: Post? {
        
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            postImageView.loadImage(with: imageUrl)
        }
    }
    
    var delegate: AdminProfileCellDelegate?
    
    let postImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViewComponents()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    func configureViewComponents() {
        
    // round edges in cell
    self.layer.cornerRadius = 0
    
    // matches the imageview boundary radius to cell for a rounded view
    self.clipsToBounds = true
        
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    // MARK: - Selectors
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        
        /*
        if sender.state == .began {
            print("Long press did begin..")
        } else if sender.state == .ended {
            print("Long press did end..")
        }
        */
        
        if sender.state == .began {
            guard let post = self.post else { return }
            delegate?.presentPhotoProfileView(withProfileCell: post)
        }
    }
}


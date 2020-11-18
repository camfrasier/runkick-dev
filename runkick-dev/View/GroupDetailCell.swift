//
//  GroupDetailCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 11/5/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

class GroupDetailCell: UICollectionViewCell {
    
    /*
    var group: UserGroup? {
        didSet {
            guard let photoImageUrl = group?.profileImageURL else { return }
            groupMemberImageView.loadImage(with: photoImageUrl)
            
        }
    }
    */
    
    var user: User? {
        didSet {
            guard let photoImageUrl = user?.profileImageURL else { return }
            groupMemberImageView.loadImage(with: photoImageUrl)
            
        }
    }

    
    let groupMemberImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor.lightGray
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
        
        backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        // items here should be more geared towards the user and their daily performance.
        
        // organize by top daily leaders or group leaders - maybe have their cells with their face and stats beneath with all else below
        
        addSubview(groupMemberImageView)
        let groupDiminsions: CGFloat = 65
        groupMemberImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: groupDiminsions, height: groupDiminsions)
        groupMemberImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        groupMemberImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        groupMemberImageView.layer.cornerRadius = groupDiminsions / 2
        
    }
    
    // MARK: - Selectors
    
}

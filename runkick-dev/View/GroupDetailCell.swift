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
            
            guard let username = user?.username else { return }
            self.usernameLabel.text = username
            
        }
    }

    
    let groupMemberImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor.lightGray
        return iv
    } ()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        //label.font = UIFont(name: "ArialRoundedMTBold", size: 13)
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        label.isUserInteractionEnabled = true
        return label
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
        groupMemberImageView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: groupDiminsions, height: groupDiminsions)
        //groupMemberImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        groupMemberImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        groupMemberImageView.layer.cornerRadius = groupDiminsions / 2
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: groupMemberImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 7, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameLabel.centerXAnchor.constraint(equalTo: groupMemberImageView.centerXAnchor).isActive = true
        
    }
    
    // MARK: - Selectors
    
}

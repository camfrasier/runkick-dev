//
//  GroupsCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/5/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit

class GroupsCell: UICollectionViewCell {
    
    // Mark: - Properties
    var group: UserGroup? {
        didSet {
            guard let photoImageUrl = group?.profileImageURL else { return }
            groupImageView.loadImage(with: photoImageUrl)
            
            guard let groupName = group?.groupName else { return }
            self.groupsNameLabel.text = groupName
            
            //guard let points = group?.points else { return }
            //self.pointsLabel.text = String(points)
        }
    }
    
    let groupImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "userProfileIcon")
        return iv
    } ()
    
    let groupsNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.text = "Group Name"
        return label
    }()
    
    let groupDetailsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.text = "10 members"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let postImageDimension = CGFloat(75)
        addSubview(groupImageView)
        groupImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: postImageDimension, height: postImageDimension)
        groupImageView.layer.cornerRadius = postImageDimension / 2
        //groupImageView.layer.cornerRadius = 8
        groupImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        groupImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(groupsNameLabel)
        groupsNameLabel.anchor(top: groupImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        groupsNameLabel.centerXAnchor.constraint(equalTo: groupImageView.centerXAnchor).isActive = true
        
        addSubview(groupDetailsLabel)
        groupDetailsLabel.anchor(top: groupsNameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        groupDetailsLabel.centerXAnchor.constraint(equalTo: groupImageView.centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

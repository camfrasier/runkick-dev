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
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.font = UIFont(name: "ArialRoundedMTBold", size: 13)
        label.numberOfLines = 0
        label.text = "Group Name"
        label.textAlignment = .center
        return label
    }()
    
    let groupDetailsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.text = "10 members"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        let postImageDimension = CGFloat(84)
        addSubview(groupImageView)
        groupImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: postImageDimension, height: postImageDimension )
        groupImageView.layer.cornerRadius = postImageDimension / 2.45
        groupImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        groupImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(groupsNameLabel)
        groupsNameLabel.anchor(top: groupImageView.bottomAnchor, left: groupImageView.leftAnchor, bottom: nil, right: groupImageView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //groupsNameLabel.backgroundColor = UIColor.rgb(red: 0, green: 200, blue: 200)
        groupsNameLabel.centerXAnchor.constraint(equalTo: groupImageView.centerXAnchor).isActive = true
        
        //addSubview(groupDetailsLabel)
        //groupDetailsLabel.anchor(top: groupsNameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //groupDetailsLabel.centerXAnchor.constraint(equalTo: groupImageView.centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

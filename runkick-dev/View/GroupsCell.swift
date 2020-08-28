//
//  GroupsCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/5/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit

class GroupsCell: UICollectionViewCell {
    
    /*
    var post: Post? {
        
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            postImageView.loadImage(with: imageUrl)
        }
    }
    */
    
    let groupsImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "userProfileIcon")
        return iv
    } ()
    
    let groupsNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        label.text = "Group Name"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let postImageDimension = CGFloat(60)
        addSubview(groupsImageView)
        groupsImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: postImageDimension, height: postImageDimension)
        groupsImageView.layer.cornerRadius = postImageDimension / 2
        groupsImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        groupsImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(groupsNameLabel)
        groupsNameLabel.anchor(top: groupsImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        groupsNameLabel.centerXAnchor.constraint(equalTo: groupsImageView.centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

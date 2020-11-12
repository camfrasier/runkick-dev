//
//  GroupMessageCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 10/12/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit


class GroupMessageCell: UITableViewCell {
    
    
    // MARK: - Properties
    
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
        //label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        return label
    } ()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        configureComponents()
    }
    
    override func layoutSubviews() {
        // this needs to be called for the below to actually run
        super.layoutSubviews()
        
        /*
        textLabel?.frame = CGRect(x: 80, y: textLabel!.frame.origin.y - 2,
                                  width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        addSubview(detailTextLabel!)
        detailTextLabel?.anchor(top: textLabel?.bottomAnchor, left: textLabel?.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        detailTextLabel?.textColor = UIColor.rgb(red: 130, green: 130, blue: 130)
        detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
        */
    }
    
    func configureComponents() {
        
        let profileImageDimension = CGFloat(55)
        addSubview(groupImageView)
        groupImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: profileImageDimension, height: profileImageDimension)
        groupImageView.layer.cornerRadius = profileImageDimension / 2
        groupImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        addSubview(groupsNameLabel)
        groupsNameLabel.anchor(top: groupImageView.topAnchor, left: groupImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        //textLabel?.text = "Group Name Here"
        //detailTextLabel?.text = "Group caption here"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

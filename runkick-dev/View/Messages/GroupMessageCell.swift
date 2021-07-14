//
//  GroupMessageCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 10/12/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase


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
            
            guard let groupId = group?.groupId else { return }
            calculateMemberCount(groupId: groupId)
            
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
    

    
    lazy var groupsNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        //label.font = UIFont(name: "ArialRoundedMT", size: 13)
        label.font = UIFont(name: "ArialRoundedMTBold", size: 13)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        //return label

        label.isUserInteractionEnabled = true

        return label
    } ()
    
    lazy var groupDetailsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Group tag line here."
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        //label.font = UIFont(name: "ArialRoundedMTBold", size: 12)
        label.textColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        label.isUserInteractionEnabled = true
        return label
    } ()
    
    lazy var numOfGroupMembers: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "12"
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.isUserInteractionEnabled = true
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
    
    func calculateMemberCount(groupId: String) {
        var numberOfMembers: Int!
        
        
        DataService.instance.REF_USER_GROUPS.child(groupId).child("members").observe(.value) { (snapshot) in

            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                
                numberOfMembers = snapshot.count
                print("GROUP ID >>>>>>>>>>>>>>>>>>>>>>> \(numberOfMembers)")
                
             
            } else {
                numberOfMembers = 0
            }
            
            let attributedText = NSMutableAttributedString(string: String(numberOfMembers), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)])
            attributedText.append(NSAttributedString(string: " members", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 120, green: 120, blue: 120)]))
            //label.attributedText = attributedText
            
            self.numOfGroupMembers.attributedText = attributedText
            
        }
        

        
        
    }
    
    func configureComponents() {
        
        
        let profileImageDimension = CGFloat(42)
        addSubview(groupImageView)
        groupImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: profileImageDimension, height: profileImageDimension)
        groupImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //groupImageView.layer.cornerRadius = profileImageDimension / 6
        groupImageView.layer.cornerRadius = profileImageDimension / 2.45
        groupImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        
        addSubview(groupsNameLabel)
        groupsNameLabel.anchor(top: groupImageView.topAnchor, left: groupImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        addSubview(groupDetailsLabel)
        groupDetailsLabel.anchor(top: groupsNameLabel.bottomAnchor, left: groupsNameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(numOfGroupMembers)
        numOfGroupMembers.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 40, width: 0, height: 0)
        numOfGroupMembers.centerYAnchor.constraint(equalTo: groupImageView.centerYAnchor).isActive = true
        
    
        
        //textLabel?.text = "Group Name Here"
        //detailTextLabel?.text = "Group caption here"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


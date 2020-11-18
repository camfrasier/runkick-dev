//
//  GroupStatisticsCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 11/13/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit

class GroupStatisticsCell: UITableViewCell {
    
    // Mark: - Properties
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageURL else { return }
            guard let username = user?.username else { return }
            guard let firstname = user?.firstname else { return }
            
            profileImageView.loadImage(with: profileImageUrl)
            self.usernameLabel.text = username
            self.firstnameLabel.text = firstname
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "userProfileIcon")
        iv.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        return iv
    } ()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.text = "Username"
        return label
    }()
    
    let firstnameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.text = "Firstname"
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        //self.textLabel?.text = "Top Users Statistics Here"
    
        self.selectionStyle = .default
        
        configureViewComponents()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        /*
        textLabel?.frame = CGRect(x: 20, y: textLabel!.frame.origin.y + 2, width: textLabel!.frame.width + 50, height: (textLabel?.frame.height)!)
        textLabel?.font = UIFont.systemFont(ofSize: 16)
        textLabel?.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        */
        
    }
    
    func configureViewComponents() {
        
        let postImageDimension = CGFloat(35)
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: postImageDimension, height: postImageDimension)
        profileImageView.layer.cornerRadius = postImageDimension / 2
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  SearchUserCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/30/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit

class SearchUserCell: UITableViewCell {
    
    // Mark: - Properties
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageURL else { return }
            guard let username = user?.username else { return }
            guard let firstname = user?.firstname else { return }
            
            profileImageView.loadImage(with: profileImageUrl)
            
            self.textLabel?.text = username
            self.detailTextLabel?.text = firstname
        }
    }

    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "userProfileIcon")
        //iv.layer.borderWidth = 4
        //iv.layer.borderColor = UIColor.lightGray.cgColor
        return iv
    } ()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        // Add profile image view.
        let profileImageDimension = CGFloat(50)
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: profileImageDimension, height: profileImageDimension)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        
        self.textLabel?.text = "Username"
        
        self.detailTextLabel?.text = "Full Name"
    
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 70, y: textLabel!.frame.origin.y + 2, width: textLabel!.frame.width + 50, height: (textLabel?.frame.height)!)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        detailTextLabel?.frame = CGRect(x: 70, y: detailTextLabel!.frame.origin.y, width: self.frame.width, height: detailTextLabel!.frame.height)
        detailTextLabel?.textColor = .lightGray
        detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

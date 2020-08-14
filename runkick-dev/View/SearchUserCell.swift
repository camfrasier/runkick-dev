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
            
            self.textLabel?.text = firstname
            self.detailTextLabel?.text = String("@\(username)")
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
    
    let separatorView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220).cgColor
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        // Add profile image view.
        let profileImageDimension = CGFloat(55)
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
        
        textLabel?.frame = CGRect(x: 80, y: textLabel!.frame.origin.y - 1, width: textLabel!.frame.width + 50, height: (textLabel?.frame.height)!)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        /*
        detailTextLabel?.frame = CGRect(x: 72, y: detailTextLabel!.frame.origin.y - 3, width: detailTextLabel!.frame.width + 50, height: detailTextLabel!.frame.height)
        detailTextLabel?.textColor = UIColor.rgb(red: 130, green: 130, blue: 130)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        */
        
        addSubview(detailTextLabel!)
        detailTextLabel?.anchor(top: textLabel?.bottomAnchor, left: textLabel?.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        detailTextLabel?.textColor = UIColor.rgb(red: 130, green: 130, blue: 130)
        //detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        
        detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: 15)
        
        //addSubview(separatorView)
        //separatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

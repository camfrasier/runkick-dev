//
//  SearchUserCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/30/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit

class SearchUserCell: UITableViewCell {
    
    var delegate: SearchCellDelegate?
    // Mark: - Properties
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageURL else { return }
            guard let username = user?.username else { return }
            //guard let firstname = user?.firstname else { return }
            
            profileImageView.loadImage(with: profileImageUrl)
            
           // self.textLabel?.text = firstname
            self.usernameLabel.text = String("\(username)")
        }
    }
    
    var notification: Notification? {
        
        // we create here a custom object to populate the cells
        didSet {
            guard let user = notification?.user else { return }
    
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
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        //label.font = UIFont(name: "ArialRoundedMT", size: 13)
        label.font = UIFont(name: "ArialRoundedMTBold", size: 13)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        //return label

        label.isUserInteractionEnabled = true

        return label
    } ()
    
    lazy var activeStatusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "active"
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        //label.font = UIFont(name: "ArialRoundedMTBold", size: 12)
        label.textColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        //return label

        label.isUserInteractionEnabled = true

        return label
    } ()
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 13)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    } ()
    
    
    let separatorView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220).cgColor
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        // Add profile image view.
        let profileImageDimension = CGFloat(40)
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: profileImageDimension, height: profileImageDimension)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        
        //self.textLabel?.text = "Username"
        
        self.usernameLabel.text = "Full Name"
    
        self.selectionStyle = .none
        
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        configureFollowFollowing()
         /*
        textLabel?.frame = CGRect(x: 80, y: textLabel!.frame.origin.y - 1, width: textLabel!.frame.width + 50, height: (textLabel?.frame.height)!)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        textLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 15)
       
        detailTextLabel?.frame = CGRect(x: 72, y: detailTextLabel!.frame.origin.y - 3, width: detailTextLabel!.frame.width + 50, height: detailTextLabel!.frame.height)
        detailTextLabel?.textColor = UIColor.rgb(red: 130, green: 130, blue: 130)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        */
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        addSubview(activeStatusLabel)
        activeStatusLabel.anchor(top: usernameLabel.bottomAnchor, left: usernameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        
        //addSubview(separatorView)
        //separatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
    }
    
    func configureFollowFollowing() {
        
        //guard let notification = self.notification else { return }
        //guard let user = notification.user else { return }

             
        addSubview(followButton)
        followButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 100, height: 25)
        followButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        followButton.layer.cornerRadius = 3

                       
        user?.checkIfUserIsFollowed (completion: { (followed) in
                           
        if followed {
                               //configure follow button for followed user
                               self.followButton.setTitle("Following", for: .normal)
            self.followButton.setTitleColor(UIColor.rgb(red: 80, green: 80, blue: 80), for: .normal)
                                self.followButton.titleLabel?.font =  UIFont(name: "HelveticaNeue", size: 13)
                               self.followButton.layer.borderWidth = 0.5
            self.followButton.layer.borderColor = UIColor.rgb(red: 180, green: 180, blue: 180).cgColor
                               self.followButton.backgroundColor = .white
          } else {
                               
                               // configured follow button for non-followed user
                               self.followButton.setTitle("Follow", for: .normal)
                               self.followButton.setTitleColor(.white, for: .normal)
                                self.followButton.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 13)
                               self.followButton.layer.borderWidth = 0
                               self.followButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
             }
        })
             

     }
    
    @objc func handleFollowTapped() {
        delegate?.handleFollowTapped(for: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

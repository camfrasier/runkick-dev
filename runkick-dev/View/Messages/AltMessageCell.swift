//
//  AltMessageCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/16/21.
//  Copyright © 2021 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

class AltMessageCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    
    var message: Message? {
        
        // setting in our message controller
        didSet {
            
            guard let messageText = message?.messageText else { return }
            detailTextLabel.text = messageText
            
            if let seconds = message?.creationDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                timestampLabel.text = dateFormatter.string(from: seconds)
            }
            configureUserData()
            configureMessageView()
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        return iv
    } ()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.text = "2h"
        return label
    } ()
    
    let separatorView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220).cgColor
        return view
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.font = UIFont(name: "ArialRoundedMTBold", size: 13)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        return label
    } ()
    
    let firstnameLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.font = UIFont(name: "ArialRoundedMTBold", size: 13)
        label.textColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        return label
    } ()
    
    let detailTextLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.textColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        label.numberOfLines = 0
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor


        /*
        let profileImageDimension = CGFloat(55)
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: profileImageDimension, height: profileImageDimension)
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        */
        
        let profileImageDimension = CGFloat(40)
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: profileImageDimension, height: profileImageDimension)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        
        addSubview(timestampLabel)
        timestampLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)
        timestampLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        

    }
    
    func configureUserData() {
        
        // using our message class function that retrieves partner id
        guard let chatPartnerId = message?.getChatPartnerId() else { return }
        
        Database.fetchUser(with: chatPartnerId) { (user) in
            self.profileImageView.loadImage(with: user.profileImageURL)
            self.firstnameLabel.text = user.firstname
            //self.usernameLabel.text = "@\(String(user.username ?? "?"))"
            self.usernameLabel.text = user.username
            
        }
    }
    
    func configureMessageView(){
        
        
        addSubview(firstnameLabel)
        firstnameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        addSubview(usernameLabel)
        usernameLabel.anchor(top: firstnameLabel.topAnchor, left: firstnameLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 2, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        
        addSubview(detailTextLabel)
        detailTextLabel.anchor(top: firstnameLabel.bottomAnchor, left: firstnameLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 90, width: 0, height: 0)


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//
//  ChatroomCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 12/1/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

class ChatroomCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    var message: ChatroomMessage? {
        
        didSet {
            
            guard let messageText = message?.messageText else { return }
            textView.text = messageText
            
            // need to also fetch the user name or message
            
            guard let userId = message?.fromId else { return }
        
            
            Database.fetchUser(with: userId) { (user) in
                guard let profileImageUrl = user.profileImageURL else { return }
                self.profileImageView.loadImage(with: profileImageUrl)
                
                guard let username = user.username else { return }
                
                self.usernameLabel.text = "\(username)"
            }
            
        }
    }
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 0, green: 127, blue: 249)
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    } ()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Sample text for now"
        tv.font = UIFont(name: "ArialRoundedMTBold", size: 14)
        tv.backgroundColor = .clear
        tv.textColor = .white
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        //tv.backgroundColor = UIColor.rgb(red: 255, green: 220, blue: 0)
        return tv
    } ()
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    } ()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        label.font = UIFont(name: "ArialRoundedMTBold", size: 14)
        label.backgroundColor = UIColor.rgb(red: 200, green: 145, blue: 0)
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        layer.backgroundColor = UIColor.walkzillaYellow().cgColor
        addSubview(bubbleView)
        
        addSubview(textView)
        
        /*
        addSubview(profileImageView)
        
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: -4, paddingRight: 0, width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        */
        
        
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: textView.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: frame.width - (frame.width / 3), width: 0, height: 0)
        //usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        // bubble view right anchor
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15)
        bubbleViewRightAnchor?.isActive = true

        
        // bubble view left anchor
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 2)
        bubbleViewLeftAnchor?.isActive = false
        
        // bubble view width and top anchor
        bubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        // bubble view text view anchors
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 6).isActive = true
        textView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 0).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

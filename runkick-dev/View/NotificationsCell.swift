//
//  NotificationsCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 9/17/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit

class NotificationsCell: UITableViewCell {
   
    // MARK: - Properties
    
    var delegate: NotificationCellDelegate?
    
    var notification: Notification? {
        
        // we create here a custom object to populate the cells
        didSet {
            guard let user = notification?.user else { return }
            guard let profileImageUrl = user.profileImageURL else { return }
            
            // configure notificaiton type
            configureNotificationType()
            
            // configure notification label
            configureNotificationLabel()
            
            profileImageView.loadImage(with: profileImageUrl)
            
            if let post = notification?.post {
                postImageView.loadImage(with: post.imageUrl)
            }
            
            
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        //iv.layer.borderWidth = 4
        //iv.layer.borderColor = UIColor.lightGray.cgColor
        return iv
    } ()
    
    lazy var notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        //label.font = UIFont(name: "ArialRoundedMT", size: 13)
        label.font = UIFont(name: "HelveticaNeue", size: 13)
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
        label.isUserInteractionEnabled = true
        return label
    } ()
    

    
    lazy var postHyperLabel: UIButton = {
        let button = UIButton(type: .custom)
        //button.addTarget(self, action: #selector(handlePostTapped), for: .touchUpInside)
        button.titleLabel?.font =  UIFont(name: "ArialRoundedMTBold", size: 15)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "notificationBell"), for: .normal)
        return button
    }()
    
    /*
    lazy var postHyperLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        label.text = "POST"
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        

        let postTap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        postTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(postTap)
        return label
    } ()
    */
    
    // must be a lazy variable and not a constant so it can be modified
    lazy var postImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderWidth = 0.20
        iv.layer.borderColor = UIColor.lightGray.cgColor
        
        // need to add a tap gesture recogizer here because it is not a button
        let postTap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        postTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(postTap)
        
        return iv
    } ()

    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    } ()
    
    let separatorView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220).cgColor
        return view
    }()
    
    
    // MARK: - Handlers
    
    
    @objc func handleFollowTapped() {
        delegate?.handleFollowTapped(for: self)
    }
    
    
    @objc func handlePostTapped() {
        // the self below can be traced in the protocols section as it refers to the notification cell itself
        delegate?.handlePostTapped(for: self)
    }
    
    func configureNotificationLabel() {
        
        guard let notification = self.notification else { return }
        guard let user = notification.user else { return }
        guard let username = user.username else { return }

        
        
        
        
        
        guard let notificationDate = getNotificationTimeStamp() else { return }
        
        // this presents the notification message. need one for one someone messages
        let notificationMessage = notification.notificationType.description
        
        
        
        let attributedText = NSMutableAttributedString(string: "\(username)", attributes: [NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 13)!, NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 0, green: 0, blue: 0)])
      
        //"\(notificationMessage) \(postHyperLabel.titleLabel?.text ?? "")."
        

            
        attributedText.append(NSAttributedString(string: "\(notificationMessage).", attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 13)!, NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 40, green: 40, blue: 40)]))
            
        attributedText.append(NSAttributedString(string: " \(notificationDate)", attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 13)!, NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 140, green: 140, blue: 140)]))
        
        
        notificationLabel.attributedText = attributedText
    }
    
    func configureNotificationType() {
        
        
        guard let notification = self.notification else { return }
        guard let user = notification.user else { return }
       
        
        if notification.notificationType == .Follow {
            
            /*
                      addSubview(followButton)
                      followButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 90, height: 30)
                      followButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                      followButton.layer.cornerRadius = 3

                      
                      user.checkIfUserIsFollowed (completion: { (followed) in
                          
                          if followed {
                              //configure follow button for followed user
                              self.followButton.setTitle("Following", for: .normal)
                              self.followButton.setTitleColor(.black, for: .normal)
                              self.followButton.layer.borderWidth = 0.5
                              self.followButton.layer.borderColor = UIColor.lightGray.cgColor
                              self.followButton.backgroundColor = .white
                          } else {
                              
                              // configured follow button for non-followed user
                              self.followButton.setTitle("Follow", for: .normal)
                              self.followButton.setTitleColor(.white, for: .normal)
                              self.followButton.layer.borderWidth = 0
                              self.followButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
                          }
                      })
            */
            /*
            // notification type is comment or like
            let postImageDimension = CGFloat(40)
            addSubview(postImageView)
            postImageView.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: postImageDimension, height: postImageDimension)
            postImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            postImageView.layer.cornerRadius = 3
            */
        }
        
    
        addSubview(notificationLabel)
        notificationLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 3, paddingLeft: 15, paddingBottom: 0, paddingRight: 80, width: 0, height: 0)
        //notificationLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        //addSubview(separatorView)
        //separatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
    }
    
    func getNotificationTimeStamp() -> String? {
        
        guard let notification = self.notification else { return nil }
        
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        dateFormatter.maximumUnitCount = 1
        dateFormatter.unitsStyle = .abbreviated
        let now = Date()
        return dateFormatter.string(from: notification.creationDate, to: now)
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let profileImageDimension = CGFloat(40)
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: profileImageDimension, height: profileImageDimension)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        
        
        self.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        addSubview(activeStatusLabel)
        activeStatusLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 18, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } 
    
}



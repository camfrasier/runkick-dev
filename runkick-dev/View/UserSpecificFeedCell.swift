//
//  UserSpecificFeedCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 4/12/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel

class UserSpecificFeedCell: UICollectionViewCell {
    
    var post: Post? {
        
        didSet {
            
            guard let ownerUid = post?.ownerUid else { return }
            guard let imageUrl = post?.imageUrl else { return }
            guard let likes = post?.likes else { return }
            
            Database.fetchUser(with: ownerUid) { (user) in  // In order to grab the photo of the correct post owner.
                
                self.profileImageView.loadImage(with: user.profileImageURL)
                self.usernameButton.setTitle("@\(user.username ?? "")", for: .normal)
                self.firstnameButton.setTitle(user.firstname, for: .normal)
                self.lastnameButton.setTitle(user.lastname, for: .normal)
                self.configurePostCaption(user: user)
            }
            
            postImageView.loadImage(with: imageUrl)
            
            likesLabel.text = "\(likes)"
            configureLikeButton()
        }
    }
    
    lazy var backgroundPostView: UIView = {
        let view = UIView()
        return view
    }()
    
    let profileImageView: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let circleDotView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3 / 2
        view.backgroundColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        return view
    }()
        
    lazy var captionBlock: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var usernameButton: UIButton = {  // We need to use a lazy var when converting a button into an action within a cell class.
        let button = UIButton(type: .system)
        button.setTitle("Username", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var firstnameButton: UIButton = {  // We need to use a lazy var when converting a button into an action within a cell class.
        let button = UIButton(type: .system)
        button.setTitle("Firstname", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var lastnameButton: UIButton = {  // We need to use a lazy var when converting a button into an action within a cell class.
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var optionsButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "simpleDownArrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleOptionTapped), for: .touchUpInside)
        return button
    } ()
    
    lazy var backgroundOptionsButton: UIView = {
        let view = UIView()
        let optionTap = UITapGestureRecognizer(target: self, action: #selector(handleOptionTapped))
        optionTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(optionTap)
        return view
    }()
    
    lazy var postImageView: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapped))
        likeTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.layer.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1).cgColor
        iv.addGestureRecognizer(likeTap)
        //iv.layer.cornerRadius = 12
        
        return iv
    } ()
    
    lazy var usernameSymbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "@"
        label.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        return label
    } ()
    
    let hometownLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(red: 26/255, green: 172/255, blue: 239/255, alpha: 1)
        label.textAlignment = .center
        label.text = "Huntington, CA"
        return label
    } ()
    
    let captionLabel: ActiveLabel = { // Will replace later with an action label.
        let label = ActiveLabel()
        label.numberOfLines = 0
        label.text = "This is example text for the post that is not currently here."
        return label
    } ()
    
    let postTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        label.text = "2 days ago"
        return label
    } ()
    
    let separatorView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        view.backgroundColor = UIColor(red: 188/255, green: 208/255, blue: 214/255, alpha: 1)
        return view
    }()
    
    let tlProgressBarView: UIView = {
        let view = UIView()
        return view
    } ()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        //label.layer.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        //label.layer.cornerRadius = 20 / 2
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "0"
        label.textAlignment = .center
        label.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        
        // add gesture recognizer to label
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(handleCommentTapped))
        commentTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(commentTap)
        
        return label
    } ()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        //button.layer.borderWidth = 1
        //button.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        //button.layer.cornerRadius = 30 / 2
        return button
    } ()
    
    lazy var likesLabel: UILabel = {
        let label = UILabel()
        //label.layer.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        //label.layer.cornerRadius = 20 / 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "3 likes"
        label.textAlignment = .center
        label.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        
        // add gesture recognizer to label
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleShowLikes))
        likeTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(likeTap)
        
        return label
    } ()
    
    lazy var likesButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "like_unselected"), for: .normal)
        button.addTarget(self, action: #selector(handleShowLikes), for: .touchUpInside)
        return button
    } ()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContraints()
        backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 240)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Handlers / Selectors
    
    @objc func handleUsernameTapped() {
        print("handle user posts username tapped")
        //delegate?.handleUsernameTapped(for: self)
    }
    
    @objc func handleLikeTapped() {
        print("handle user posts liked tapped")
        //delegate?.handleLikeTapped(for: self, isDoubleTap: false)
    }
    
    @objc func handleOptionTapped() {
        print("handle user posts options tapped")
        //delegate?.handleOptionTapped(for: self)
    }
    
    @objc func handleCommentTapped() {
        print("handle user posts comment tapped")
        //delegate?.handleCommentTapped(for: self)
    }
    
    @objc func handleShowLikes() {
        print("handle user posts show liked tapped")
        //delegate?.handleShowLikes(for: self)
    }
    
    @objc func handlePhotoTapped() {
        print("handle user posts photo tapped")
        //delegate?.handlePhotoTapped(for: self)
    }
    
    //  this api call is not linked to a particular action
    func configureLikeButton() {
        //delegate?.handleConfigureLikeButton(for: self)
    }
    
    
    
    func configureContraints() {
        
      // background for post
            addSubview(backgroundPostView)
            backgroundPostView.translatesAutoresizingMaskIntoConstraints = false
            backgroundPostView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
            backgroundPostView.layer.cornerRadius = 0
                    
            // photo attributes and constraints
            backgroundPostView.addSubview(postImageView)
            postImageView.translatesAutoresizingMaskIntoConstraints = false
            postImageView.layer.cornerRadius = 6
            
            // caption attributes and constraints
            backgroundPostView.addSubview(captionLabel)
            captionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // profile attributes and constraints
            backgroundPostView.addSubview(profileImageView)
            profileImageView.translatesAutoresizingMaskIntoConstraints = false
            profileImageView.layer.cornerRadius = 45 / 2
        
            
            // name attributes and constraints
            backgroundPostView.addSubview(firstnameButton)
            firstnameButton.translatesAutoresizingMaskIntoConstraints = false
            
            backgroundPostView.addSubview(lastnameButton)
            lastnameButton.translatesAutoresizingMaskIntoConstraints = false
            
            // username attributes and constraints
            backgroundPostView.addSubview(usernameButton)
            usernameButton.translatesAutoresizingMaskIntoConstraints = false

            // date and time attributes and constraints
            backgroundPostView.addSubview(postTimeLabel)
            postTimeLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // date and time attributes and constraints
            backgroundPostView.addSubview(circleDotView)
            circleDotView.translatesAutoresizingMaskIntoConstraints = false
            
            //options background
            addSubview(backgroundOptionsButton)
            backgroundOptionsButton.translatesAutoresizingMaskIntoConstraints = false
            backgroundOptionsButton.backgroundColor = .clear
            //backgroundOptionsButton.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
            
            // option button constraints
            backgroundOptionsButton.addSubview(optionsButton)
            optionsButton.translatesAutoresizingMaskIntoConstraints = false
            optionsButton.tintColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
            
            // show likes button and label attributes and constraints
            backgroundOptionsButton.addSubview(likesButton)
            likesButton.translatesAutoresizingMaskIntoConstraints = false
                   
            backgroundOptionsButton.addSubview(likesLabel)
            likesLabel.translatesAutoresizingMaskIntoConstraints = false

            // press to comment button
            backgroundOptionsButton.addSubview(commentButton)
            commentButton.translatesAutoresizingMaskIntoConstraints = false
            
            backgroundOptionsButton.addSubview(commentLabel)
            commentLabel.translatesAutoresizingMaskIntoConstraints = false
            
            
            // Header and footer constraints
            
            backgroundPostView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
            
            profileImageView.anchor(top: backgroundPostView.topAnchor, left: backgroundPostView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 26, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
            profileImageView.layer.cornerRadius = 50 / 2
            
            firstnameButton.anchor(top: backgroundPostView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 14, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            
            lastnameButton.anchor(top: firstnameButton.topAnchor, left: firstnameButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            
            usernameButton.anchor(top: backgroundPostView.topAnchor, left: firstnameButton.leftAnchor, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            
            circleDotView.anchor(top: backgroundPostView.topAnchor, left: usernameButton.rightAnchor, bottom: nil, right: nil, paddingTop: 47, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 3, height: 3)
            
            postTimeLabel.anchor(top: backgroundPostView.topAnchor, left: circleDotView.rightAnchor, bottom: nil, right: nil, paddingTop: 39, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            
            backgroundOptionsButton.anchor(top: backgroundPostView.topAnchor, left: nil, bottom: nil, right: backgroundPostView.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 35, height: 35)
            backgroundOptionsButton.layer.cornerRadius = 35 / 2
            
            
            
            commentButton.anchor(top: postImageView.bottomAnchor, left: postImageView.leftAnchor, bottom: nil, right: nil, paddingTop: 19, paddingLeft: 2, paddingBottom: 0, paddingRight: 0, width: 16, height: 14)
            
            commentLabel.anchor(top: postImageView.bottomAnchor, left: commentButton.rightAnchor, bottom: nil, right: nil, paddingTop: 18, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            
            likesButton.anchor(top: commentButton.topAnchor, left: commentLabel.rightAnchor, bottom: backgroundPostView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 35, paddingBottom: 14, paddingRight: 0, width: 16, height: 14)
            
            likesLabel.anchor(top: commentLabel.topAnchor, left: likesButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

            //stackView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
            
            
            // Horizontal Constraints
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-24-[caption]-24-|", options: [], metrics: nil, views: ["caption": captionLabel]))
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-24-[image]-24-|", options: [], metrics: nil, views: ["image": postImageView]))
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[optionsButton(16)]", options: [], metrics: nil, views: ["optionsButton": optionsButton]))
            
            // Vertical Constraints
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[profile]-1-[caption]-5-[image(190)]", options: [], metrics: nil, views: ["profile": profileImageView, "caption": captionLabel, "image": postImageView]))

            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-14-[optionsButton(8)]", options: [], metrics: nil, views: ["optionsButton": optionsButton]))
   
    }
    
    
    func configurePostCaption(user: User) {
        
        guard let post = self.post else { return }
        guard let caption = post.caption else { return }  // Safely unwrap so we don't get this as an optional anymore.
        guard let username = post.user?.username else { return }
        
        // look for username as pattern
        let customType = ActiveType.custom(pattern: "^\(username)\\b")
        
        // enable username as custom type
        captionLabel.enabledTypes = [.mention, .hashtag, .url, customType]
        
        // configure username link attributes
        captionLabel.configureLinkAttribute = { (type, attributes, isSelected) in
            var atts = attributes

            switch type {
            case .custom:
                atts[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 15)
            default: ()
            }
            return atts
        }
        
        
        
        // setting max number of lines shown under the caption
        captionLabel.customize { (label) in
            label.text = "\(caption)"
            label.customColor[customType] = .black
            label.font = UIFont.systemFont(ofSize: 15)
            //label.font = UIFont(name: "Arial Rounded MT Bold", size: 10)
            label.textColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
            captionLabel.numberOfLines = 12
        
        }
        
        postTimeLabel.text = post.creationDate.timeAgoToDisplay()
    }
}

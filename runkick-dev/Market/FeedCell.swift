//
//  FeedCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 9/9/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel

protocol AltFeedCellDelegate {
    func presentPhotoFeedView(withFeedCell post: Post)
}

class FeedCell: UICollectionViewCell {
    // creating a variable of the type FeedCellDelegate that's optional
    var delegate: FeedCellDelegate?
    var altDelegate: AltFeedCellDelegate?
    
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
            
            likesLabel.text = "\(likes) likes"
            configureLikeButton()
            
            configureComments()
        }
    }
    
    // MARK: - Properties
    
    let profileImageView: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    
    lazy var backgroundPostView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var firstnameButton: UIButton = {  // We need to use a lazy var when converting a button into an action within a cell class.
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var lastnameButton: UIButton = {  // We need to use a lazy var when converting a button into an action within a cell class.
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
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
        likeTap.numberOfTapsRequired = 2
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        //iv.layer.cornerRadius = 12
        
        return iv
    } ()
    
    let gradientProfileView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var likesButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "like_unselected"), for: .normal)
        button.addTarget(self, action: #selector(handleShowLikes), for: .touchUpInside)
        return button
    } ()
    
    
    lazy var likesLabel: UILabel = {
        let label = UILabel()
        //label.layer.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        //label.layer.cornerRadius = 20 / 2
        label.font = UIFont.systemFont(ofSize: 14.5)
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
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        //button.layer.borderWidth = 1
        //button.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        //button.layer.cornerRadius = 30 / 2
        return button
    } ()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        //label.layer.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        //label.layer.cornerRadius = 20 / 2
        label.font = UIFont.systemFont(ofSize: 16)
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
    
    lazy var usernameSymbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "@"
        label.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        return label
    } ()
    
    let captionLabel: ActiveLabel = { // Will replace later with an action label.
        let label = ActiveLabel()
        //label.lineBreakMode = NSLineBreakMode.byWordWrapping
        //label.numberOfLines = 0
        return label
    } ()
    
    let postTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        label.text = "2 days ago"
        return label
    } ()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    let tlProgressBarView: UIView = {
        let view = UIView()
        return view
    } ()
    
    
    lazy var newLikeButton: UIButton = {
        let button = UIButton(type: .custom)
        //button.setImage(UIImage(named: "likeBox"), for: .normal)
        button.setImage(UIImage(named: "simpleBlueHeartGray"), for: .normal)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        //button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
        //button.layer.cornerRadius = 30 / 2
        return button
    } ()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        //label.textColor = UIColor(red: 26/255, green: 172/255, blue: 239/255, alpha: 1)
        label.textColor = UIColor.rgb(red: 26, green: 172, blue: 239)
        label.textAlignment = .center
        label.text = "Huntington, CA"
        return label
    } ()
    /*
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Comment"
        
        // add gesture recognizer to label
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(handleCommentTapped))
        commentTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(commentTap)
        return label
    } ()
 
    let messageButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setImage(UIImage(named: "messageBox-25x25"), for: .normal)
        button.setImage(UIImage(named: "speechIconBubbles-30x30"), for: .normal)
        button.tintColor = .black
        return button
    } ()
    
    
    let savePostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = .black
        return button
    } ()
    */
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContraints()
        
        configureViewComponents()
        
        
        
        backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
    }
    
    // MARK: - Handlers / Selectors
    
    @objc func handleUsernameTapped() {
        delegate?.handleUsernameTapped(for: self)
    }
    
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(for: self, isDoubleTap: false)
    }
    
    @objc func handleOptionTapped() {
        delegate?.handleOptionTapped(for: self)
    }
    
    @objc func handleCommentTapped() {
        print("comment tapped")
        delegate?.handleCommentTapped(for: self)
    }
    
    @objc func handleShowLikes() {
         print("show likes tapped")
        delegate?.handleShowLikes(for: self)
    }
    
    @objc func handlePhotoTapped() {
        delegate?.handleLikeTapped(for: self, isDoubleTap: true)
    }
    
    //  this api call is not linked to a particular action
    func configureLikeButton() {
        delegate?.handleConfigureLikeButton(for: self)
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        /*
        if sender.state == .began {
            print("Long press did begin..")
        } else if sender.state == .ended {
            print("Long press did end..")
        }
         */
        
        if sender.state == .began {
            guard let post = self.post else { return }
            altDelegate?.presentPhotoFeedView(withFeedCell: post)
        }
    }
    
    // MARK: - Helper Functions
    
    func configureViewComponents() {
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.addGestureRecognizer(longPressGestureRecognizer)
        
    }
    
    func configureContraints() {
        
        

        /*
         
       
        // photo attributes and constraints
        addSubview(postImageView)
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        
        
        
        // hometown label attributes and constraints
        addSubview(hometownLabel)
        hometownLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // caption label attributes and constraints
        addSubview(captionBlock)
        captionBlock.translatesAutoresizingMaskIntoConstraints = false
        captionBlock.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        
        
        
        
        
        
        
        
        
         */
 
        /*
         
        // timeline view constraints
        addSubview(tlProgressBarView)
        tlProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        tlProgressBarView.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        
        
        
        // press to like button
        //postImageView.addSubview(newLikeButton)
        //newLikeButton.translatesAutoresizingMaskIntoConstraints = false

        //comment icon and label attributes and constraints
        //addSubview(commentIcon)
        //commentIcon.translatesAutoresizingMaskIntoConstraints = false

        */
        
        // background for post
        //addSubview(backgroundPostView)
        //backgroundPostView.translatesAutoresizingMaskIntoConstraints = false
        //backgroundPostView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //backgroundPostView.layer.cornerRadius = 0
        
        addSubview(gradientProfileView)
        gradientProfileView.translatesAutoresizingMaskIntoConstraints = false
        //gradientProfileView.layer.cornerRadius = 45 / 2
        
        // profile attributes and constraints
        gradientProfileView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        //profileImageView.layer.cornerRadius = 40 / 2
        
        // photo attributes and constraints
        addSubview(postImageView)
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.layer.cornerRadius = 13
        postImageView.layer.borderColor = UIColor.rgb(red: 200, green: 200, blue: 200).cgColor
        postImageView.layer.borderWidth = 0.25
        
        // caption attributes and constraints
        addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // name attributes and constraints
        addSubview(firstnameButton)
        firstnameButton.translatesAutoresizingMaskIntoConstraints = false
        
        //addSubview(lastnameButton)
        //lastnameButton.translatesAutoresizingMaskIntoConstraints = false
        
        // username attributes and constraints
        addSubview(usernameButton)
        usernameButton.translatesAutoresizingMaskIntoConstraints = false

        // date and time attributes and constraintsf
        addSubview(postTimeLabel)
        postTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // date and time attributes and constraints
        addSubview(circleDotView)
        circleDotView.translatesAutoresizingMaskIntoConstraints = false
        
        // separator view constraints
        addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
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
        //backgroundOptionsButton.addSubview(likesButton)
        //likesButton.translatesAutoresizingMaskIntoConstraints = false
               
        addSubview(likesLabel)
        likesLabel.translatesAutoresizingMaskIntoConstraints = false

        // press to comment button
        //backgroundOptionsButton.addSubview(commentButton)
        //commentButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(commentLabel)
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        // Header and footer constraints
        
        //backgroundPostView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 1, paddingLeft: 8, paddingBottom: 1, paddingRight: 8, width: 0, height: 0)
        
        let profileCircleDimension: CGFloat = 60
        gradientProfileView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: profileCircleDimension, height: profileCircleDimension)
        gradientProfileView.layer.cornerRadius = profileCircleDimension / 2
        
        let profileDimension: CGFloat = 55
        profileImageView.anchor(top: gradientProfileView.topAnchor, left: gradientProfileView.leftAnchor, bottom: nil, right: nil, paddingTop: 2.5, paddingLeft: 2.5, paddingBottom: 0, paddingRight: 0, width: profileDimension, height: profileDimension)
        profileImageView.layer.cornerRadius = profileDimension / 2
        profileImageView.layer.borderWidth = 2.5
        profileImageView.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        
        //firstnameButton.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //lastnameButton.anchor(top: firstnameButton.topAnchor, left: firstnameButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //usernameButton.anchor(top: topAnchor, left: firstnameButton.leftAnchor, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //circleDotView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 3, height: 3)
        
        //postTimeLabel.anchor(top: topAnchor, left: circleDotView.rightAnchor, bottom: nil, right: nil, paddingTop: 39, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        backgroundOptionsButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 22, width: 35, height: 35)
        backgroundOptionsButton.layer.cornerRadius = 35 / 2
        
        separatorView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
        
        
        //commentButton.anchor(top: postImageView.bottomAnchor, left: postImageView.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 2, paddingBottom: 0, paddingRight: 0, width: 16, height: 14)
        
        //commentLabel.anchor(top: nil, left: postImageView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //likesButton.anchor(top: commentButton.topAnchor, left: commentLabel.rightAnchor, bottom: backgroundPostView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 35, paddingBottom: 20, paddingRight: 0, width: 16, height: 14)
        
//likesLabel.anchor(top: commentLabel.topAnchor, left: commentLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 14, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        //stackView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        
        // Horizontal Constraints
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[gradient]-7-[caption]-40-|", options: [], metrics: nil, views: ["gradient": gradientProfileView, "caption": captionLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[gradient]-7-[image]-48-|", options: [], metrics: nil, views: ["gradient": gradientProfileView, "image": postImageView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[gradient]-10-[comment]-24-[like]", options: [], metrics: nil, views: ["gradient": gradientProfileView, "comment": commentLabel, "like": likesLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[optionsButton(16)]", options: [], metrics: nil, views: ["optionsButton": optionsButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[gradient]-7-[firstname]-2-[username]-1.5-[dot(3)]-1.5-[date]", options: [], metrics: nil, views: ["gradient": gradientProfileView, "firstname": firstnameButton, "username": usernameButton, "dot": circleDotView, "date": postTimeLabel]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[separator]-|", options: [], metrics: nil, views: ["separator": separatorView]))
        
        
        
        // Vertical Constraints
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[firstname]-(-5)-[caption]-8-[image]-10-[comment]-10-|", options: [], metrics: nil, views: ["firstname": firstnameButton, "caption": captionLabel, "image": postImageView, "comment": commentLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[image]-10-[like]-|", options: [], metrics: nil, views: ["image": postImageView, "like": likesLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[image]-10-[comment]-|", options: [], metrics: nil, views: ["image": postImageView, "comment": commentLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[username]", options: [], metrics: nil, views: ["username": usernameButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-25-[dot(3)]", options: [], metrics: nil, views: ["dot": circleDotView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[date]", options: [], metrics: nil, views: ["date": postTimeLabel]))

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-14-[optionsButton(8)]", options: [], metrics: nil, views: ["optionsButton": optionsButton]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[separator(0.50)]", options: [], metrics: nil, views: ["separator": separatorView]))

        
        // horizontal constraints
        
        //self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[postBackground]-20-|", options: [], metrics: nil, views: ["postBackground": backgroundPostView]))

        //self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[caption]-0-|", options: [], metrics: nil, views: ["caption": captionLabel]))

        
        
        /*
         postImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
         captionBlock.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        */

        
        
        /*
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 125, height: 137)
        postImageView.layer.cornerRadius = 0
        
        
        
        firstnameButton.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 9, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        usernameSymbolLabel.anchor(top: firstnameButton.topAnchor, left: firstnameButton.rightAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 2, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        usernameButton.anchor(top: firstnameButton.topAnchor, left: usernameSymbolLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        hometownLabel.anchor(top: firstnameButton.bottomAnchor, left: firstnameButton.leftAnchor, bottom: nil, right: nil, paddingTop: -8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        captionBlock.anchor(top: profileImageView.bottomAnchor, left: profileImageView.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        
        separatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
        
        commentButton.anchor(top: postImageView.bottomAnchor, left: postImageView.leftAnchor, bottom: nil, right: nil, paddingTop: 14, paddingLeft: 2, paddingBottom: 0, paddingRight: 0, width: 18, height: 16)
        
        commentLabel.anchor(top: postImageView.bottomAnchor, left: commentButton.rightAnchor, bottom: nil, right: nil, paddingTop: 13, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        
        optionsButton.anchor(top: backgroundOptionsButton.topAnchor, left: backgroundOptionsButton.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 7, paddingBottom: 0, paddingRight: 0, width: 16, height: 8)
        
        

        
 
     */
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
                atts[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 16)
                //atts[NSAttributedString.Key.foregroundColor] = UIColor.rgb(red: 255, green: 0, blue: 0)
            default: ()
            }
            return atts
        }
        
        
        
        // setting max number of lines shown under the caption
        // to adjust the number of characters go to UpoloadPostVC
        captionLabel.customize { (label) in
            label.text = "\(caption)"
            label.customColor[customType] = .black
            label.font = UIFont.systemFont(ofSize: 16)
            //label.font = UIFont(name: "Arial Rounded MT Bold", size: 10)
            label.textColor = UIColor.rgb(red: 60, green: 60, blue: 60)
            captionLabel.numberOfLines = 8
        
        }
        
        postTimeLabel.text = post.creationDate.timeAgoToDisplay()
    }
    
    func configureComments() {
        
        var numberOfComments: Int!
        guard let post = self.post else { return }
        guard let postId = post.postId else { return }
        
        print("YOUR POST ID IS\(postId)")
        
        // get number of posts
        DataService.instance.REF_USER_POST_COMMENT.child(postId).observe(.value) { (snapshot) in

            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
               print(snapshot)
                
                numberOfComments = snapshot.count
            } else {
                numberOfComments = 0
            }

            let attributedText = NSMutableAttributedString(string: "\(numberOfComments!) comments", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.5)])
            
            self.commentLabel.attributedText = attributedText
        }
    }
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


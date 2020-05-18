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
                self.usernameButton.setTitle(user.username, for: .normal)
                self.firstnameButton.setTitle(user.firstname, for: .normal)
                self.configurePostCaption(user: user)
            }
            
            postImageView.loadImage(with: imageUrl)
            
            likesLabel.text = "\(likes)"
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
    
    /*
    lazy var backgroundPhotoCaptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    */
    
    let circleDotView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3 / 2
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
        likeTap.numberOfTapsRequired = 2
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        //iv.layer.cornerRadius = 12
        
        return iv
    } ()
    
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
        label.font = UIFont.systemFont(ofSize: 14)
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
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "@"
        label.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        return label
    } ()
    
    let captionLabel: ActiveLabel = { // Will replace later with an action label.
        let label = ActiveLabel()
        label.numberOfLines = 0
        return label
    } ()
    
    let postTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
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
    
    let hometownLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(red: 26/255, green: 172/255, blue: 239/255, alpha: 1)
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
        delegate?.handleCommentTapped(for: self)
    }
    
    @objc func handleShowLikes() {
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
        
        // profile attributes and constraints
        addSubview(profileImageView)
        profileImageView.layer.cornerRadius = 35 / 2
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
    
        addSubview(captionBlock)
        captionBlock.translatesAutoresizingMaskIntoConstraints = false
        captionBlock.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        // caption label attributes and constraints
        captionBlock.addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // photo attributes and constraints
        addSubview(postImageView)
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.layer.cornerRadius = 5
        
        // timeline view constraints
        addSubview(tlProgressBarView)
        tlProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        tlProgressBarView.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        
        // separator view constraints
        addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
        
        // firstname attributes and constraints
        addSubview(firstnameButton)
        firstnameButton.translatesAutoresizingMaskIntoConstraints = false
        
        // hometown label attributes and constraints
        addSubview(hometownLabel)
        hometownLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // date and time attributes and constraints
        addSubview(postTimeLabel)
        postTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        postTimeLabel.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        
        // date and time attributes and constraints
        addSubview(circleDotView)
        circleDotView.translatesAutoresizingMaskIntoConstraints = false
        circleDotView.backgroundColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1)
        
        //options background
        addSubview(backgroundOptionsButton)
        backgroundOptionsButton.backgroundColor = .clear
        
        // option button constraints
        backgroundOptionsButton.addSubview(optionsButton)
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.tintColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        
        addSubview(usernameSymbolLabel)
        usernameSymbolLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameSymbolLabel.tintColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        
        // username attributes and constraints
        addSubview(usernameButton)
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        
        // show likes button and label attributes and constraints
               addSubview(likesButton)
               likesButton.translatesAutoresizingMaskIntoConstraints = false
               
               addSubview(likesLabel)
               likesLabel.translatesAutoresizingMaskIntoConstraints = false

        // press to comment button
        addSubview(commentButton)
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(commentLabel)
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        

        //comment icon and label attributes and constraints
        //addSubview(commentIcon)
        //commentIcon.translatesAutoresizingMaskIntoConstraints = false
        
        // press to like button
        //postImageView.addSubview(newLikeButton)
        //newLikeButton.translatesAutoresizingMaskIntoConstraints = false


        

        
        // vertical constraints

      self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[caption]-0-|", options: [], metrics: nil, views: ["caption": captionLabel]))
        
        // horizontal constraints
        
        
      self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[caption]-0-|", options: [], metrics: nil, views: ["caption": captionLabel]))
        
  
        /*
         postImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
         captionBlock.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        */
        
        
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 35, height: 35)
        
        separatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
        
        firstnameButton.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        usernameSymbolLabel.anchor(top: firstnameButton.topAnchor, left: firstnameButton.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 2, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        usernameButton.anchor(top: firstnameButton.topAnchor, left: usernameSymbolLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        hometownLabel.anchor(top: firstnameButton.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: -8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        postImageView.anchor(top: firstnameButton.bottomAnchor, left: captionBlock.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 1, paddingLeft: 4, paddingBottom: 0, paddingRight: 16, width: 150, height: 150)
        
        backgroundOptionsButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 30, height: 20)
        
        optionsButton.anchor(top: backgroundOptionsButton.topAnchor, left: backgroundOptionsButton.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 14, height: 7)
        
        captionBlock.anchor(top: profileImageView.bottomAnchor
            , left: profileImageView.leftAnchor, bottom: nil, right: postImageView.leftAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
        
        //circleDotView.anchor(top: firstnameButton.topAnchor, left: usernameButton.rightAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 3, height: 3)
        
        postTimeLabel.anchor(top: postImageView.bottomAnchor, left: captionLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        commentButton.anchor(top: postImageView.bottomAnchor, left: postImageView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 17, height: 15)
        
        commentLabel.anchor(top: postImageView.bottomAnchor, left: commentButton.rightAnchor, bottom: nil, right: nil, paddingTop: 9, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        likesButton.anchor(top: postImageView.bottomAnchor, left: commentLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 17, height: 15)
        
        likesLabel.anchor(top: postImageView.bottomAnchor, left: likesButton.rightAnchor, bottom: nil, right: nil, paddingTop: 9, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
 
  
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
            label.font = UIFont.systemFont(ofSize: 15)
            //label.font = UIFont(name: "Arial Rounded MT Bold", size: 10)
            label.textColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
            captionLabel.numberOfLines = 12
        
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

            let attributedText = NSMutableAttributedString(string: "\(numberOfComments!)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
            
            self.commentLabel.attributedText = attributedText
        }
    }
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


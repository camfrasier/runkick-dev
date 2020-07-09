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
                
                //self.profileImageView.loadImage(with: user.profileImageURL)
                self.usernameButton.setTitle("@\(user.username ?? "")", for: .normal)
                self.firstnameButton.setTitle(user.firstname, for: .normal)
                self.lastnameButton.setTitle(user.lastname, for: .normal)
                self.configurePostCaption(user: user)
                
                guard let userProfileImage = user.profileImageURL else { return }
                self.profileImageView.loadImage(with: userProfileImage)
            }
            
            postImageView.loadImage(with: imageUrl)
            
            likesLabel.text = "\(likes)"
            configureLikeButton()
            
            configureComments()
        }
    }
    
    // MARK: - Properties
    
    
    
    lazy var profileImageView: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(handleUsernameTapped))
        profileTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(profileTap)
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
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        return view
    }()
    
    
    lazy var captionBlock: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        return view
    }()
    
    lazy var usernameButton: UIButton = {  // We need to use a lazy var when converting a button into an action within a cell class.
        let button = UIButton(type: .system)
        button.setTitle("Username", for: .normal)
        button.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 16)
        //button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255), for: .normal)
        button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var firstnameButton: UIButton = {  // We need to use a lazy var when converting a button into an action within a cell class.
        let button = UIButton(type: .system)
        //button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 14)
        button.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255), for: .normal)
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
        let image = UIImage(named: "optionDotsHorizantal")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleOptionTapped), for: .touchUpInside)
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.70).cgColor
        button.layer.shadowRadius = 1.0
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.alpha = 0.75
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
        return iv
    } ()
    
    let gradientProfileView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let gradientImageView: GradientClearView = {
        let view = GradientClearView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var likesButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "like_unselected"), for: .normal)
        button.addTarget(self, action: #selector(handleShowLikes), for: .touchUpInside)
        return button
    } ()
    
    /*
    lazy var newComment: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "newComment"), for: .normal)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        button.alpha = 80
        return button
    } ()
    */
    
    lazy var likesLabel: UILabel = {
        let label = UILabel()
        //label.layer.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        //label.layer.cornerRadius = 20 / 2
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "3 likes"
        label.textAlignment = .center
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        label.layer.shadowOpacity = 30 // Shadow is 30 percent opaque.
        label.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.90).cgColor
        label.layer.shadowRadius = 1.0
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        // add gesture recognizer to label
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleShowLikes))
        likeTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(likeTap)
        
        return label
    } ()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        //label.layer.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        //label.layer.cornerRadius = 20 / 2
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "0"
        label.textAlignment = .center
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        label.layer.shadowOpacity = 30 // Shadow is 30 percent opaque.
        label.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.90).cgColor
        label.layer.shadowRadius = 1.0
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        // add gesture recognizer to label
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(handleCommentTapped))
        commentTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(commentTap)
        
        return label
    } ()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .custom)
        //button.setImage(UIImage(named: "comment"), for: .normal)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        button.setTitle("Comments", for: .normal)
        button.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 12)
        //button.titleLabel?.font =  UIFont(name: "HelveticaNeue-CondensedBold", size: 14)
        button.layer.borderWidth = 0.50
        button.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        button.layer.cornerRadius = 1
        return button
    } ()
    
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        //button.setImage(UIImage(named: "comment"), for: .normal)
        button.addTarget(self, action: #selector(handleShowLikes), for: .touchUpInside)
        button.setTitle("Likes", for: .normal)
        button.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 13)
        //button.titleLabel?.font =  UIFont(name: "HelveticaNeue-CondensedBold", size: 14)
        button.layer.borderWidth = 0.50
        button.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        button.layer.cornerRadius = 1
        return button
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
    
    let actionCaption: UILabel = { // Will replace later with an action label.
        let label = UILabel()
        label.text = "This is how we do it!"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 45)
        label.setLineSpacing(lineSpacing: -2)
        label.numberOfLines = 3
        return label
    } ()
    
    let postTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
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
        button.setImage(UIImage(named: "heartOutline"), for: .normal)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    } ()
    
    lazy var newComment: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "newComment"), for: .normal)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        //button.layer.borderWidth = 1
        //button.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
        //button.layer.cornerRadius = 30 / 2
        button.alpha = 0.80
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
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
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
        
        //addBlurEffect()
        
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
    
    func addBlurEffect() {
        let bounds = backgroundOptionsButton.bounds
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundOptionsButton.addSubview(visualEffectView)
        visualEffectView.layer.cornerRadius = 35 / 2
        visualEffectView.clipsToBounds = true

        // Here you can add visual effects to any UIView control.
        // Replace custom view with navigation bar in the above code to add effects to the custom view.
    }
    
    func configureContraints() {
    
        
        // photo attributes and constraints
        addSubview(postImageView)
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.layer.cornerRadius = 0
        //postImageView.layer.borderColor = UIColor.rgb(red: 200, green: 200, blue: 200).cgColor
        //postImageView.layer.borderWidth = 0.25
        
        // post image gradient
        postImageView.addSubview(gradientImageView)
        gradientImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // large caption attributes and constraints
        postImageView.addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // press to comment button
        //postImageView.addSubview(commentButton)
        //commentButton.translatesAutoresizingMaskIntoConstraints = false
        
        // press to like button
        //postImageView.addSubview(likeButton)
        //likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        // profile attributes and constraints
        postImageView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // name attributes and constraints
        //postImageView.addSubview(firstnameButton)
        //firstnameButton.translatesAutoresizingMaskIntoConstraints = false
        
        // username attributes and constraints
        postImageView.addSubview(usernameButton)
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        
        // date and time attributes and constraintsf
        postImageView.addSubview(postTimeLabel)
        postTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // date and time attributes and constraints
        postImageView.addSubview(circleDotView)
        circleDotView.translatesAutoresizingMaskIntoConstraints = false
        
        //options background
        postImageView.addSubview(backgroundOptionsButton)
        backgroundOptionsButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundOptionsButton.backgroundColor = .clear
        backgroundOptionsButton.layer.cornerRadius = 35 / 2
        
        // option button constraints
        backgroundOptionsButton.addSubview(optionsButton)
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.tintColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        // action caption
        postImageView.addSubview(newLikeButton)
        newLikeButton.translatesAutoresizingMaskIntoConstraints = false
        
        postImageView.addSubview(likesLabel)
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        postImageView.addSubview(newComment)
        newComment.translatesAutoresizingMaskIntoConstraints = false
        
        postImageView.addSubview(commentLabel)
        commentLabel.translatesAutoresizingMaskIntoConstraints = false

        
        // large caption attributes and constraints
        //postImageView.addSubview(largeCaptionLabel)
        //largeCaptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        /*
        addSubview(gradientProfileView)
        gradientProfileView.translatesAutoresizingMaskIntoConstraints = false
        //gradientProfileView.layer.cornerRadius = 45 / 2
        
        
        
        
        
        // name attributes and constraints
        addSubview(firstnameButton)
        firstnameButton.translatesAutoresizingMaskIntoConstraints = false
        
        //addSubview(lastnameButton)
        //lastnameButton.translatesAutoresizingMaskIntoConstraints = false
        
        // username attributes and constraints
        addSubview(usernameButton)
        usernameButton.translatesAutoresizingMaskIntoConstraints = false

        
        // separator view constraints
        addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false

        
        */
 
 
        /*
        //options background
        addSubview(backgroundOptionsButton)
        backgroundOptionsButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundOptionsButton.backgroundColor = .clear
        //backgroundOptionsButton.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        // option button constraints
        backgroundOptionsButton.addSubview(optionsButton)
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.tintColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
        */
        
        // show likes button and label attributes and constraints
        //backgroundOptionsButton.addSubview(likesButton)
        //likesButton.translatesAutoresizingMaskIntoConstraints = false
               
        gradientImageView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 220)
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0.65)-[image]-(0.65)-|", options: [], metrics: nil, views: ["image": postImageView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[image]-0-|", options: [], metrics: nil, views: ["image": postImageView]))

        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0.40)-[image]-(0.40)-|", options: [], metrics: nil, views: ["image": postImageView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[image]-0-|", options: [], metrics: nil, views: ["image": postImageView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[caption]-65-|", options: [], metrics: nil, views: ["caption": captionLabel]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[caption]-15-[commentButton(30)]-15-|", options: [], metrics: nil, views: ["caption": captionLabel, "commentButton": commentButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[caption]-30-|", options: [], metrics: nil, views: ["caption": captionLabel]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[caption]-12-[likeButton(30)]-15-|", options: [], metrics: nil, views: ["caption": captionLabel, "likeButton": likeButton]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[commentButton(85)]-15-[likeButton(55)]", options: [], metrics: nil, views: ["commentButton": commentButton, "likeButton": likeButton]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[likeButton(60)]", options: [], metrics: nil, views: ["likeButton": likeButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-24-[username]-3-[circle(3)]-3-[date]", options: [], metrics: nil, views: ["username": usernameButton, "circle": circleDotView, "date": postTimeLabel]))
        
         addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[username(18)]-4-[caption]", options: [], metrics: nil, views: ["username": usernameButton, "caption": captionLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[circle(3)]-10-[caption]", options: [], metrics: nil, views: ["circle": circleDotView, "caption": captionLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[date(19)]-3-[caption]", options: [], metrics: nil, views: ["date": postTimeLabel, "caption": captionLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[profile(50)]-10-|", options: [], metrics: nil, views: ["profile": profileImageView]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[profile(50)]", options: [], metrics: nil, views: ["profile": profileImageView]))
        
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.layer.borderWidth = 1.5
        profileImageView.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[profile(50)]", options: [], metrics: nil, views: ["profile": profileImageView]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[profile(50)]", options: [], metrics: nil, views: ["profile": profileImageView, "username": usernameButton]))
        
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-200-[profile(50)]-45-[heartLike(30)]-45-[newComment(30)]", options: [], metrics: nil, views: ["profile": profileImageView, "heartLike": newLikeButton, "newComment": newComment]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[heartLike(35)]-18-|", options: [], metrics: nil, views: ["heartLike": newLikeButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[newComment(35)]-18-|", options: [], metrics: nil, views: ["newComment": newComment]))

        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[firstname]", options: [], metrics: nil, views: ["firstname": firstnameButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[backgroundOption(35)]-12-|", options: [], metrics: nil, views: ["backgroundOption": backgroundOptionsButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[backgroundOption(35)]", options: [], metrics: nil, views: ["backgroundOption": backgroundOptionsButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[optionsButton(28)]-10-|", options: [], metrics: nil, views: ["optionsButton": optionsButton]))
         
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-14-[optionsButton(28)]", options: [], metrics: nil, views: ["optionsButton": optionsButton]))
        
        likesLabel.anchor(top: newLikeButton.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        likesLabel.centerXAnchor.constraint(equalTo: newLikeButton.centerXAnchor).isActive = true
        
        commentLabel.anchor(top: newComment.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        commentLabel.centerXAnchor.constraint(equalTo: newLikeButton.centerXAnchor).isActive = true
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[actionCaption]-200-|", options: [], metrics: nil, views: ["actionCaption": actionCaption]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-250-[actionCaption]", options: [], metrics: nil, views: ["actionCaption": actionCaption]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-28-[circle(3)]", options: [], metrics: nil, views: ["circle": circleDotView]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[date]", options: [], metrics: nil, views: ["date": postTimeLabel]))
        
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[largeCaption]-80-|", options: [], metrics: nil, views: ["largeCaption": largeCaptionLabel]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-200-[largeCaption]", options: [], metrics: nil, views: ["largeCaption": largeCaptionLabel]))
        
        /*
        // Header and footer constraints
        
        let profileCircleDimension: CGFloat = 60
        gradientProfileView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: profileCircleDimension, height: profileCircleDimension)
        gradientProfileView.layer.cornerRadius = profileCircleDimension / 2
        
        let profileDimension: CGFloat = 55
        profileImageView.anchor(top: gradientProfileView.topAnchor, left: gradientProfileView.leftAnchor, bottom: nil, right: nil, paddingTop: 2.5, paddingLeft: 2.5, paddingBottom: 0, paddingRight: 0, width: profileDimension, height: profileDimension)
        profileImageView.layer.cornerRadius = profileDimension / 2
        profileImageView.layer.borderWidth = 2.5
        profileImageView.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        
        backgroundOptionsButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 22, width: 35, height: 35)
        backgroundOptionsButton.layer.cornerRadius = 35 / 2
        
        separatorView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
        
        
        // Horizontal Constraints
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[gradient]-7-[caption]-40-|", options: [], metrics: nil, views: ["gradient": gradientProfileView, "caption": captionLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[gradient]-7-[image]-48-|", options: [], metrics: nil, views: ["gradient": gradientProfileView, "image": postImageView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[gradient]-10-[comment]-24-[like]", options: [], metrics: nil, views: ["gradient": gradientProfileView, "comment": commentLabel, "like": likesLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[optionsButton(16)]", options: [], metrics: nil, views: ["optionsButton": optionsButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[gradient]-7-[firstname]-2-[username]-1.5-[dot(3)]-1.5-[date]", options: [], metrics: nil, views: ["gradient": gradientProfileView, "firstname": firstnameButton, "username": usernameButton, "dot": circleDotView, "date": postTimeLabel]))

        
        // Vertical Constraints
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[firstname]-(-5)-[caption]-8-[image]-10-[comment]-10-|", options: [], metrics: nil, views: ["firstname": firstnameButton, "caption": captionLabel, "image": postImageView, "comment": commentLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[image]-10-[like]-|", options: [], metrics: nil, views: ["image": postImageView, "like": likesLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[image]-10-[comment]-|", options: [], metrics: nil, views: ["image": postImageView, "comment": commentLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[username]", options: [], metrics: nil, views: ["username": usernameButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-25-[dot(3)]", options: [], metrics: nil, views: ["dot": circleDotView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[date]", options: [], metrics: nil, views: ["date": postTimeLabel]))

         
        
 
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
                atts[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 15)
                //atts[NSAttributedString.Key.foregroundColor] = UIColor.rgb(red: 255, green: 0, blue: 0)
            default: ()
            }
            return atts
        }
        
        
        // setting max number of lines shown under the caption
        // to adjust the number of characters go to UpoloadPostVC
        captionLabel.customize { (label) in
            label.text = "\(caption)"
            label.customColor[customType] = UIColor.rgb(red: 255, green: 255, blue: 255)
            label.font = UIFont.systemFont(ofSize: 15)
            //label.font = UIFont(name: "Arial Rounded MT Bold", size: 10)
            label.textColor = UIColor.rgb(red: 255, green: 255, blue: 255)
            captionLabel.numberOfLines = 5
        
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

            let attributedText = NSMutableAttributedString(string: "\(numberOfComments!)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.5)])
            
            self.commentLabel.attributedText = attributedText
        }
    }
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


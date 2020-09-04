//
//  CheckInCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 9/1/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel


class CheckInCell: UICollectionViewCell {
    
    // creating a variable of the type CheckInCellDelegate that's optional
    
    var delegate: CheckInCellDelegate?
    
    var post: Post? {
        
        didSet {
            
            guard let ownerUid = post?.ownerUid else { return }
            guard let imageUrl = post?.imageUrl else { return }
            guard let likes = post?.likes else { return }
            
            Database.fetchUser(with: ownerUid) { (user) in  // In order to grab the photo of the correct post owner.
                
                //self.profileImageView.loadImage(with: user.profileImageURL)
                //self.usernameButton.setTitle("@\(user.username ?? "")", for: .normal)
                self.usernameButton.setTitle(user.username, for: .normal)
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
            
            configureFollowFollowing()
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
    
    lazy var followFollowingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.text = "follow"
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        
        // add gesture recognizer for double tap to like
        let followFollowingTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowFollowingTapped))
        followFollowingTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followFollowingTap)
        return label
    } ()
    
    let circleDotView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2 / 2
        view.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        return view
    }()

    lazy var captionBlock: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        return view
    }()
    
    lazy var addCommentBlock: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        let addCommentTapped = UITapGestureRecognizer(target: self, action: #selector(handleCommentTapped))
        addCommentTapped.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(addCommentTapped)
        return view
    }()
    
    let likeCommentBlock: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        return view
    }()
    
    lazy var usernameButton: UIButton = {  // We need to use a lazy var when converting a button into an action within a cell class.
        let button = UIButton(type: .system)
        button.setTitle("Username", for: .normal)
        button.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 15)
        //button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.rgb(red: 0, green: 0, blue: 0), for: .normal)
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
        button.alpha = 1
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
    
    lazy var replyCommentLabel: UILabel = {
        let label = UILabel()
        //label.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Reply or add a comment... "
        label.textAlignment = .left
        label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        let replyCommentTapped = UITapGestureRecognizer(target: self, action: #selector(handleCommentTapped))
        replyCommentTapped.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(replyCommentTapped)
        return label
    } ()
    
    lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.text = "3"
        label.textAlignment = .center
        label.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        
        
        // add gesture recognizer to label
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleShowLikes))
        likeTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(likeTap)
        
        return label
    } ()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.text = "0"
        label.textAlignment = .center
        label.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        
        // add gesture recognizer to label
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(handleCommentTapped))
        commentTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(commentTap)
        return label
    } ()
    
    let captionLabel: ActiveLabel = { // Will replace later with an action label.
        let label = ActiveLabel()
        return label
    } ()
    
    let postTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        label.text = "2 days ago"
        return label
    } ()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    lazy var newLikeButton: UIButton = {
        let button = UIButton(type: .custom)
        //button.setImage(UIImage(named: "heartOutline"), for: .normal)
        button.setTitle("Like", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    } ()
    
    lazy var newLikeHeart: UIButton = {
        let button = UIButton(type: .system)  // will need to change to custom
        button.setImage(UIImage(named: "heartOutline"), for: .normal)
        button.addTarget(self, action: #selector(handleShowLikes), for: .touchUpInside)
        button.tintColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        button.alpha = 1
        return button
    } ()
    
    lazy var newCommentBubble: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "newCommentNonSelected"), for: .normal)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        button.tintColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        button.alpha = 1
        return button
    } ()
    
    lazy var newComment: UIButton = {
        let button = UIButton(type: .custom)
       // button.setImage(UIImage(named: "newComment"), for: .normal)        button.setTitle("Like", for: .normal)
        button.setTitle("Comment", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)

        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        button.alpha = 1
        return button
    } ()
    

    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContraints()

        backgroundColor = UIColor.rgb(red: 255, green: 0, blue: 0)
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
    
    @objc func handleFollowFollowingTapped() {
        delegate?.handleFollowFollowingTapped(for: self)
    }
    
    //  this api call is not linked to a particular action
    func configureLikeButton() {
        delegate?.handleConfigureLikeButton(for: self)
    }
    

    
    // MARK: - Helper Functions
    
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
        
        /*
        // photo attributes and constraints
        addSubview(postImageView)
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // profile attributes and constraints
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // username attributes and constraints
        addSubview(usernameButton)
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        */
 
 
        /*
        // separator attributes and constraints
        addSubview(circleDotView)
        circleDotView.translatesAutoresizingMaskIntoConstraints = false
        
        // date and time attributes and constraints
        addSubview(postTimeLabel)
        postTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // following/follower attributes and constraints
        addSubview(followFollowingLabel)
        followFollowingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // caption block attributes and constraints
        addSubview(captionBlock)
        captionBlock.translatesAutoresizingMaskIntoConstraints = false
        
        // caption constraints within caption block
        captionBlock.addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // like and comment icon block attributes and constraints
        addSubview(likeCommentBlock)
        likeCommentBlock.translatesAutoresizingMaskIntoConstraints = false
        
        // following/follower attributes and constraints
        addSubview(addCommentBlock)
        addCommentBlock.translatesAutoresizingMaskIntoConstraints = false
        
        addCommentBlock.addSubview(replyCommentLabel)
        addCommentBlock.translatesAutoresizingMaskIntoConstraints = false
        
        //options background
        addSubview(backgroundOptionsButton)
        backgroundOptionsButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundOptionsButton.backgroundColor = .clear
        backgroundOptionsButton.layer.cornerRadius = 30 / 2
        
        // option button constraints
        backgroundOptionsButton.addSubview(optionsButton)
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.tintColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        
        likeCommentBlock.addSubview(newCommentBubble)
        newCommentBubble.translatesAutoresizingMaskIntoConstraints = false

        likeCommentBlock.addSubview(commentLabel)
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        likeCommentBlock.addSubview(newLikeHeart)
        newLikeHeart.translatesAutoresizingMaskIntoConstraints = false

        likeCommentBlock.addSubview(likesLabel)
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        */
        
        /*
        // constant attributes and anchors
        let profileImageDimension = CGFloat(40)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: profileImageDimension, height: profileImageDimension)
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        
        // variable constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[image]-0-|", options: [], metrics: nil, views: ["image": postImageView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-60-[image]-0-[likeCommentBlock]-2-[captionBlock]", options: [], metrics: nil, views: ["image": postImageView, "likeCommentBlock": likeCommentBlock, "captionBlock": captionBlock]))
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
                atts[NSAttributedString.Key.font] = UIFont(name: "HelveticaNeue", size: 14)
                
            case .hashtag:
                
                atts[NSAttributedString.Key.font] = UIFont(name: "HelveticaNeue", size: 14)
                atts[NSAttributedString.Key.foregroundColor] = UIColor.rgb(red: 50, green: 80, blue: 150)
                
            case .mention:
                
                atts[NSAttributedString.Key.font] = UIFont(name: "HelveticaNeue", size: 14)
                atts[NSAttributedString.Key.foregroundColor] = UIColor.rgb(red: 50, green: 80, blue: 150)
                
            default: ()
            }
            return atts
        }
        
        
        // setting max number of lines shown under the caption
        // to adjust the number of characters go to UpoloadPostVC
        captionLabel.customize { (label) in
            label.text = "\(caption)"
            label.customColor[customType] = UIColor.rgb(red: 0, green: 0, blue: 0)
            label.font = UIFont.systemFont(ofSize: 14)
            //label.font = UIFont(name: "Arial Rounded MT Bold", size: 10)
            label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
            captionLabel.numberOfLines = 3
        
        }
        
        postTimeLabel.text = post.creationDate.timeAgoToDisplay()
    }
    
    func configureFollowFollowing() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let user = self.post else { return }
        
        
        if currentUid == user.ownerUid {
            
            // do nothing
            self.followFollowingLabel.text = ""
            self.circleDotView.backgroundColor =  UIColor.clear
            
        } else {

         user.checkIfUserIsFollowed(completion: { (followed) in
             
             if followed {
                 self.followFollowingLabel.text = "following"
                self.followFollowingLabel.font = UIFont(name: "HelveticaNeue", size: 15)
                self.circleDotView.backgroundColor =  UIColor.rgb(red: 0, green: 0, blue: 0)
             } else {
                 self.followFollowingLabel.text = "follow"
                self.followFollowingLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
                self.circleDotView.backgroundColor =  UIColor.rgb(red: 0, green: 0, blue: 0)
             }
         })
        }
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

            let attributedText = NSMutableAttributedString(string: "\(numberOfComments!)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)])
            
            self.commentLabel.attributedText = attributedText
        }
    }
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

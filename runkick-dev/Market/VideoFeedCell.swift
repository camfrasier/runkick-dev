//
//  VideoFeedCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/29/21.
//  Copyright © 2021 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel
import AVKit
import AVFoundation

class VideoFeedCell: UICollectionViewCell {
    // creating a variable of the type FeedCellDelegate that's optional
    var delegate: VideoFeedCellDelegate?
    //var altDelegate: AltFeedCellDelegate?
    var isWide = false
    
    var post: Post? {
        
        didSet {
            
     
                print("media type is video")
                guard let url = URL(string: post?.videoUrl ?? "") else { return }
             //   playVideo(url: url)

                //guard let imageUrl = post?.imageUrl else { return }

            guard let ownerUid = post?.ownerUid else { return }
            guard let likes = post?.likes else { return }
           // guard let postId = post?.postId else { return }
        
            
            Database.fetchUser(with: ownerUid) { (user) in  // In order to grab the photo of the correct post owner.
                
                self.usernameButton.setTitle(user.username, for: .normal)
                self.usernameCaption.setTitle(user.username, for: .normal)
                self.firstnameButton.setTitle(user.firstname, for: .normal)
                self.lastnameButton.setTitle(user.lastname, for: .normal)
                self.configurePostCaption(user: user)
                
                
                guard let userProfileImage = user.profileImageURL else { return }
                self.profileImageView.loadImage(with: userProfileImage)
  
            }
            
            //likesLabel.text = "\(likes)"
            
            let attributedText = NSMutableAttributedString(string: "0", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)])
            attributedText.append(NSAttributedString(string: " likes", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 50, green: 80, blue: 150)]))
            likesLabel.attributedText = attributedText
            
            configureLikeButton()
            
            configureComments()
            
            configureFollowFollowing()
            
            //sizeOfImage()
            
            //postImageView.loadImage(with: imageUrl)
            
            //guard let postUrl = post?.imageUrl else { return }
            //sizeImageAt(postId: postId, urlString: postUrl)
            
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
    
    lazy var backgroundPostView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    let circleDotView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2 / 2
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        return view
    }()
    
    lazy var locationButton: UIButton = {  // We need to use a lazy var when converting a button into an action within a cell class.
        let button = UIButton(type: .system)
        button.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 15)
        button.setImage(UIImage(named: "locationMarker"), for: .normal)
        button.tintColor = UIColor.walkzillaRed()
        button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    let profileImageBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 238, green: 238, blue: 238)
        view.layer.cornerRadius = 30 / 2
        return view
    }()
    
    let userLocationBlock: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        return view
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.boldSystemFont(ofSize: 12)
        //label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        
        label.textColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        label.textAlignment = .left
        label.text = "Union Market DC"
        return label
    } ()
    
    let wantsToLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.textColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        label.textAlignment = .left
        label.text = "180+ other people want to do this"
        return label
    } ()
    
    
    
    lazy var captionBlock: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.white.cgColor
        return view
    }()
    
    lazy var addCommentBlock: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.rgb(red: 255, green: 0, blue: 0).cgColor
        let addCommentTapped = UITapGestureRecognizer(target: self, action: #selector(handleCommentTapped))
        addCommentTapped.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(addCommentTapped)
        return view
    }()
    
    /*
    let likeCommentBlock: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 255).cgColor
        return view
    }()
    */
    lazy var usernameButton: UIButton = {  // We need to use a lazy var when converting a button into an action within a cell class.
        let button = UIButton(type: .system)
        button.setTitle("Username", for: .normal)
        button.titleLabel?.font =  UIFont(name: "ArialRoundedMTBold", size: 13)
        //button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.rgb(red: 0, green: 0, blue: 0), for: .normal)
        button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    
    lazy var usernameCaption: UIButton = {  // We need to use a lazy var when converting a button into an action within a cell class.
        let button = UIButton(type: .system)
        button.setTitle("Username", for: .normal)
        button.titleLabel?.font =  UIFont(name: "ArialRoundedMTBold", size: 13)
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
        let button = UIButton(type: .system)
        let image = UIImage(named: "optionDotsHorizantal")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleOptionTapped), for: .touchUpInside)
        button.tintColor = UIColor.rgb(red: 120, green: 120, blue: 120)
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
    
    lazy var postImageBlock: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
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
    
    lazy var addCommentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("      Add a comment...", for: .normal)
        button.contentHorizontalAlignment = .left
        button.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        button.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 12)
        button.setTitleColor(UIColor.rgb(red: 170, green: 170, blue: 170), for: .normal)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
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
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.text = "3"
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 100, green: 100, blue: 100)

        // add gesture recognizer to label
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleShowLikes))
        likeTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(likeTap)
        
        return label
    } ()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.text = "0"
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 100, green: 100, blue: 100)

        // add gesture recognizer to label
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(handleCommentTapped))
        commentTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(commentTap)
        
        return label
    } ()
    
    
    lazy var bigCaption: UILabel = {
        let label = UILabel()
        label.text = "MOTIVATION MONDAY!"
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        label.setLineHeight(lineHeight: 0)
        label.numberOfLines = 0
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
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.text = "username"
        label.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        return label
    } ()
    
    
    lazy var usernameSymbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "@"
        label.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        return label
    } ()
    
    let captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.numberOfLines = 3
        label.sizeToFit()
        //[label, sizeToFit] as [Any];
        return label
    } ()
    
    let actionCaption: UILabel = { // Will replace later with an action label.
        let label = UILabel()
        label.text = "EXPLORE"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 14)
        label.setLineSpacing(lineSpacing: 2)
        label.numberOfLines = 3
        return label
    } ()
    
    let postTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialRoundedMTBold", size: 13)
        //label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 14)
        label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.text = "2d"
        return label
    } ()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        return view
    }()
    
    let imageTranslucentBar: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(red: 255/255 , green: 255/255, blue: 255/255, alpha: 1)
        //view.backgroundColor = UIColor(red: 50/255 , green: 50/255, blue: 50/255, alpha: 0.50)
        return view
    }()
    
    let whiteLineSeparator: UIView = {
        let view = UIView()
        return view
    } ()
    
    
    lazy var newLikeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "walkzillaHeartUnselected"), for: .normal)
        button.tintColor = UIColor.rgb(red: 225, green: 225, blue: 225)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    } ()
    
    lazy var newLikeHeart: UIButton = {
        let button = UIButton(type: .system)  // will need to change to custom
        //button.setImage(UIImage(named: "walkzillaHeart"), for: .normal)
        button.setImage(UIImage(named: "zillaThumbsUpSelected"), for: .normal)
        button.addTarget(self, action: #selector(handleShowLikes), for: .touchUpInside)
        button.tintColor = UIColor.rgb(red: 200, green: 200, blue: 200)
        button.alpha = 1
        return button
    } ()
    
    lazy var newCommentBubble: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "walkzillaCommentBubble"), for: .normal)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        button.tintColor = UIColor.rgb(red: 200, green: 200, blue: 200)
        button.alpha = 1
        return button
    } ()
    
    lazy var newComment: UIButton = {
        let button = UIButton(type: .custom)
       // button.setImage(UIImage(named: "newComment"), for: .normal)        button.setTitle("Like", for: .normal)
         button.setTitle("Comment", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 0, green: 0, blue: 0), for: .normal)
       button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)

        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        //button.layer.cornerRadius = 30 / 2
        button.alpha = 1
        return button
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
    print("do something else here, show comments and photo")
        delegate?.handleCommentTapped(for: self)
    }
    
    @objc func handleFollowFollowingTapped() {
        delegate?.handleFollowFollowingTapped(for: self)
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
        
        // cancel long press
        /*
        if sender.state == .began {
            guard let post = self.post else { return }
            altDelegate?.presentPhotoFeedView(withFeedCell: post)
        }
        */
    }
    
    // MARK: - Helper Functions
    
    func playVideo(url: URL) {
        
        print("does the video function to play video get called \(url)")
        
        let player = AVPlayer(url: url)
        let playerView = AVPlayerLayer()
        playerView.player = player
        playerView.videoGravity = .resizeAspectFill
        player.volume = 4  // may need to add a mute button later
        postImageBlock.layer.addSublayer(playerView)
        playerView.frame = CGRect(x: 0, y: 0, width: postImageBlock.frame.width, height: postImageBlock.frame.height)
        player.play()
        
    
        /*
        let vc = AVPlayerViewController()
        vc.player = player
        
        //addSubview(self.postImageBlock)
        //postImageBlock.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        postImageBlock.addSubview(vc.view)
        vc.player?.play()
       // self.present(vc, animated: true) { vc.player?.play() }
        */
    }
    
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
    
    
    func sizeOfImage() {
        
        //guard let postId = post?.postId else { return }
        guard let postUrl = post?.imageUrl else { return }

        let url = URL(string: postUrl)!
            
        Database.fetchDimensions(with: url) { (photoImage) in
            let imageWidth = photoImage.size.width
            let imageHeight = photoImage.size.height
            
            print("The image width is \(imageWidth) and the image height is \(imageHeight)")
            
            if imageWidth > imageHeight {
 
                self.isWide = true
                
                DispatchQueue.main.async {
                    
                    self.addSubview(self.postImageBlock)
                    self.postImageBlock.translatesAutoresizingMaskIntoConstraints = false
                    self.postImageBlock.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.imageTranslucentBar.topAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 375)
                    
                    self.isWide = false
                  }
                
            print("The image height is HAS changed")
            } else {
                
                print("The image height is NOT changed")
            }

        }
    }

    
    func configureContraints() {

    
        print("This is the configureConstraints function called")
        
        addSubview(self.postImageBlock)
        postImageBlock.translatesAutoresizingMaskIntoConstraints = false
        //postImageBlock.backgroundColor = UIColor.rgb(red: 255, green: 0, blue: 0)
        //postImageBlock.layer.cornerRadius = 3
        
        


        addSubview(captionBlock)
        captionBlock.translatesAutoresizingMaskIntoConstraints = false
        //captionBlock.backgroundColor = UIColor.rgb(red: 0, green: 200, blue: 0)
        
        // caption constraints within caption block
        captionBlock.addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        

        
        addSubview(userLocationBlock)
        userLocationBlock.translatesAutoresizingMaskIntoConstraints = false
        
        userLocationBlock.addSubview(locationButton)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        userLocationBlock.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        // temp separator
        addSubview(whiteLineSeparator)
        whiteLineSeparator.translatesAutoresizingMaskIntoConstraints = false
        whiteLineSeparator.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        whiteLineSeparator.backgroundColor = .white
        
        
        //imageTranslucentBar.addSubview(lineView)
        //lineView.translatesAutoresizingMaskIntoConstraints = false
        
        userLocationBlock.addSubview(profileImageBackground)
        profileImageBackground.translatesAutoresizingMaskIntoConstraints = false
        
        // profile attributes and constraints
        profileImageBackground.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // username attributes and constraints
        userLocationBlock.addSubview(usernameButton)
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        
        //captionBlock.addSubview(usernameCaption)
        //usernameCaption.translatesAutoresizingMaskIntoConstraints = false
        
        // separator attributes and constraints
        userLocationBlock.addSubview(circleDotView)
        circleDotView.translatesAutoresizingMaskIntoConstraints = false
        
        // date and time attributes and constraints
        imageTranslucentBar.addSubview(postTimeLabel)
        postTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageTranslucentBar.addSubview(wantsToLabel)
        wantsToLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        // following/follower attributes and constraints
        userLocationBlock.addSubview(followFollowingLabel)
        followFollowingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // caption block attributes and constraints

        
        // following/follower attributes and constraints
        addSubview(addCommentBlock)
        addCommentBlock.translatesAutoresizingMaskIntoConstraints = false
        

        //options background
        addSubview(backgroundOptionsButton)
        backgroundOptionsButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundOptionsButton.backgroundColor = .clear
        backgroundOptionsButton.layer.cornerRadius = 30 / 2
        
        // option button constraints
        backgroundOptionsButton.addSubview(optionsButton)
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
 
        
        
        //userLocationBlock.addSubview(newCommentBubble)
        //newCommentBubble.translatesAutoresizingMaskIntoConstraints = false

        userLocationBlock.addSubview(commentLabel)
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        
       // userLocationBlock.addSubview(newLikeHeart)
       // newLikeHeart.translatesAutoresizingMaskIntoConstraints = false

        userLocationBlock.addSubview(likesLabel)
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        //userLocationBlock.backgroundColor = UIColor.rgb(red: 120, green: 200, blue: 255)
        
        
        postImageBlock.addSubview(newLikeButton)
        newLikeButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        newLikeHeart.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
          
          newCommentBubble.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 15, height: 14)
          
        addSubview(imageTranslucentBar)
        imageTranslucentBar.translatesAutoresizingMaskIntoConstraints = false
        //imageTranslucentBar.backgroundColor = UIColor.rgb(red: 222, green: 180, blue: 180)
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[locationBlock(42)]-0-[captionBlock]-10-[imageBlock]-5-[translucent(55)]-0-|", options: [], metrics: nil, views: ["imageBlock": postImageBlock, "locationBlock": userLocationBlock ,"translucent": imageTranslucentBar, "captionBlock": captionBlock]))

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[imageBlock]-0-|", options: [], metrics: nil, views: ["imageBlock": postImageBlock]))
        
          let stackView = UIStackView(arrangedSubviews: [likesLabel, commentLabel])
          
          stackView.axis = .horizontal
          stackView.distribution = .equalSpacing
          stackView.alignment = .center
          stackView.spacing = 3
          stackView.translatesAutoresizingMaskIntoConstraints = false
          imageTranslucentBar.addSubview(stackView)
          
        /*
          let stackView2 = UIStackView(arrangedSubviews: [commentLabel, newCommentBubble])
          
          stackView2.axis = .horizontal
          stackView2.distribution = .equalSpacing
          stackView2.alignment = .center
          stackView2.spacing = 3
          stackView2.translatesAutoresizingMaskIntoConstraints = false
          userLocationBlock.addSubview(stackView2)
          */

        stackView.anchor(top: imageTranslucentBar.topAnchor, left: imageTranslucentBar.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        wantsToLabel.anchor(top: stackView.bottomAnchor, left: stackView.leftAnchor, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
          
       // stackView2.anchor(top: stackView.topAnchor, left: stackView.rightAnchor, bottom: nil, right: nil , paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
     
        
        profileImageBackground.anchor(top: userLocationBlock.topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        
        let profileImageDimension = CGFloat(30)
        profileImageView.anchor(top: profileImageBackground.topAnchor, left: nil, bottom: profileImageBackground.bottomAnchor, right: profileImageBackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: profileImageDimension, height: profileImageDimension)
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[username]-0-[location]", options: [], metrics: nil, views: ["username": usernameButton, "location": locationLabel]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[username]-0-[marker(12)]", options: [], metrics: nil, views: ["username": usernameButton, "marker": locationButton]))
        
        usernameButton.anchor(top: profileImageBackground.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 14)
        
        locationButton.anchor(top: usernameButton.bottomAnchor, left: usernameButton.leftAnchor, bottom: nil, right: nil, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 10, height: 13)
        
        locationLabel.anchor(top: usernameButton.bottomAnchor, left: locationButton.rightAnchor, bottom: nil, right: nil, paddingTop: 1, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        circleDotView.anchor(top: usernameButton.topAnchor, left: usernameButton.rightAnchor, bottom: nil, right: nil, paddingTop: 9, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 2, height: 2)

        followFollowingLabel.anchor(top: usernameButton.topAnchor, left: circleDotView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        

        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[captionBlock]-15-|", options: [], metrics: nil, views: ["captionBlock": captionBlock]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[translucent]-0-|", options: [], metrics: nil, views: ["translucent": imageTranslucentBar]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[locationBlock]-10-|", options: [], metrics: nil, views: ["locationBlock": userLocationBlock]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[backgroundOptionsButton(30)]", options: [], metrics: nil, views: ["backgroundOptionsButton": backgroundOptionsButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[backgroundOptionsButton(30)]", options: [], metrics: nil, views: ["backgroundOptionsButton": backgroundOptionsButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[backgroundOptionsButton(30)]-27-|", options: [], metrics: nil, views: ["backgroundOptionsButton": backgroundOptionsButton]))
         
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[optionsButton(20)]", options: [], metrics: nil, views: ["optionsButton": optionsButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[optionsButton(20)]-5-|", options: [], metrics: nil, views: ["optionsButton": optionsButton]))
        
        
        
        // variable constraints inside blocks
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[caption]-15-|", options: [], metrics: nil, views: ["caption": captionLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[caption]-0-|", options: [], metrics: nil, views: ["caption": captionLabel]))
        
       // addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[profileImage(30)]", options: [], metrics: nil, views: ["profileImage": profileImageView]))
        
       // addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[profileImage(30)]", options: [], metrics: nil, views: ["profileImage": profileImageView]))

        profileImageView.layer.cornerRadius = 30 / 2
        
        
        
       // addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[profileImage(30)]-8-[location]-4-[marker(8)]", options: [], metrics: nil, views: ["profileImage": profileImageView, "marker": locationButton, "location": locationLabel]))
        

        
       // addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[postImage]-0-|", options: [], metrics: nil, views: ["postImage": postImageView]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[postImage]-0-|", options: [], metrics: nil, views: ["postImage": postImageView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[pressHeart(23)]-28-|", options: [], metrics: nil, views: ["pressHeart": newLikeButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-28-[pressHeart(20)]", options: [], metrics: nil, views: ["pressHeart": newLikeButton]))
        
        


        
        postTimeLabel.anchor(top: imageTranslucentBar.topAnchor, left: nil, bottom: nil, right: imageTranslucentBar.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)
        

        
  
    }
    
        
    func configurePostCaption(user: User) {
        
        
        
        
        guard let post = self.post else { return }
        guard let caption = post.caption else { return }  // Safely unwrap so we don't get this as an optional anymore.
        
        
        guard let username = post.user?.username else { return }
        usernameLabel.text = post.user?.username
        
        
        // look for username as pattern
        let customType = ActiveType.custom(pattern: "^\(username)\\b")
        
        // enable username as custom type
        captionLabel.enabledTypes = [.mention, .hashtag, .url, customType]
        
        // configure username link attributes
        captionLabel.configureLinkAttribute = { (type, attributes, isSelected) in
            var atts = attributes

            switch type {
            case .custom:
                atts[NSAttributedString.Key.font] = UIFont(name: "HelveticaNeue", size: 13)
                
            case .hashtag:
                
                atts[NSAttributedString.Key.font] = UIFont(name: "HelveticaNeue", size: 13)
                atts[NSAttributedString.Key.foregroundColor] = UIColor.rgb(red: 50, green: 80, blue: 150)
                
            case .mention:
                
                atts[NSAttributedString.Key.font] = UIFont(name: "HelveticaNeue", size: 1)
                atts[NSAttributedString.Key.foregroundColor] = UIColor.rgb(red: 50, green: 80, blue: 150)
                
            default: ()
            }
            return atts
        }
        
        //guard let usernameCapBtn = usernameCaption.titleLabel else { return }
        
        // setting max number of lines shown under the caption
        // to adjust the number of characters go to UpoloadPostVC
        captionLabel.customize { (label) in
            label.text = "\(caption)"
            label.customColor[customType] = UIColor.rgb(red: 40, green: 40, blue: 40)
            //label.font = UIFont.systemFont(ofSize: 13)
            label.font = UIFont(name: "HelveticaNeue", size: 13)
            label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
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

            //let attributedText = NSMutableAttributedString(string: "\(numberOfComments!)", attributes: [NSAttributedString.Key.font:  UIFont(name: "HelveticaNeue", size: 13)!])
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfComments)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)])
            attributedText.append(NSAttributedString(string: " comments", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 50, green: 80, blue: 150)]))
            //label.attributedText = attributedText
            
            self.commentLabel.attributedText = attributedText
        }
    }
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
extension UILabel {
    
    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
            self.attributedText = attributeString
        }
    }
}
*/

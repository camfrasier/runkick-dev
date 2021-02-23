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
    var logos = [Logos]()
    let reuseCircleCellIdentifier = "CircleCell"
    var didLoad = false
    
    
    var post: Post? {
        
        didSet {

 
            guard let ownerUid = post?.ownerUid else { return }
            guard let imageUrl = post?.imageUrl else { return }
            guard let likes = post?.likes else { return }
            
            //guard let logoImageUrl1 = post?.logo1 else { return }
            //logoImage1.loadImage(with: logoImageUrl1)
            
             //print("DO can we get a value eventually \(logoImageUrl1)")
            
                
            mapImageView.loadImage(with: imageUrl)
            
            
            Database.fetchUser(with: ownerUid) { (user) in  // In order to grab the photo of the correct post owner.
                
                //self.profileImageView.loadImage(with: user.profileImageURL)
                //self.usernameButton.setTitle("@\(user.username ?? "")", for: .normal)
                self.usernameButton.setTitle(user.username, for: .normal)
                self.firstnameButton.setTitle(user.firstname, for: .normal)
                self.lastnameButton.setTitle(user.lastname, for: .normal)
                self.configurePostCaption(user: user)
                
                guard let userProfileImage = user.profileImageURL else { return }
    
                self.checkInProfileImageView.loadImage(with: userProfileImage)
                self.profileImageView.loadImage(with: userProfileImage)
            
                
            }
            
            

            likesLabel.text = "\(likes)"
            configureLikeButton()
            
            configureComments()
            
            configureFollowFollowing()
            
            //self.collectionView?.refreshControl?.endRefreshing()
            
            print("Debug: the value of didload is \(self.didLoad)")

            //fetchPosts(postId)
            countUserLogos()
            
            

        }
    }
    
    
    // MARK: - Properties
    /*
    lazy var profileImageView: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(handleUsernameTapped))
        profileTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(profileTap)
        return iv
    }()
    */
    let imageTranslucentBar: UIView = {
        let view = UIView()
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
    
    
    lazy var checkInButton1: UIButton = {  // We need to use a lazy var when converting a button into an action within a cell class.
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "oneHundredWalkzilla"), for: .normal)
        //button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var favoritesButton: UIButton = {  // We need to use a lazy var when converting a button into an action within a cell class.
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        button.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 13)
        button.setTitle("SEE MORE", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255), for: .normal)
        //button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    
    let userLocationBlock: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        return view
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 100, green: 100, blue: 100)
        return view
    }()
    
    let mapBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        //view.layer.shadowColor = UIColor(red: 50/255, green: 50/255, blue: 0/255, alpha: 0.35).cgColor
        //view.layer.shadowRadius = 10.0
        //view.layer.shadowOffset = CGSize(width: 0, height: 0)
        return view
    }()
    
    let statusBarLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 100, green: 100, blue: 100)
        return view
    }()
    
    let actionBlock: UIView = {
        let view = UIView()
        return view
    }()
    
    let actionLabel: UILabel = { // Will replace later with an action label.
        let label = UILabel()
        label.text = "Fortune"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        //label.font = UIFont(name: "HelveticaNeue-Medium", size: 28)
        //label.font = UIFont(name: "NotoSansKannada-Bold", size: 32)
        label.font = UIFont(name: "PingFangTC-Semibold", size: 28)
        label.setLineSpacing(lineSpacing: 1)
        label.textAlignment = .left
        //label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 32)
        //label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        label.setLineHeight(lineHeight: 0)
        label.numberOfLines = 3
        return label
    } ()
    
    let actionLabel2: UILabel = { // Will replace later with an action label.
        let label = UILabel()
        label.text = "Favors"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        //label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 32)
        //label.font = UIFont(name: "ArialHebrew", size: 32)
        label.font = UIFont(name: "PingFangTC-Semibold", size: 28)
        label.setLineSpacing(lineSpacing: 1)
        label.textAlignment = .left
        //label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 32)
        //label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        label.setLineHeight(lineHeight: 0)
        label.numberOfLines = 1
        return label
    } ()
    
    let actionLabel3: UILabel = { // Will replace later with an action label.
        let label = UILabel()
        label.text = " The Brave. "
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        //label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 28)
        label.font = UIFont(name: "PingFangTC-Semibold", size: 28)
        label.setLineSpacing(lineSpacing: 1)
        label.textAlignment = .left
        //label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        label.backgroundColor = UIColor.walkzillaRed()
        label.setLineHeight(lineHeight: 0)
        label.numberOfLines = 1
        return label
    } ()
    
    let actionLabel3Block: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.walkzillaRed()
        return view
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.textAlignment = .center
        label.text = "Union Market DC"
        return label
    } ()
    
    lazy var newLikeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "likeHeartWalkzilla"), for: .normal)
        button.tintColor = UIColor.rgb(red: 253, green: 253, blue: 253)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    } ()
    
    
    let checkInProfileBlock: UIView = {
        let view = UIView()
        return view
    }()
    
    let spacerBlock: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var checkInProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "userProfileSilhouetteWhite")
        
        /*
        // add gesture recognizer for double tap to like
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(handleUsernameTapped))
        profileTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(profileTap)
        */
        return iv
    } ()

    
    lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "userProfileSilhouetteWhite")
        
        // add gesture recognizer for double tap to like
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(handleUsernameTapped))
        profileTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(profileTap)
        return iv
    } ()
    
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
    /*
    let likeCommentBlock: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        return view
    }()
    */
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
    
    lazy var analyticsBlock: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
       
        /*
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.25).cgColor
        view.layer.shadowRadius = 12.0
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        */
        /*
        let optionTap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapped))
        optionTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(optionTap)
        */
        return view
    }()
    
    lazy var mapImageView: CustomImageView = {  // Using the Custom image view class.
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
    
    lazy var logoImage1: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true

        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleLogo1Tapped))
        likeTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        return iv
    } ()
    
    lazy var logoImage2: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true

        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleMenuTapped))
        likeTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        return iv
    } ()
    
    lazy var logoImage3: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true

        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleMenuTapped))
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
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        label.text = "2 days ago"
        return label
    } ()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    let distanceBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 245)
        return view
    }()
    
    lazy var distanceMarker: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "markerWalkzilla"), for: .normal)
        button.tintColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        //button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        label.textAlignment = .center
        label.text = "9.31mi"
        return label
    } ()
    
    let stepsBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 245)
        return view
    }()
    
    lazy var stepsMarker: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "dasherWalkzilla"), for: .normal)
        button.tintColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        //button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    let stepsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        label.textAlignment = .center
        label.text = "4.1K"
        return label
    } ()
    
    let durationBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 245)
        return view
    }()
    
    lazy var durationMarker: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "activityWalkzilla"), for: .normal)
        button.tintColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        //button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        label.textAlignment = .center
        label.text = "00:48h"
        return label
    } ()
    
    /*
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
    */
    
    
    lazy var newLikeHeart: UIButton = {
        let button = UIButton(type: .system)  // will need to change to custom
        button.setImage(UIImage(named: "walkzillaHeart"), for: .normal)
        button.addTarget(self, action: #selector(handleShowLikes), for: .touchUpInside)
        button.tintColor = UIColor.rgb(red: 180, green: 180, blue: 180)
        button.alpha = 1
        return button
    } ()
    
    lazy var newCommentBubble: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "walkzillaCommentBubble"), for: .normal)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        button.tintColor = UIColor.rgb(red: 180, green: 180, blue: 180)
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
    
    lazy var collectionViewHorizontal: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize = .zero
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.contentInset = .zero
        return cv
    }()
    

    
    lazy var lo3: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        /*
        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapped))
        likeTap.numberOfTapsRequired = 2
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        */
        return iv
    }()
    
    lazy var lo4: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        /*
        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapped))
        likeTap.numberOfTapsRequired = 2
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        */
        return iv
    }()
    
    lazy var lo5: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        /*
        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapped))
        likeTap.numberOfTapsRequired = 2
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        */
        return iv
    }()
    
    lazy var lo6: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        /*
        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapped))
        likeTap.numberOfTapsRequired = 2
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        */
        return iv
    }()
    
    lazy var lo7: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        /*
        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapped))
        likeTap.numberOfTapsRequired = 2
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        */
        return iv
    }()
    
    lazy var lo8: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        /*
        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapped))
        likeTap.numberOfTapsRequired = 2
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        */
        return iv
    }()
    
    lazy var lo9: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        /*
        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapped))
        likeTap.numberOfTapsRequired = 2
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        */
        return iv
    }()
    
    lazy var lo10: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        /*
        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapped))
        likeTap.numberOfTapsRequired = 2
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        */
        return iv
    }()
    
    lazy var lo11: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        /*
        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapped))
        likeTap.numberOfTapsRequired = 2
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        */
        return iv
    }()
    
    lazy var lo12: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        /*
        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapped))
        likeTap.numberOfTapsRequired = 2
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        */
        return iv
    }()
    
    //let circleVC = CircleVC(collectionViewLayout: UICollectionViewFlowLayout())
    

    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        configureContraints()
        
        backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 235)
        
        //backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        //let layout = UICollectionViewFlowLayout()
        //let frame = CGRect(x: 0, y: (frame.height / 2) - 40, width: frame.width, height: frame.height / 2 + 40)
        //let frame = CGRect(x: 0, y: 20, width: frame.width, height: 150)
        //collectionViewHorizontal = UICollectionView(frame: frame, collectionViewLayout: layout)
        //collectionViewHorizontal.dataSource = self
        //collectionViewHorizontal.delegate = self
        
        //collectionViewHorizontal.collectionViewLayout = CircleCollectionViewLayout()
        collectionViewHorizontal.register(CircleCell.self, forCellWithReuseIdentifier: reuseCircleCellIdentifier)
        
        
        // background collor of circle cell collectionview
       // addSubview(collectionViewHorizontal)
       // collectionViewHorizontal.anchor(top: imageTranslucentBar.bottomAnchor, left: imageTranslucentBar.leftAnchor, bottom: nil, right: imageTranslucentBar.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        //collectionView.layer.backgroundColor = UIColor.clear.cgColor
        collectionViewHorizontal.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        
        
        
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
    
    @objc func handleLogo1Tapped() {
        
        
    }
    
    @objc func handleMenuTapped() {
        print("handle see menus tapped")
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
        
        
        //addSubview(mapBackgroundView)
        //mapBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        //mapBackgroundView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //mapBackgroundView.layer.cornerRadius = 15
        
        
        addSubview(analyticsBlock)
        analyticsBlock.translatesAutoresizingMaskIntoConstraints = false
        analyticsBlock.backgroundColor = UIColor.rgb(red: 242, green: 242, blue: 242)
        //postImageViewBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //postImageViewBackground.layer.cornerRadius = 15

/*
         // photo attributes and constraints
         mapBackgroundView.addSubview(mapImageView)
         mapImageView.translatesAutoresizingMaskIntoConstraints = false
         //postImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
         //postImageView.layer.cornerRadius = 40
         mapImageView.clipsToBounds = true
*/
        
        addSubview(actionBlock)
        actionBlock.translatesAutoresizingMaskIntoConstraints = false
        actionBlock.backgroundColor = UIColor.clear
        
        
        
        addSubview(spacerBlock)
        spacerBlock.translatesAutoresizingMaskIntoConstraints = false
        spacerBlock.backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 235)
        
        // date and time attributes and constraints
        addSubview(postTimeLabel)
        postTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        

        
        addSubview(imageTranslucentBar)
        imageTranslucentBar.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        // profile attributes and constraints
        imageTranslucentBar.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // username attributes and constraints
        imageTranslucentBar.addSubview(usernameButton)
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        
        // separator attributes and constraints
        imageTranslucentBar.addSubview(circleDotView)
        circleDotView.translatesAutoresizingMaskIntoConstraints = false
        

        
        // following/follower attributes and constraints
        imageTranslucentBar.addSubview(followFollowingLabel)
        followFollowingLabel.translatesAutoresizingMaskIntoConstraints = false
         
         imageTranslucentBar.addSubview(newCommentBubble)
         newCommentBubble.translatesAutoresizingMaskIntoConstraints = false

         imageTranslucentBar.addSubview(commentLabel)
         commentLabel.translatesAutoresizingMaskIntoConstraints = false
         
         imageTranslucentBar.addSubview(newLikeHeart)
         newLikeHeart.translatesAutoresizingMaskIntoConstraints = false

         imageTranslucentBar.addSubview(likesLabel)
         likesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        spacerBlock.addSubview(distanceBackground)
        distanceBackground.translatesAutoresizingMaskIntoConstraints = false
        
        distanceBackground.addSubview(distanceLabel)
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        distanceBackground.addSubview(distanceMarker)
        distanceMarker.translatesAutoresizingMaskIntoConstraints = false
        
        spacerBlock.addSubview(stepsBackground)
        distanceBackground.translatesAutoresizingMaskIntoConstraints = false
        
        stepsBackground.addSubview(stepsLabel)
        stepsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stepsBackground.addSubview(stepsMarker)
        stepsMarker.translatesAutoresizingMaskIntoConstraints = false
        
        spacerBlock.addSubview(durationBackground)
        distanceBackground.translatesAutoresizingMaskIntoConstraints = false
        
        durationBackground.addSubview(durationLabel)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        durationBackground.addSubview(durationMarker)
        durationMarker.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(userLocationBlock)
        userLocationBlock.translatesAutoresizingMaskIntoConstraints = false
        //userLocationBlock.backgroundColor = UIColor.walkzillaRed()
        
        userLocationBlock.addSubview(locationButton)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        userLocationBlock.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(newLikeButton)
        newLikeButton.translatesAutoresizingMaskIntoConstraints = false
        

        
        

        
        
        
        /*
        //options background
        addSubview(backgroundOptionsButton)
        backgroundOptionsButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundOptionsButton.backgroundColor = .clear
        backgroundOptionsButton.layer.cornerRadius = 30 / 2
        
        // option button constraints
        backgroundOptionsButton.addSubview(optionsButton)
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.tintColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        
        // like and comment icon block attributes and constraints
        //addSubview(likeCommentBlock)
        //likeCommentBlock.translatesAutoresizingMaskIntoConstraints = false
        
        */
        

       
        
        
        
        let profileImageDimension = CGFloat(30)
        profileImageView.anchor(top: imageTranslucentBar.topAnchor, left: imageTranslucentBar.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 28, paddingBottom: 0, paddingRight: 0, width: profileImageDimension, height: profileImageDimension)
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        
        usernameButton.anchor(top: imageTranslucentBar.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 16)
        
        circleDotView.anchor(top: usernameButton.topAnchor, left: usernameButton.rightAnchor, bottom: nil, right: nil, paddingTop: 9, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 2, height: 2)

       followFollowingLabel.anchor(top: usernameButton.topAnchor, left: circleDotView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        userLocationBlock.anchor(top: nil, left: leftAnchor, bottom: imageTranslucentBar.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 26)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[marker(12)]-4-[location]", options: [], metrics: nil, views: ["marker": locationButton,"location": locationLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[location]", options: [], metrics: nil, views: ["location": locationLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[marker(16)]", options: [], metrics: nil, views: ["marker": locationButton]))
 
        //mapBackgroundView.anchor(top: nil, left: leftAnchor, bottom: locationLabel.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 220)
 

        

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[background]-0-|", options: [], metrics: nil, views: ["background": analyticsBlock]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[actionBlock(200)]", options: [], metrics: nil, views: ["actionBlock": actionBlock]))

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-42-[actionBlock(120)]", options: [], metrics: nil, views: ["actionBlock": actionBlock]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[lineView]-0-|", options: [], metrics: nil, views: ["lineView": lineView]))
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[pressHeart(30)]-38-|", options: [], metrics: nil, views: ["pressHeart": newLikeButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-38-[pressHeart(27)]", options: [], metrics: nil, views: ["pressHeart": newLikeButton]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(0.20)]-0-[mapBackground]", options: [], metrics: nil, views: ["lineView": lineView, "mapBackground": mapBackgroundView]))
        
        spacerBlock.anchor(top: actionBlock.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
        
        distanceBackground.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 45)
        distanceBackground.layer.cornerRadius = 20
        //distanceBackground.layer.borderWidth = 0.50
        //distanceBackground.layer.borderColor = UIColor.rgb(red: 200, green: 200, blue: 200).cgColor
        
        stepsBackground.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 45)
        stepsBackground.layer.cornerRadius = 20
        //stepsBackground.layer.borderWidth = 0.50
        //stepsBackground.layer.borderColor = UIColor.rgb(red: 200, green: 200, blue: 200).cgColor
        
        durationBackground.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 45)
        durationBackground.layer.cornerRadius = 20
        //checkinBackground.layer.borderWidth = 0.50
        //checkinBackground.layer.borderColor = UIColor.rgb(red: 200, green: 200, blue: 200).cgColor
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-32-[mapBackground(180)]-20-[background]-0-|", options: [], metrics: nil, views: ["mapBackground": mapBackgroundView, "background": analyticsBlock]))
        

        //postImageView.layer.cornerRadius = 180 / 2
        
        
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[image(200)]-0-|", options: [], metrics: nil, views: ["image": postImageView]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[image(200)]-0-|", options: [], metrics: nil, views: ["image": postImageView]))
        
        postTimeLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        

        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[translucent]-0-|", options: [], metrics: nil, views: ["translucent": imageTranslucentBar]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[translucent(40)]-0-|", options: [], metrics: nil, views: ["translucent": imageTranslucentBar]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[favoritesButton(50)]-0-[lineView(0.15)]-0-[background(220)]-0-[locationBlock(40)]-0-[translucent(48)]-0-|", options: [], metrics: nil, views: ["lineView": lineView, "background": postImageViewBackground,"locationBlock": userLocationBlock, "translucent": imageTranslucentBar, "favoritesButton": favoritesButton]))
        

        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[favoritesButton]-0-|", options: [], metrics: nil, views: ["favoritesButton": favoritesButton]))
        
       // addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[locationBlock]-0-|", options: [], metrics: nil, views: ["locationBlock": userLocationBlock]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[profileBlock]-0-|", options: [], metrics: nil, views: ["profileBlock": checkInProfileBlock]))
        
        // variable constraints

        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0.25)-[image]-50-[logo(200)]-(0.25)-|", options: [], metrics: nil, views: ["image": postImageView, "logo": logoImage1]))
        

        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[logo(200)]-0-|", options: [], metrics: nil, views: ["logo": logoImage1]))
        
        
        
        
        /*
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[optionsButton(20)]-30-|", options: [], metrics: nil, views: ["optionsButton": optionsButton]))
         
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[optionsButton(20)]", options: [], metrics: nil, views: ["optionsButton": optionsButton]))
        

        */
 
 
 
        /*
        contentView.addSubview(circleVC.view)
        circleVC.view.anchor(top: postImageViewBackground.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 35, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 0)
        */
        //likeCommentBlock.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width / 2, height: 35)
        
        
        
        newLikeHeart.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 17, height: 15)
        
        newCommentBubble.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 17, height: 16)
        
        
        let stackView = UIStackView(arrangedSubviews: [newLikeHeart, likesLabel])
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        imageTranslucentBar.addSubview(stackView)
        
        let stackView2 = UIStackView(arrangedSubviews: [newCommentBubble, commentLabel])
        
        stackView2.axis = .horizontal
        stackView2.distribution = .equalSpacing
        stackView2.alignment = .center
        stackView2.spacing = 5
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        imageTranslucentBar.addSubview(stackView2)
        

        stackView2.anchor(top: imageTranslucentBar.topAnchor, left: nil, bottom: nil, right: imageTranslucentBar.rightAnchor , paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)

        stackView.anchor(top: stackView2.topAnchor, left: nil, bottom: nil, right: stackView2.leftAnchor , paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        
        
        let stackView3 =  UIStackView(arrangedSubviews: [distanceBackground, stepsBackground, durationBackground])

        stackView3.axis = .horizontal
        stackView3.distribution = .equalSpacing
        stackView3.alignment = .center
        stackView3.spacing = 5
        stackView3.translatesAutoresizingMaskIntoConstraints = false
        spacerBlock.addSubview(stackView3)
        
        stackView3.anchor(top: spacerBlock.topAnchor, left: spacerBlock.leftAnchor, bottom: nil, right: spacerBlock.rightAnchor, paddingTop: 25, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)
        //stackView3.centerYAnchor.constraint(equalTo: spacerBlock.centerYAnchor).isActive = true
        
        distanceMarker.anchor(top: distanceBackground.topAnchor, left: distanceBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 19, paddingBottom: 0, paddingRight: 0, width: 13, height: 17)
        distanceLabel.anchor(top: distanceMarker.topAnchor, left: distanceMarker.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        stepsMarker.anchor(top: stepsBackground.topAnchor, left: stepsBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 23, paddingBottom: 0, paddingRight: 0, width: 17, height: 17)
        stepsLabel.anchor(top: stepsMarker.topAnchor, left: stepsMarker.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        durationMarker.anchor(top: durationBackground.topAnchor, left: durationBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 17, height: 17)
        durationLabel.anchor(top: durationMarker.topAnchor, left: durationMarker.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
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
    
    func circleView1() {
        
        print("This is the logo circleview1 \(logoImage1)")
        
        addSubview(logoImage1)
        logoImage1.translatesAutoresizingMaskIntoConstraints = false
        logoImage1.anchor(top: imageTranslucentBar.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 150, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
         logoImage1.layer.cornerRadius = 200 / 2
 
    }
    
    func circleView2() {
        
        addSubview(logoImage1)
        logoImage1.translatesAutoresizingMaskIntoConstraints = false
        logoImage1.anchor(top: imageTranslucentBar.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 170, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
         logoImage1.layer.cornerRadius = 200 / 2
        
        addSubview(logoImage2)
        logoImage2.translatesAutoresizingMaskIntoConstraints = false
        logoImage2.anchor(top: imageTranslucentBar.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 50, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        logoImage2.layer.cornerRadius = 100 / 2
        
    }
    
    func countUserLogos() {
        
        var numberOfLogos: Int!
        guard let post = self.post else { return }
        guard let postId = post.postId else { return }
        
        
        // get number of posts
        DataService.instance.REF_POSTS.child(postId).child("logoImages").observe(.value) { (snapshot) in

            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
               print("yeilds \(snapshot)")
                
                numberOfLogos = snapshot.count
                
                switch numberOfLogos! {
                    case 1: numberOfLogos = 1
                    
                    self.checkInProfileBlock.removeFromSuperview()
                    self.checkInProfileBlock.backgroundColor = UIColor(red: 255/255 , green: 255/255, blue: 255/255, alpha: 1)
                    
                    Database.fetchLogos(with: postId) { (post) in
                        
                        guard let logoImageUrl1 = post.logo1 else { return }
                        self.logoImage1.loadImage(with: logoImageUrl1)
                        
                        self.addSubview(self.checkInProfileBlock)
                        self.checkInProfileBlock.translatesAutoresizingMaskIntoConstraints = false
                        self.checkInProfileBlock.anchor(top: self.imageTranslucentBar.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
                        
                        self.checkInProfileBlock.addSubview(self.logoImage1)
                        self.logoImage1.translatesAutoresizingMaskIntoConstraints = false
                        self.logoImage1.anchor(top: self.imageTranslucentBar.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 150, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
                        self.logoImage1.layer.cornerRadius = 200 / 2
                        
                    }
                    
                    //self.circleView1()
                    
                        
                    print("choose function 1")
                    
                    case 2: numberOfLogos = 2
                    
                    self.checkInProfileBlock.removeFromSuperview()
                    self.checkInProfileBlock.backgroundColor = UIColor(red: 255/255 , green: 255/255, blue: 255/255, alpha: 1)
                    
                          Database.fetchLogos(with: postId) { (post) in
                              
                                guard let logoImageUrl1 = post.logo1 else { return }
                                self.logoImage1.loadImage(with: logoImageUrl1)
                            
                                guard let logoImageUrl2 = post.logo2 else { return }
                                self.logoImage2.loadImage(with: logoImageUrl2)
                              
                              self.addSubview(self.checkInProfileBlock)
                              self.checkInProfileBlock.translatesAutoresizingMaskIntoConstraints = false
                              self.checkInProfileBlock.anchor(top: self.imageTranslucentBar.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
                            
                            self.checkInProfileBlock.addSubview(self.logoImage1)
                            self.logoImage1.translatesAutoresizingMaskIntoConstraints = false
                            self.logoImage1.anchor(top: self.imageTranslucentBar.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 180, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
                            self.logoImage1.layer.cornerRadius = 200 / 2
                            
                            
                            self.checkInProfileBlock.addSubview(self.logoImage2)
                            self.logoImage2.translatesAutoresizingMaskIntoConstraints = false
                            self.logoImage2.anchor(top: self.imageTranslucentBar.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 25, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
                            self.logoImage2.layer.cornerRadius = 150 / 2
                            

                          }
                    
                    
                        print("choose function 2")
                    
                    //self.circleView2()
                    
                    case 3: numberOfLogos = 3
                    
                 self.checkInProfileBlock.removeFromSuperview()
                //self.checkInProfileBlock.backgroundColor = UIColor(red: 255/255 , green: 255/255, blue: 255/255, alpha: 1)
                    self.checkInProfileBlock.backgroundColor = UIColor.clear
                    
                    //self.checkInProfileBlock.backgroundColor = UIColor.walkzillaRed()
                 
                       Database.fetchLogos(with: postId) { (post) in
                           
                             guard let logoImageUrl1 = post.logo1 else { return }
                             self.logoImage1.loadImage(with: logoImageUrl1)
                         
                             guard let logoImageUrl2 = post.logo2 else { return }
                             self.logoImage2.loadImage(with: logoImageUrl2)
                        
                             guard let logoImageUrl3 = post.logo3 else { return }
                             self.logoImage3.loadImage(with: logoImageUrl3)
                           

                        self.addSubview(self.checkInProfileBlock)
                        self.checkInProfileBlock.translatesAutoresizingMaskIntoConstraints = false
                        self.checkInProfileBlock.anchor(top: self.spacerBlock.bottomAnchor, left: self.leftAnchor, bottom: self.userLocationBlock.topAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

                        let mapImageDim: CGFloat = 210
                        self.checkInProfileBlock.addSubview(self.mapBackgroundView)
                        self.mapBackgroundView.translatesAutoresizingMaskIntoConstraints = false
                        self.mapBackgroundView.anchor(top: self.checkInProfileBlock.topAnchor, left: nil, bottom: nil, right: self.checkInProfileBlock.rightAnchor, paddingTop: 35, paddingLeft: 0, paddingBottom: 0, paddingRight: 60, width: mapImageDim, height: mapImageDim)
                        self.mapBackgroundView.layer.cornerRadius = mapImageDim / 2
                        self.mapBackgroundView.layer.borderWidth = 4
                        self.mapBackgroundView.layer.borderColor = UIColor.rgb(red: 253, green: 253, blue: 253).cgColor
                       //self.mapBackgroundView.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
                        
                        
                        self.mapBackgroundView.addSubview(self.mapImageView)
                        self.mapImageView.translatesAutoresizingMaskIntoConstraints = false
                        self.mapImageView.clipsToBounds = true
                        self.mapImageView.layer.cornerRadius = mapImageDim / 2
                        self.mapImageView.anchor(top: self.mapBackgroundView.topAnchor, left: self.mapBackgroundView.leftAnchor, bottom: self.mapBackgroundView.bottomAnchor, right: self.mapBackgroundView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
                        self.mapImageView.layer.borderWidth = 2
                        self.mapImageView.layer.borderColor = UIColor.rgb(red: 80, green: 80, blue: 80).cgColor

                        
                         let logo1Dim: CGFloat = 120
                         self.checkInProfileBlock.addSubview(self.logoImage1)
                         self.logoImage1.translatesAutoresizingMaskIntoConstraints = false
                        self.logoImage1.anchor(top: self.mapBackgroundView.topAnchor, left: nil, bottom: nil, right: self.mapBackgroundView.leftAnchor, paddingTop: 150, paddingLeft: 0, paddingBottom: 0, paddingRight: -30, width: logo1Dim, height: logo1Dim)
                         self.logoImage1.layer.cornerRadius = logo1Dim / 2
                        //self.logoImage1.layer.borderWidth = 3
                        //self.logoImage1.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
                         
                            
                        let logo2Dim: CGFloat = 105
                         self.checkInProfileBlock.addSubview(self.logoImage2)
                         self.logoImage2.translatesAutoresizingMaskIntoConstraints = false
                        self.logoImage2.anchor(top: self.mapBackgroundView.bottomAnchor, left: nil, bottom: nil, right: self.mapBackgroundView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 70, width: logo2Dim, height: logo2Dim)
                         self.logoImage2.layer.cornerRadius = logo2Dim / 2
                        //self.logoImage2.layer.borderWidth = 3
                        //self.logoImage2.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
                        
                        
                        let logo3Dim: CGFloat = 90
                        self.checkInProfileBlock.addSubview(self.logoImage3)
                        self.logoImage3.translatesAutoresizingMaskIntoConstraints = false
                        self.logoImage3.anchor(top: self.mapBackgroundView.bottomAnchor, left: self.mapBackgroundView.rightAnchor, bottom: nil, right: nil, paddingTop: -15, paddingLeft: -60, paddingBottom: 0, paddingRight: 0, width: logo3Dim, height: logo3Dim)
                        self.logoImage3.layer.cornerRadius = logo3Dim / 2
                        //self.logoImage3.layer.borderWidth = 3
                        //self.logoImage3.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
                        
                        let profileImageDim: CGFloat = 70
                        self.checkInProfileBlock.addSubview(self.checkInProfileImageView)
                        self.checkInProfileImageView.translatesAutoresizingMaskIntoConstraints = false
                        self.checkInProfileImageView.anchor(top: nil, left: nil, bottom: self.logoImage1.topAnchor, right: self.mapBackgroundView.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 8, width: profileImageDim, height: profileImageDim)
                        self.checkInProfileImageView.layer.cornerRadius = profileImageDim / 2
                        //self.checkInProfileImageView.layer.borderWidth = 3
                        //self.checkInProfileImageView.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
                        

                        self.actionBlock.addSubview(self.actionLabel)
                        self.actionLabel.anchor(top: self.actionBlock.topAnchor, left: self.actionBlock.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 0, height: 35)
                        
                        self.actionBlock.addSubview(self.actionLabel2)
                        self.actionLabel2.anchor(top: self.actionLabel.bottomAnchor, left: self.actionLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 35)
                    
                        self.actionBlock.addSubview(self.actionLabel3)
                        self.actionLabel3.anchor(top: self.actionLabel2.bottomAnchor, left: self.actionLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: -2, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)


 
                       }
                    
                        print("choose function 3")
                        
                    case 4: numberOfLogos = 4
                        print("choose function 4")
                    
                    case 5: numberOfLogos = 5
                        print("choose function 5")
                            
                    case 6: numberOfLogos = 6
                        print("choose function 6")
                    
                    case 7: numberOfLogos = 7
                        print("choose function 7")
                        
                    case 8: numberOfLogos = 8
                        print("choose function 8")
                    
                    case 9: numberOfLogos = 9
                        print("choose function 9")
                            
                    case 10: numberOfLogos = 10
                        print("choose function 10")
                    
                    case 11: numberOfLogos = 11
                        print("choose function 11")
                        
                    case 12: numberOfLogos = 12
                        print("choose function 12")
                               
                    default:
                        print("Integer value not within range")
                }
                
                
            } else {
                numberOfLogos = 0
            }
                print("the post id \(postId) yeilds this number of user logos here should be \(numberOfLogos)")
        
        }
    }
    
    func configureComments() {
        
        var numberOfComments: Int!
        guard let post = self.post else { return }
        guard let postId = post.postId else { return }

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
    
    func setToTrue(_ bool: Bool) {
        // setting bool to false to consistenly ensure we are loading. unless it is the first checkin value reload
        didLoad = bool
    }
    

    func fetchPosts(_ postId: String) {
        
        if self.didLoad == false {
                                           self.logos.removeAll()
        //guard let postIdenitifier = post?.postId else { return }

        DataService.instance.REF_POSTS.child(postId).observe(.childAdded) {(snapshot: DataSnapshot) in
      
                    guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                    
 
                     allObjects.forEach({ (snapshot) in
                          let key = snapshot.key

                         
                        Database.fetchStoreLogos(with: postId, logoId: key, completion: { (post) in
              
                              self.logos.append(post)
                                
                            self.collectionViewHorizontal.reloadData()
                                
                            self.didLoad = true
                            print("did load set to true")
                                  
                          })
                          
                      })
                        
                    }
                } else {
         
            print("Did load is set to FALSE so it can load again")
            
            self.didLoad = false
        }
        
     }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// flow layout will allow the collectionview to follow the normal contraints 
extension CheckInCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return numberOfCells
        
        print("THIS IS THE LOGO COUNT \(logos.count)")
        return logos.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
  
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 100

       return CGSize(width: width, height: width)
    }
    
    // calling function to give space and insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        //return UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCircleCellIdentifier, for: indexPath)
        
        let cell = collectionViewHorizontal.dequeueReusableCell(withReuseIdentifier: reuseCircleCellIdentifier, for: indexPath) as! CircleCell
        
        cell.logo = logos[indexPath.item]
        
        print("HERE IS THE IMAGE URL \(cell.logo?.logoUrl)")
        
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Do something here when pressed")
    }
    

}




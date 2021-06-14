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
    var toggle1 = false
    var toggle2 = false
    var toggle3 = false
    var shiftVal: CGFloat!
    var isTransitioned = false
    var isWildCardSet = false
    var timerStarted = false
    
    var willLoop = false
    var toggleSet = false
    
    
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
                
                guard let firstname = user.firstname else { return }
                self.congratulationLabel.text = "Congrats \(firstname)!"
            
                
            }
            
            

            //likesLabel.text = "\(likes)"
            let attributedText = NSMutableAttributedString(string: "0", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
            attributedText.append(NSAttributedString(string: " likes", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 50, green: 80, blue: 150)]))
            likesLabel.attributedText = attributedText
            
            configureLikeButton()
            
            configureComments()
            
            configureFollowFollowing()
            
            //self.collectionView?.refreshControl?.endRefreshing()
            
            //print("Debug: the value of didload is \(self.didLoad)")

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
        return view
    }()
    
    let likeBackgroundView: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 30 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 0.20).cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()
    
    let wantsToLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.textColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        label.textAlignment = .left
        label.text = "180+ other people want to do this"
        return label
    } ()
    
    let statisticsBlock: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 248, green: 248, blue: 248)
        return view
    }()
    
    let profileImageBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 238, green: 238, blue: 238)
        view.layer.cornerRadius = 30 / 2
        return view
    }()
    
    let walkRatingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.statusBarGreen()
        return view
    }()
    
    let lineViewTop: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let tripCompletedBackground: UIView = {
        let view = UIView()
        return view
    }()
    
    let tripCompletedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        label.textColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        label.textAlignment = .center
        label.text = "Checkin"
        return label
    } ()
    
    lazy var checkMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "tripCompletedMarker"), for: .normal)
        button.tintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    } ()
    
    
    let lineViewClear: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.55)
        return view
    }()
    
    let walkRatingShadow: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    let walkRatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Black", size: 32)
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        label.textAlignment = .center
        label.text = "91"
        return label
    } ()
    
    let finishFlagLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont(name: "Avenir-Black", size: 19)
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        label.textColor = UIColor.rgb(red: 100, green: 100, blue:1000)
        label.textAlignment = .center
        label.text = "TRIP COMPLETED"
        return label
    } ()
    
    lazy var finishFlagButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "checkInFlag"), for: .normal)
        button.tintColor = UIColor.rgb(red: 255, green: 0, blue: 0)
        //button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    } ()
    
    
    lazy var stopMarkerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "stopMarkerPin"), for: .normal)
        button.tintColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        //button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    } ()
    
    lazy var durationClockButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "durationIcon"), for: .normal)
        button.tintColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        //button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    } ()
    
    
    let walkRatingTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textColor = UIColor.rgb(red: 180, green: 180, blue: 180)
        label.textAlignment = .center
        label.text = "Walkzilla Rating"
        return label
    } ()
    

    
    let foregroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        return view
    }()
    
    let foregroundTopView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        return view
    }()
    
    let foregroundGradientView: GradientClearView = {
        let view = GradientClearView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var walkzillaLogo: UIButton = {  // We need to use a lazy var when converting a button into an action within a cell class.
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "zillaLogo2"), for: .normal)
        button.tintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    lazy var favoritesButton: UIButton = {  // We need to use a lazy var when converting a button into an action within a cell class.
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 0, green: 200, blue: 0)
        button.titleLabel?.font =  UIFont(name: "ArialRoundedMTBold", size: 15)
        button.setTitle("View Menus", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255), for: .normal)
        //button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    
    lazy var completedCheckin: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "completeCheckIcon"), for: .normal)
        //button.tintColor = UIColor.rgb(red: 225, green: 225, blue: 225)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    } ()
    
    
    
    lazy var menuButton: UIButton = {  // We need to use a lazy var when converting a button into an action within a cell class.
        let button = UIButton(type: .system)
        //button.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //button.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        //button.titleLabel?.font =  UIFont(name: "HelveticaNeue", size: 13)
        button.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 13)
        button.setTitle("Shop Restaurants", for: .normal)
        //button.setTitle("", for: .normal)
        //button.setTitleColor(UIColor.rgb(red: 80, green: 80, blue: 80), for: .normal)
        button.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255), for: .normal)
        //button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)

       // button.layer.shadowOpacity = 30 // Shadow is 30 percent opaque.
       // button.layer.shadowColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 0.20).cgColor
       // button.layer.shadowRadius = 8
       // button.layer.shadowOffset = CGSize(width: 0, height: 4)
        return button
    }()
    
    lazy var menuRightArrow: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "rightMenuArrow"), for: .normal)
        button.tintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    } ()

    
    lazy var locationButton: UIButton = {  // We need to use a lazy var when converting a button into an action within a cell class.
        let button = UIButton(type: .system)
        button.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 15)
        button.setImage(UIImage(named: "locationMarker"), for: .normal)
        button.tintColor = UIColor.walkzillaRed()
        //button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
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
    
    let lineView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor.rgb(red: 22, green: 166, blue: 62)
        view.backgroundColor = UIColor.rgb(red: 248, green: 248, blue: 248)
        return view
    }()
    
    lazy var mapBackgroundView: UIView = {
        let view = UIView()
        let mapTap = UITapGestureRecognizer(target: self, action: #selector(handleCommentTapped))
        mapTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(mapTap)
        return view
    }()
    
    let separatorLowerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 100, green: 100, blue: 200)
        return view
    }()
    
    let actionBlock: UIView = {
        let view = UIView()
        return view
    }()
    
    let actionLabel1: UILabel = { // Will replace later with an action label.
        let label = UILabel()
        //label.text = "FORTUNE"
        label.text = "Fortune"
        //label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.textColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        label.font = UIFont(name: "ArialRoundedMTBold", size: 38)
        //label.font = UIFont(name: "HelveticaNeue-Bold", size: 32)
        label.setLineSpacing(lineSpacing: 1)
        label.textAlignment = .left
        label.setLineHeight(lineHeight: 0)
        label.numberOfLines = 3
        label.alpha = 0
        return label
    } ()
    
    let actionLabel2: UILabel = { // Will replace later with an action label.
        let label = UILabel()
        //abel.text = "FAVORS"
        label.text = " Favors"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        //label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.textColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 32)
        //label.font = UIFont(name: "ArialHebrew", size: 32)
        label.font = UIFont(name: "ArialRoundedMTBold", size: 38)
        //label.font = UIFont(name: "PingFangTC-Semibold", size: 32)
        label.setLineSpacing(lineSpacing: 1)
        label.textAlignment = .left
        label.setLineHeight(lineHeight: 0)
        label.numberOfLines = 1
        label.alpha = 0
        return label
    } ()
    
    let actionLabel3: UILabel = { // Will replace later with an action label.
        let label = UILabel()
        label.text = " The"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        //label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 28)
        label.font = UIFont(name: "ArialRoundedMTBold", size: 38)
        //label.font = UIFont(name: "PingFangTC-Semibold", size: 32)
        label.setLineSpacing(lineSpacing: 1)
        label.textAlignment = .left
        //label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
        label.textColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //label.backgroundColor = UIColor.red
        label.setLineHeight(lineHeight: 0)
        label.numberOfLines = 1
        label.alpha = 0
        return label
    } ()
    
    
    let actionLabel4: UILabel = { // Will replace later with an action label.
        let label = UILabel()
        label.text = "Brave."
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        //label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 28)
        label.font = UIFont(name: "ArialRoundedMTBold", size: 38)
        //label.font = UIFont(name: "PingFangTC-Semibold", size: 32)
        label.setLineSpacing(lineSpacing: 1)
        label.textAlignment = .left
        //label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
        label.textColor = UIColor.rgb(red: 255, green: 0, blue: 0)
        //label.backgroundColor = UIColor.red
        label.setLineHeight(lineHeight: 0)
        label.numberOfLines = 1
        label.alpha = 0
        return label
    } ()
    
    let actionLabel3Block: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.walkzillaRed()
        return view
    }()
    

    
    lazy var newLikeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "walkzillaHeartUnselected"), for: .normal)
        button.tintColor = UIColor.rgb(red: 200, green: 200, blue: 200)
        //button.tintColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    } ()

    let checkInBackground: UIView = {
        let view = UIView()
        //view.alpha = 0
        return view
    }()
    

    
    let centerCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 252, green: 252, blue: 252)
       // view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        //view.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.15).cgColor
        //view.layer.shadowRadius = 6
       // view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.alpha = 1
        return view
    }()
    
    let leftCard: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.15).cgColor
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.alpha = 0
        return view
    }()
    
    let rightCard1: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.15).cgColor
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.alpha = 0
        return view
    }()
    
    let rightCard2: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.15).cgColor
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.alpha = 1
        return view
    }()
    
    let rightCard3: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.15).cgColor
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.alpha = 1
        return view
    }()
    
    let rightCard4: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.15).cgColor
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.alpha = 1
        return view
    }()
    
    let wildCard: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.15).cgColor
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.alpha = 1
        return view
    }()
    
    let spacerBlock: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.walkzillaRed()
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
        label.font = UIFont(name: "HelveticaNeue", size: 13)
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
    
    let circleDotView1: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2 / 2
        view.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        return view
    }()

    lazy var captionBlock: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.rgb(red: 255, green: 0, blue: 0).cgColor
        return view
    }()
    
    let line1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        return view
    }()
    let line1Fill: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.statusBarGreen()
        return view
    }()
    
    let line2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        return view
    }()
    
    let line2Fill: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.statusBarGreen()
        return view
    }()
    
    let line3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        return view
    }()
    
    let line3Fill: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.statusBarGreen()
        return view
    }()
    
    let line4: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        return view
    }()
    
    let line4Fill: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.statusBarGreen()
        return view
    }()
    
    
    
    
    lazy var userCommentBlock: UIView = {
        let view = UIView()
        //view.layer.backgroundColor = UIColor.rgb(red: 248, green: 248, blue: 248).cgColor
        let addCommentTapped = UITapGestureRecognizer(target: self, action: #selector(handleCommentTapped))
        addCommentTapped.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(addCommentTapped)
        return view
    }()
    
    let viewAddComment: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.textAlignment = .left
        //label.text = "Sponsored partnership with #Cava #TheRiggsby #BanditTaco"
   
        let attributedText = NSMutableAttributedString(string: "Sponsored partnership with", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
        attributedText.append(NSAttributedString(string: " #Cava #TheRiggsby #BanditTaco", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 50, green: 80, blue: 150)]))
        label.attributedText = attributedText
        label.numberOfLines = 2
        return label
    } ()
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
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleMenuTapped))
        likeTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        return iv
    } ()
    
    let logoBackground1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        return view
    }()
    
    lazy var logoImage: CustomImageView = {  // Using the Custom image view class.
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
    
    lazy var logoImageRight: CustomImageView = {  // Using the Custom image view class.
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
    
    lazy var logoImageFarRight: CustomImageView = {  // Using the Custom image view class.
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
    
    lazy var logoImage1: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true

        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleLogo1Tapped))
        likeTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        iv.alpha = 0
        return iv
    } ()
    
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.statusBarGreen()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 35)
        label.text = "675"
        return label
    } ()
    
    let pointsLabelRight: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.statusBarGreen()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 35)
        label.text = "475"
        return label
    } ()
    
    let pointsLabelFarRight: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.statusBarGreen()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 35)
        label.text = "975"
        return label
    } ()
    
    
    let plusLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.statusBarGreen()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.text = "+"
        return label
    } ()
    
    let plusLabelRight: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.statusBarGreen()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.text = "+"
        return label
    } ()
    
    let plusLabelFarRight: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.statusBarGreen()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.text = "+"
        return label
    } ()
    
    let pointsLabel1: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.statusBarGreen()
        label.font = UIFont(name: "Avenir-Black", size: 17)
        label.text = "675"
        label.alpha = 0
        return label
    } ()
    
    let pointsLabel2: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.statusBarGreen()
        label.font = UIFont(name: "Avenir-Black", size: 17)
        //label.font = UIFont(name: "Arial-BoldMT", size: 17)
        label.text = "675"
        label.alpha = 0
        return label
    } ()
    
    let pointsLabel3: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.statusBarGreen()
        label.font = UIFont(name: "Avenir-Black", size: 17)
        label.text = "675"
        label.alpha = 0
        return label
    } ()
    
    let plus1: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.statusBarGreen()
        label.font = UIFont(name: "Avenir-Black", size: 17)
        label.text = "+"
        label.alpha = 0
        return label
    } ()
    
    let plus2: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.statusBarGreen()
        label.font = UIFont(name: "Avenir-Black", size: 17)
        label.text = "+"
        label.alpha = 0
        return label
    } ()
    
    let plus3: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.statusBarGreen()
        label.font = UIFont(name: "Avenir-Black", size: 17)
        label.text = "+"
        label.alpha = 0
        return label
    } ()
    

    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 20, green: 20, blue: 20)
        label.font = UIFont(name: "Arial-BoldMT", size: 17)
        label.text = "Bandit Taco"
        return label
    } ()
    
    let logoLabelRight: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 20, green: 20, blue: 20)
        label.font = UIFont(name: "Arial-BoldMT", size: 17)
        label.text = "Bandit Taco"
        return label
    } ()
    
    let logoLabelFarRight: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 20, green: 20, blue: 20)
        label.font = UIFont(name: "Arial-BoldMT", size: 17)
        label.text = "Bandit Taco"
        return label
    } ()
    
    
    
    
    let logoLabel1: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 20, green: 20, blue: 20)
        label.font = UIFont(name: "Arial-BoldMT", size: 17)
        label.text = "Bandit Taco"
        return label
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
        iv.alpha = 0
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
        iv.alpha = 0
        return iv
    } ()
    
    
    
    lazy var storeImage1: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleMenuTapped))
        likeTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        iv.alpha = 1
        return iv
    } ()
    
    lazy var storeImage2: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true

        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleMenuTapped))
        likeTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        iv.alpha = 1
        return iv
    } ()
    
    lazy var storeImage3: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true

        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleMenuTapped))
        likeTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        iv.alpha = 1
        return iv
    } ()
    
    let title1: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        //label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 14)
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.text = "Store Title"
        return label
    } ()
    let title2: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        //label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 14)
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.text = "Store Title 2"
        return label
    } ()
    
    let title3: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        //label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 14)
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.text = "Store Title 3"
        return label
    } ()
    
    
    let categoryLabel1: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        label.font = UIFont(name: "ArialRoundedMTBold", size: 13)
        label.text = "Healthy Options, American Cuisine"
        return label
    } ()
    
    let walkzillaScore: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "starSolid"), for: .normal)
        //button.addTarget(self, action: #selector(expansionStateCheckRight), for: .touchUpInside)
        button.tintColor = UIColor.yellow
        button.alpha = 1
        return button
    }()
    
    let walkzillaScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 180, green: 180, blue: 180)
        label.font = UIFont(name: "Avenir-Black", size: 15)
        label.text = "4.9"
        return label
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
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        //label.text = "3"
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
        //label.text = "0"
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 100, green: 100, blue: 100)
        
        let attributedText = NSMutableAttributedString(string: "0", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
        attributedText.append(NSAttributedString(string: " comments", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 50, green: 80, blue: 150)]))
        label.attributedText = attributedText
        
        
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
        //label.font = UIFont(name: "ArialRoundedMTBold", size: 13)
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        //label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.textColor = UIColor.rgb(red: 180, green: 180, blue: 180)
        label.text = "2d"
        return label
    } ()
    
    let numOfStopsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        //label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 14)
        label.textColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        label.text = "3 Stops"
        return label
    } ()
    
    let mapViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialRoundedMTBold", size: 13)
        //label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 14)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.text = "map view"
        return label
    } ()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return view
    }()
    

    
    lazy var distanceMarker: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "markerWalkzilla"), for: .normal)
        button.tintColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        //button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var distanceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "rotatingRect"), for: .normal)
        button.tintColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        //button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var stepsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "dasherWalkzilla"), for: .normal)
        button.tintColor = UIColor.rgb(red: 150, green: 150, blue: 150)
        //button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    let stepsButtonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        //label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 14)
        label.textColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        label.text = "822"
        return label
    } ()
    
    
    
    

    let distanceTitleLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.boldSystemFont(ofSize: 15)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        label.textAlignment = .center
        label.text = "DISTANCE"
        return label
    } ()
    
    let calorieTitleLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.boldSystemFont(ofSize: 15)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        //label.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        label.textColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        label.textAlignment = .center
        label.text = "CALORIES"
        return label
    } ()
    
    let timeTitleLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.boldSystemFont(ofSize: 15)
        //label.font = UIFont(name: "Arial-BoldMT", size: 15)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        label.textAlignment = .center
        label.text = "TIME"
        return label
    } ()
    
    let stepsTitleLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.boldSystemFont(ofSize: 15)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        //label.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        label.textColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        label.textAlignment = .center
        label.text = "STEPS"
        return label
    } ()
    
    
    let calorieBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)
        return view
    }()
    
    lazy var calorieButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "flameSimple"), for: .normal)
        button.tintColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        //button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    let stepsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        //label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 17)
        label.textColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        label.text = "880"
        return label
    } ()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        label.text = "8.2 mi"
        return label
    } ()
    
    let calorieLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        //label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 17)
        //label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        //label.text = "17kCals"

        let attributedText = NSMutableAttributedString(string: "CALORIES  ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)])
        attributedText.append(NSAttributedString(string: "930cal", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)]))
        label.attributedText = attributedText
        
        return label
    } ()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 19)
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        label.textColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        label.text = "2.10 hrs"
        return label
    } ()
    
    
    let tripPointsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        //label.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        label.textColor = UIColor.rgb(red: 180, green: 180, blue: 180)
        label.textAlignment = .center
        label.text = "POINTS"
        return label
    } ()
    
    let tripPointsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        label.text = "2,300"
        return label
    } ()
    
    
    let congratulationLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont(name: "Avenir-Black", size: 17)
        label.font = UIFont(name: "ArialRoundedMTBold", size: 17)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.textAlignment = .center
        label.text = "Congrats Zilla!"
        return label
    } ()
    
    let walkScoreTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        //label.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        label.textColor = UIColor.rgb(red: 180, green: 180, blue: 180)
        label.textAlignment = .center
        label.text = "STEPS"
        return label
    } ()
    
    let walkScoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        label.text = "9,233"
        return label
    } ()
    
    lazy var durationMarker: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "activityWalkzilla"), for: .normal)
        button.tintColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        //button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    
    
    
    
    let durationBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        return view
    }()
    
    let stepsBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        return view
    }()
    
    let distanceBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        return view
    }()
    
    let numOfStopsBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        return view
    }()
    
    
    
    
    
    lazy var stepsMarker: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "dasherWalkzilla"), for: .normal)
        button.tintColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        //button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        return button
    }()
    
    let titleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        label.text = "Walkzilla"
        return label
    } ()
    
    let checkInTitleLabel: UILabel = { // Will replace later with an action label.
        let label = UILabel()
        //abel.text = "FAVORS"
        label.text = "Walkzilla"
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont(name: "Arial-BoldMT", size: 17)
        label.setLineSpacing(lineSpacing: 1)
        label.textAlignment = .left
        label.setLineHeight(lineHeight: 0)
        label.numberOfLines = 1
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

   
    lazy var activityHistoryButton: UIButton = {
        let button = UIButton(type: .system)  // will need to change to custom
        button.setImage(UIImage(named: "activityWalkzilla"), for: .normal)
        button.addTarget(self, action: #selector(handleShowLikes), for: .touchUpInside)
        button.tintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        button.alpha = 1
        return button
    } ()
    
    lazy var newLikeHeart: UIButton = {
        let button = UIButton(type: .system)  // will need to change to custom
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
    
    
    lazy var starRatingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "starRating"), for: .normal)
        //button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        //button.tintColor = UIColor.rgb(red: 200, green: 200, blue: 200)
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
    
        print("THE timer set IS to FALSE NOW")
        
        configureContraints()

        backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
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
        print("handle comment tapped")
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
        
        addSubview(checkInBackground)
        checkInBackground.translatesAutoresizingMaskIntoConstraints = false
        checkInBackground.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //checkInBackground.layer.cornerRadius = 3
        
        
        
        addSubview(lineViewTop)
        lineViewTop.translatesAutoresizingMaskIntoConstraints = false
        

        
        
        addSubview(mapBackgroundView)
        mapBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        //mapBackgroundView.layer.cornerRadius = 3
      
        mapBackgroundView.addSubview(mapImageView)
        mapImageView.translatesAutoresizingMaskIntoConstraints = false
        mapImageView.clipsToBounds = true
        mapImageView.layer.cornerRadius = 3
    

/*
         // photo attributes and constraints

         //postImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
         //postImageView.layer.cornerRadius = 40
         mapImageView.clipsToBounds = true
*/
        
        /*
        addSubview(actionBlock)
        actionBlock.translatesAutoresizingMaskIntoConstraints = false
        //actionBlock.backgroundColor = UIColor.walkzillaRed()
        actionBlock.backgroundColor = UIColor.clear
        */
        
        
        //addSubview(spacerBlock)
        //spacerBlock.translatesAutoresizingMaskIntoConstraints = false
        //spacerBlock.backgroundColor = UIColor.rgb(red: 0, green: 235, blue: 235)
        
        
        addSubview(imageTranslucentBar)
        imageTranslucentBar.translatesAutoresizingMaskIntoConstraints = false
        
        // date and time attributes and constraints
        addSubview(postTimeLabel)
        postTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(finishFlagLabel)
        finishFlagLabel.translatesAutoresizingMaskIntoConstraints = false
        

        
        imageTranslucentBar.addSubview(wantsToLabel)
        wantsToLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        //addSubview(checkInLabel)
        //checkInLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //addSubview(likeBackgroundView)
        //likeBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        //likeBackgroundView.backgroundColor = UIColor.white
        
        mapImageView.addSubview(newLikeButton)
        newLikeButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        /*
        addSubview(foregroundView)
        foregroundView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(foregroundTopView)
        foregroundView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(foregroundGradientView)
        foregroundGradientView.translatesAutoresizingMaskIntoConstraints = false
        */
        


        
 

        addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(lineViewClear)
        lineViewClear.translatesAutoresizingMaskIntoConstraints = false

   
        
        addSubview(userLocationBlock)
        userLocationBlock.translatesAutoresizingMaskIntoConstraints = false

        userLocationBlock.addSubview(tripCompletedBackground)
        tripCompletedBackground.translatesAutoresizingMaskIntoConstraints = false
        
        tripCompletedBackground.addSubview(tripCompletedLabel)
        tripCompletedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tripCompletedBackground.addSubview(checkMarkButton)
        checkMarkButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(statisticsBlock)
        statisticsBlock.translatesAutoresizingMaskIntoConstraints = false
        
        statisticsBlock.addSubview(stepsBackground)
        stepsBackground.translatesAutoresizingMaskIntoConstraints = false
        
        statisticsBlock.addSubview(durationBackground)
        durationBackground.translatesAutoresizingMaskIntoConstraints = false
        
        statisticsBlock.addSubview(numOfStopsBackground)
        numOfStopsBackground.translatesAutoresizingMaskIntoConstraints = false
        
        statisticsBlock.addSubview(distanceBackground)
        distanceBackground.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        numOfStopsBackground.addSubview(stopMarkerButton)
        stopMarkerButton.translatesAutoresizingMaskIntoConstraints = false
        
        numOfStopsBackground.addSubview(numOfStopsLabel)
        numOfStopsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        durationBackground.addSubview(durationClockButton)
        durationClockButton.translatesAutoresizingMaskIntoConstraints = false
        
        durationBackground.addSubview(durationLabel)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        distanceBackground.addSubview(distanceButton)
        distanceButton.translatesAutoresizingMaskIntoConstraints = false
        
        distanceBackground.addSubview(distanceLabel)
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stepsBackground.addSubview(stepsButton)
        stepsButton.translatesAutoresizingMaskIntoConstraints = false
        
        stepsBackground.addSubview(stepsLabel)
        stepsLabel.translatesAutoresizingMaskIntoConstraints = false

        
        
        userLocationBlock.addSubview(locationButton)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        userLocationBlock.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(userCommentBlock)
        userCommentBlock.translatesAutoresizingMaskIntoConstraints = false
        
        //addSubview(separatorLowerView)
        //separatorLowerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        userCommentBlock.addSubview(viewAddComment)
        viewAddComment.translatesAutoresizingMaskIntoConstraints = false
        
        userLocationBlock.addSubview(profileImageBackground)
        profileImageBackground.translatesAutoresizingMaskIntoConstraints = false
        
        // profile attributes and constraints
        profileImageBackground.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        /*
        mapBackgroundView.addSubview(checkInProfileImageView)
        checkInProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        mapBackgroundView.addSubview(completedCheckin)
        completedCheckin.translatesAutoresizingMaskIntoConstraints = false
        */

        
     
        
        // separator attributes and constraints
        userLocationBlock.addSubview(circleDotView)
        circleDotView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        // username attributes and constraints
        userLocationBlock.addSubview(usernameButton)
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        

        /*
        userLocationBlock.addSubview(circleDotView1)
        circleDotView1.translatesAutoresizingMaskIntoConstraints = false
         */
         // following/follower attributes and constraints
        userLocationBlock.addSubview(followFollowingLabel)
         followFollowingLabel.translatesAutoresizingMaskIntoConstraints = false
       


        
        lineViewClear.addSubview(menuButton)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        
        lineViewClear.addSubview(menuRightArrow)
        menuRightArrow.translatesAutoresizingMaskIntoConstraints = false

        
        
        /*
        mapBackgroundView.addSubview(tripPointsTitleLabel)
        tripPointsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mapBackgroundView.addSubview(tripPointsLabel)
        tripPointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mapBackgroundView.addSubview(walkScoreTitleLabel)
        walkScoreTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mapBackgroundView.addSubview(walkScoreLabel)
        walkScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mapBackgroundView.addSubview(congratulationLabel)
        congratulationLabel.translatesAutoresizingMaskIntoConstraints = false
        */
        
        //userLocationBlock.addSubview(newCommentBubble)
        //newCommentBubble.translatesAutoresizingMaskIntoConstraints = false

        userLocationBlock.addSubview(commentLabel)
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //userLocationBlock.addSubview(newLikeHeart)
        //newLikeHeart.translatesAutoresizingMaskIntoConstraints = false

        userLocationBlock.addSubview(likesLabel)
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        /*
        // check in profile image
        let checkInProfileDimension = CGFloat(75)
        checkInProfileImageView.anchor(top: mapBackgroundView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: checkInProfileDimension, height: checkInProfileDimension)
        checkInProfileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        checkInProfileImageView.layer.cornerRadius = checkInProfileDimension / 2
        
        completedCheckin.anchor(top: checkInProfileImageView.bottomAnchor, left: checkInProfileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: -25, paddingLeft: -20, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)

        
        congratulationLabel.anchor(top: checkInProfileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        congratulationLabel.centerXAnchor.constraint(equalTo: checkInProfileImageView.centerXAnchor).isActive = true
        
        
        tripPointsTitleLabel.anchor(top: checkInProfileImageView.topAnchor, left: checkInProfileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 55, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        tripPointsLabel.anchor(top: tripPointsTitleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tripPointsLabel.centerXAnchor.constraint(equalTo: tripPointsTitleLabel.centerXAnchor).isActive = true
        
        
        walkScoreTitleLabel.anchor(top: checkInProfileImageView.topAnchor, left: nil, bottom: nil, right: checkInProfileImageView.leftAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 55, width: 0, height: 0)
        
        walkScoreLabel.anchor(top: walkScoreTitleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        walkScoreLabel.centerXAnchor.constraint(equalTo: walkScoreTitleLabel.centerXAnchor).isActive = true
        
        */
        
        
        //userLocationBlock.anchor(top: nil, left: leftAnchor, bottom: userCommentBlock.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 28)
        

        
        
             // newLikeHeart.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
              
           //   newCommentBubble.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 15, height: 14)
              
              
 
        
              //stackView2.anchor(top: stackView.topAnchor, left: stackView.rightAnchor, bottom: nil, right: nil , paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        
        profileImageBackground.anchor(top: userLocationBlock.topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        
        let profileImageDimension = CGFloat(30)
        profileImageView.anchor(top: profileImageBackground.topAnchor, left: nil, bottom: profileImageBackground.bottomAnchor, right: profileImageBackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: profileImageDimension, height: profileImageDimension)
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        
        usernameButton.anchor(top: profileImageBackground.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 16)
        //usernameButton.centerYAnchor.constraint(equalTo: profileImageBackground.centerYAnchor).isActive = true
        

        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[profileImage(30)]-8-[location]-4-[marker(8)]", options: [], metrics: nil, views: ["profileImage": profileImageView, "marker": locationButton, "location": locationLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[username]-0-[location]", options: [], metrics: nil, views: ["username": usernameButton, "location": locationLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[username]-0-[marker(12)]", options: [], metrics: nil, views: ["username": usernameButton, "marker": locationButton]))
        
        

        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[pressHeart(23)]-38-|", options: [], metrics: nil, views: ["pressHeart": newLikeButton]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-1-[pressHeart(23)]", options: [], metrics: nil, views: ["pressHeart": newLikeButton]))
        
        /*
        circleDotView1.anchor(top: locationLabel.topAnchor, left: locationLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 9, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: 2, height: 2)
        
        usernameButton.anchor(top: locationLabel.topAnchor, left: circleDotView1.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: 0, height: 16)
        
        circleDotView.anchor(top: usernameButton.topAnchor, left: usernameButton.rightAnchor, bottom: nil, right: nil, paddingTop: 9, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 2, height: 2)

       followFollowingLabel.anchor(top: usernameButton.topAnchor, left: circleDotView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
 
        */
        
        
        // check in background
    
        checkInBackground.anchor(top: userCommentBlock.bottomAnchor, left: leftAnchor, bottom: lineViewTop.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        lineViewClear.anchor(top: nil, left: checkInBackground.leftAnchor, bottom: checkInBackground.bottomAnchor, right: checkInBackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 42)
        
        lineViewTop.anchor(top: nil, left: checkInBackground.leftAnchor, bottom: lineView.topAnchor, right: checkInBackground.rightAnchor, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 62)
        lineViewTop.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        lineView.anchor(top: nil, left: checkInBackground.leftAnchor, bottom: mapBackgroundView.topAnchor, right: checkInBackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 6)
        
        
        
        /*
        checkInBackground.addSubview(walkzillaLogo)
        walkzillaLogo.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 65)
        walkzillaLogo.centerXAnchor.constraint(equalTo: checkInBackground.centerXAnchor).isActive = true
        walkzillaLogo.centerYAnchor.constraint(equalTo: checkInBackground.centerYAnchor).isActive = true
        */

        


        // map background
        
        mapBackgroundView.anchor(top: lineView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 160)
        mapBackgroundView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        menuButton.anchor(top: nil, left: lineViewClear.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 25)
        menuButton.centerYAnchor.constraint(equalTo: lineViewClear.centerYAnchor).isActive = true
        //menuButton.layer.borderWidth = 0.5
        //menuButton.layer.borderColor = UIColor.rgb(red: 180, green: 180, blue: 180).cgColor
        //menuButton.layer.cornerRadius = 18
        //menuButton.layer.cornerRadius = 3
        
        
        menuRightArrow.anchor(top: nil, left: nil, bottom: nil, right: lineViewTop.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 7, height: 14)
        menuRightArrow.centerYAnchor.constraint(equalTo: lineViewClear.centerYAnchor).isActive = true
        
        
        //likeBackgroundView.anchor(top: mapImageView.topAnchor, left: nil, bottom: nil, right: mapImageView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 37, height: 37)
        //likeBackgroundView.layer.cornerRadius = 3
        
        newLikeButton.anchor(top: mapImageView.topAnchor, left: nil, bottom: nil, right: mapImageView.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 32, width: 23, height: 20)
        //newLikeButton.centerYAnchor.constraint(equalTo: imageTranslucentBar.centerYAnchor).isActive = true
        

       
        
        mapImageView.anchor(top: mapBackgroundView.topAnchor, left: mapBackgroundView.leftAnchor, bottom: mapBackgroundView.bottomAnchor, right: mapBackgroundView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        statisticsBlock.anchor(top: mapBackgroundView.bottomAnchor, left: mapBackgroundView.leftAnchor, bottom: nil, right: mapBackgroundView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        numOfStopsBackground.anchor(top: statisticsBlock.topAnchor, left: statisticsBlock.leftAnchor, bottom: statisticsBlock.bottomAnchor, right: nil, paddingTop: 4, paddingLeft: 5.5, paddingBottom: 4, paddingRight: 0, width: ( frame.width / 4 ) - 6, height: 0)
        numOfStopsBackground.layer.cornerRadius = 20
        
        durationBackground.anchor(top: statisticsBlock.topAnchor, left: numOfStopsBackground.rightAnchor, bottom: statisticsBlock.bottomAnchor, right: nil, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 0, width: ( frame.width / 4 ) - 6, height: 0)
        durationBackground.layer.cornerRadius = 20
        
        distanceBackground.anchor(top: statisticsBlock.topAnchor, left: durationBackground.rightAnchor, bottom: statisticsBlock.bottomAnchor, right: nil, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 0, width: ( frame.width / 4 ) - 6, height: 0)
        distanceBackground.layer.cornerRadius = 20
        
        stepsBackground.anchor(top: statisticsBlock.topAnchor, left: distanceBackground.rightAnchor, bottom: statisticsBlock.bottomAnchor, right: nil, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 0, width: ( frame.width / 4 ) - 6, height: 0)
        stepsBackground.layer.cornerRadius = 20
        
        // stop marker
        
        stopMarkerButton.anchor(top: nil, left: numOfStopsBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 17, height: 22)
        stopMarkerButton.centerYAnchor.constraint(equalTo: numOfStopsBackground.centerYAnchor).isActive = true
        
        
        numOfStopsLabel.anchor(top: nil, left: stopMarkerButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
         numOfStopsLabel.centerYAnchor.constraint(equalTo: numOfStopsBackground.centerYAnchor).isActive = true
        
        
            // duration marker
        
        durationClockButton.anchor(top: nil, left: durationBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        durationClockButton.centerYAnchor.constraint(equalTo: durationBackground.centerYAnchor).isActive = true
        
        
        durationLabel.anchor(top: nil, left: durationClockButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
         durationLabel.centerYAnchor.constraint(equalTo: durationBackground.centerYAnchor).isActive = true
        
        
            // distance marker
        
        distanceButton.anchor(top: nil, left: distanceBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        distanceButton.centerYAnchor.constraint(equalTo: distanceBackground.centerYAnchor).isActive = true
        
        
        distanceLabel.anchor(top: nil, left: distanceButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
         distanceLabel.centerYAnchor.constraint(equalTo: distanceBackground.centerYAnchor).isActive = true
        
        
        
            // steps marker
        
        stepsButton.anchor(top: nil, left: stepsBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        stepsButton.centerYAnchor.constraint(equalTo: stepsBackground.centerYAnchor).isActive = true
        
        
        stepsLabel.anchor(top: nil, left: stepsButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
         stepsLabel.centerYAnchor.constraint(equalTo: stepsBackground.centerYAnchor).isActive = true
        
        
        
        imageTranslucentBar.anchor(top: statisticsBlock.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 48)
        //imageTranslucentBar.backgroundColor = UIColor.rgb(red: 222, green: 230, blue: 60)
        

        
        
        
             let stackView = UIStackView(arrangedSubviews: [likesLabel, commentLabel])
              
              stackView.axis = .horizontal
              stackView.distribution = .equalSpacing
              stackView.alignment = .center
              stackView.spacing = 10
              stackView.translatesAutoresizingMaskIntoConstraints = false
              userLocationBlock.addSubview(stackView)
              
        /*
              let stackView2 = UIStackView(arrangedSubviews: [newCommentBubble, commentLabel])
              
              stackView2.axis = .horizontal
              stackView2.distribution = .equalSpacing
              stackView2.alignment = .center
              stackView2.spacing = 5
              stackView2.translatesAutoresizingMaskIntoConstraints = false
              userLocationBlock.addSubview(stackView2)
              */

        stackView.anchor(top: imageTranslucentBar.topAnchor, left: imageTranslucentBar.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        wantsToLabel.anchor(top: stackView.bottomAnchor, left: stackView.leftAnchor, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        
        

        //userLocationBlock.backgroundColor = .red
        

        
        
        finishFlagLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 3, paddingLeft: 0, paddingBottom: 0, paddingRight: 32, width: 0, height: 0)
        finishFlagLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        //finishFlagLabel.centerYAnchor.constraint(equalTo: imageTranslucentBar.centerYAnchor).isActive = true
        
        //finishFlagButton.anchor(top: topAnchor, left: finishFlagLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 13, height: 15)
        
        
        
       
        userLocationBlock.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 42)
        userLocationBlock.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        tripCompletedBackground.anchor(top: userLocationBlock.topAnchor, left: nil, bottom: nil, right: userLocationBlock.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 90, height: 36)
        //tripCompletedBackground.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        tripCompletedBackground.backgroundColor = UIColor.greenSalad()
        tripCompletedBackground.layer.cornerRadius = 18
        
        tripCompletedLabel.anchor(top: nil, left: tripCompletedBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //tripCompletedLabel.centerXAnchor.constraint(equalTo: tripCompletedBackground.centerXAnchor).isActive = true
        tripCompletedLabel.centerYAnchor.constraint(equalTo: tripCompletedBackground.centerYAnchor).isActive = true
        
        checkMarkButton.anchor(top: nil, left: tripCompletedLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 2, paddingBottom: 0, paddingRight: 0, width: 11, height: 9)
        checkMarkButton.centerYAnchor.constraint(equalTo: tripCompletedBackground.centerYAnchor).isActive = true
        
        userCommentBlock.anchor(top: userLocationBlock.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 24)
        userCommentBlock.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        viewAddComment.anchor(top: userCommentBlock.topAnchor, left: userCommentBlock.leftAnchor, bottom: nil, right: userCommentBlock.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        

        
        //separatorLowerView.anchor(top: userCommentBlock.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //separatorLowerView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        
        //checkInBackground.addSubview(favoritesButton)
        //favoritesButton.translatesAutoresizingMaskIntoConstraints = false
        
        /*
        favoritesButton.anchor(top: nil, left: checkInBackground.leftAnchor, bottom: checkInBackground.bottomAnchor, right: checkInBackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        favoritesButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        favoritesButton.layer.cornerRadius = 3
        */


    

        
        //statisticsBlock.addSubview(distanceLabel)
          //distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        //statisticsBlock.addSubview(distanceTitleLabel)
        //distanceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
          
     
        //statisticsBlock.addSubview(stepsLabel)
        //stepsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //statisticsBlock.addSubview(stepsTitleLabel)
       //stepsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        

          
        //statisticsBlock.addSubview(durationLabel)
          //durationLabel.translatesAutoresizingMaskIntoConstraints = false
        //statisticsBlock.addSubview(timeTitleLabel)
       //translatesAutoresizingMaskIntoConstraints = false
          
        
      //  statisticsBlock.addSubview(calorieLabel)
      // calorieLabel.translatesAutoresizingMaskIntoConstraints = false
      //  statisticsBlock.addSubview(calorieTitleLabel)
       // calorieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    
 /*
        addSubview(tripPointsTitleLabel)
        tripPointsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tripPointsLabel)
        tripPointsLabel.translatesAutoresizingMaskIntoConstraints = false
  */

        //distanceTitleLabel.anchor(top: nil, left: timeTitleLabel.leftAnchor, bottom: timeTitleLabel.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 100, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //distanceLabel.anchor(top: mapBackgroundView.topAnchor, left: mapBackgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        /*
        let stackView3 = UIStackView(arrangedSubviews: [durationLabel, distanceLabel, calorieLabel])
        
        stackView3.axis = .horizontal
        stackView3.distribution = .equalSpacing
        stackView3.alignment = .center
        //stackView3.spacing = 5
        stackView3.translatesAutoresizingMaskIntoConstraints = false
        */
        /*
        statisticsBlock.addSubview(stackView3)
        stackView3.anchor(top: statisticsBlock.topAnchor, left: statisticsBlock.leftAnchor, bottom: nil, right: statisticsBlock.rightAnchor, paddingTop: 8, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        stackView3.centerXAnchor.constraint(equalTo: statisticsBlock.centerXAnchor).isActive = true
        stackView3.centerYAnchor.constraint(equalTo: statisticsBlock.centerYAnchor).isActive = true
        */
        
        /*
        distanceTitleLabel.anchor(top: distanceLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        distanceTitleLabel.centerXAnchor.constraint(equalTo: distanceLabel.centerXAnchor).isActive = true
        
        stepsTitleLabel.anchor(top: stepsLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        stepsTitleLabel.centerXAnchor.constraint(equalTo: stepsLabel.centerXAnchor).isActive = true
        
        timeTitleLabel.anchor(top: durationLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        timeTitleLabel.centerXAnchor.constraint(equalTo: durationLabel.centerXAnchor).isActive = true
        
        calorieTitleLabel.anchor(top: calorieLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        calorieTitleLabel.centerXAnchor.constraint(equalTo: calorieLabel.centerXAnchor).isActive = true
        */

        /*
        
        timeTitleLabel.anchor(top: statisticsBlock.topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 35, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        durationLabel.anchor(top: nil, left: nil, bottom: timeTitleLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        durationLabel.centerXAnchor.constraint(equalTo: timeTitleLabel.centerXAnchor).isActive = true
        
        
        
        distanceTitleLabel.anchor(top: nil, left: timeTitleLabel.leftAnchor, bottom: timeTitleLabel.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 100, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        distanceLabel.anchor(top: nil, left: nil, bottom: distanceTitleLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        distanceLabel.centerXAnchor.constraint(equalTo: distanceTitleLabel.centerXAnchor).isActive = true
        
        
     //   calorieButton.anchor(top: durationMarker.topAnchor, left: durationMarker.rightAnchor, bottom:  nil, right: nil, paddingTop: 0, paddingLeft: 100, paddingBottom: 0, paddingRight: 0, width: 16, height: 19)
        
        calorieTitleLabel.anchor(top: nil, left: distanceTitleLabel.leftAnchor, bottom: timeTitleLabel.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 100, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        calorieLabel.anchor(top: nil, left: nil, bottom: calorieTitleLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        calorieLabel.centerXAnchor.constraint(equalTo: calorieTitleLabel.centerXAnchor).isActive = true
        
        
       // distanceMarker.anchor(top: nil, left: durationMarker.leftAnchor, bottom: durationMarker.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 50, paddingRight: 0, width: 13, height: 18)

        
      //  stepsMarker.anchor(top: nil, left: calorieButton.leftAnchor, bottom: calorieButton.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 50, paddingRight: 0, width: 18, height: 20)

        stepsTitleLabel.anchor(top: nil, left: calorieTitleLabel.leftAnchor, bottom: timeTitleLabel.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 100, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        stepsLabel.anchor(top: nil, left: nil, bottom: stepsTitleLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        stepsLabel.centerXAnchor.constraint(equalTo: stepsTitleLabel.centerXAnchor).isActive = true
*/
        
        
        
        
        
        
        
        /*
        imageTranslucentBar.addSubview(walkRatingShadow)
        walkRatingShadow.translatesAutoresizingMaskIntoConstraints = false
        
        walkRatingShadow.addSubview(walkRatingView)
        walkRatingView.translatesAutoresizingMaskIntoConstraints = false
        
        imageTranslucentBar.addSubview(walkRatingLabel)
        walkRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageTranslucentBar.addSubview(walkRatingTitleLabel)
        walkRatingTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        let walkBarDim: CGFloat = 4
        walkRatingShadow.anchor(top: timeTitleLabel.bottomAnchor, left: imageTranslucentBar.leftAnchor, bottom: nil, right: walkRatingLabel.leftAnchor, paddingTop: 25, paddingLeft: 35, paddingBottom: 0, paddingRight: 20, width: 0, height: 8)
        walkRatingShadow.layer.cornerRadius = walkBarDim
        
        walkRatingView.anchor(top: walkRatingShadow.topAnchor, left: walkRatingShadow.leftAnchor, bottom: walkRatingShadow.bottomAnchor, right: walkRatingShadow.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 60, width: 0, height: 15)
        
        walkRatingView.layer.cornerRadius = walkBarDim
        
        
        walkRatingTitleLabel.anchor(top: walkRatingView.bottomAnchor, left: walkRatingView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        walkRatingLabel.anchor(top: nil, left: nil, bottom: nil, right: imageTranslucentBar.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 38, width: 0, height: 0)
        walkRatingLabel.centerYAnchor.constraint(equalTo: walkRatingShadow.centerYAnchor).isActive = true
        
    */
 
 
 
 
        


        
        //addSubview(activityHistoryButton)
        //activityHistoryButton.translatesAutoresizingMaskIntoConstraints = false

       // activityHistoryButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        
        postTimeLabel.anchor(top: imageTranslucentBar.topAnchor, left: nil, bottom: nil, right: imageTranslucentBar.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)
        
        //postTimeLabel.centerYAnchor.constraint(equalTo: imageTranslucentBar.centerYAnchor).isActive = true
       

        
        /*
        
        
        

        */
        

        
        

        
        
        
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
        

       
        

        
 
        

        
    
 
        //mapBackgroundView.anchor(top: nil, left: leftAnchor, bottom: locationLabel.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 220)
 

        

        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[background]-0-|", options: [], metrics: nil, views: ["background": analyticsBlock]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[actionBlock(200)]", options: [], metrics: nil, views: ["actionBlock": actionBlock]))

        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-200-[actionBlock(125)]", options: [], metrics: nil, views: ["actionBlock": actionBlock]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[lineView]-0-|", options: [], metrics: nil, views: ["lineView": lineView]))
        
        

        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(0.20)]-0-[mapBackground]", options: [], metrics: nil, views: ["lineView": lineView, "mapBackground": mapBackgroundView]))
        
        //spacerBlock.anchor(top: actionBlock.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 140)
        
       // distanceBackground.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 90, height: 40)
        //distanceBackground.layer.cornerRadius = 15
        //distanceBackground.layer.borderWidth = 0.50
        //distanceBackground.layer.borderColor = UIColor.rgb(red: 200, green: 200, blue: 200).cgColor
        
        //stepsBackground.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 90, height: 40)
        //stepsBackground.layer.cornerRadius = 15
        //stepsBackground.layer.borderWidth = 0.50
        //stepsBackground.layer.borderColor = UIColor.rgb(red: 200, green: 200, blue: 200).cgColor
        
        //durationBackground.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 90, height: 40)
        //durationBackground.layer.cornerRadius = 15
        //checkinBackground.layer.borderWidth = 0.50
        //checkinBackground.layer.borderColor = UIColor.rgb(red: 200, green: 200, blue: 200).cgColor
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-32-[mapBackground(180)]-20-[background]-0-|", options: [], metrics: nil, views: ["mapBackground": mapBackgroundView, "background": analyticsBlock]))
        

        //postImageView.layer.cornerRadius = 180 / 2
        
        
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[image(200)]-0-|", options: [], metrics: nil, views: ["image": postImageView]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[image(200)]-0-|", options: [], metrics: nil, views: ["image": postImageView]))
        

        

        
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[translucent]-0-|", options: [], metrics: nil, views: ["translucent": imageTranslucentBar]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[translucent(40)]-0-|", options: [], metrics: nil, views: ["translucent": imageTranslucentBar]))
        
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
        
      


        
        


        
        
        
       // postTimeLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //mapViewLabel.anchor(top: postTimeLabel.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //mapViewLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        

        
        
        
        
        
        circleDotView.anchor(top: usernameButton.topAnchor, left: usernameButton.rightAnchor, bottom: nil, right: nil, paddingTop: 9, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 2, height: 2)
        
        followFollowingLabel.anchor(top: usernameButton.topAnchor, left: circleDotView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
         //circleDotView.anchor(top: postTimeLabel.topAnchor, left: postTimeLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 9, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 2, height: 2)

        //followFollowingLabel.anchor(top: postTimeLabel.topAnchor, left: circleDotView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //foregroundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        /*
        foregroundTopView.anchor(top: topAnchor, left: leftAnchor, bottom: foregroundView.topAnchor, right: rightAnchor, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        foregroundTopView.addSubview(foregroundGradientView)
        foregroundGradientView.anchor(top: foregroundTopView.topAnchor, left: foregroundTopView.leftAnchor, bottom: foregroundTopView.bottomAnchor, right: foregroundTopView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        let mapImageDim: CGFloat = 190
        foregroundView.addSubview(mapBackgroundView)
        mapBackgroundView.backgroundColor = UIColor.walkzillaRed()
        mapBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        mapBackgroundView.anchor(top: foregroundView.topAnchor, left: foregroundView.leftAnchor, bottom: foregroundView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: mapImageDim, height: 0)
        //mapBackgroundView.layer.cornerRadius = mapImageDim / 8
        //mapBackgroundView.layer.borderWidth = 0.25
        //mapBackgroundView.layer.borderColor = UIColor.rgb(red: 140, green: 140, blue: 140).cgColor
        
       


        
        */
        
        
        /*
       // mapImageView.addSubview(gradientImageView)
       // gradientImageView.anchor(top: mapImageView.topAnchor, left: mapImageView.leftAnchor, bottom: mapImageView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 0)
        
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
                atts[NSAttributedString.Key.font] = UIFont(name: "HelveticaNeue", size: 13)
                
            case .hashtag:
                
                atts[NSAttributedString.Key.font] = UIFont(name: "HelveticaNeue", size: 13)
                atts[NSAttributedString.Key.foregroundColor] = UIColor.rgb(red: 50, green: 80, blue: 150)
                
            case .mention:
                
                atts[NSAttributedString.Key.font] = UIFont(name: "HelveticaNeue", size: 13)
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
            label.font = UIFont.systemFont(ofSize: 13)
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
                //self.followFollowingLabel.font = UIFont(name: "HelveticaNeue", size: 15)
                self.followFollowingLabel.font = UIFont(name: "HelveticaNeue", size: 13)
                
                self.circleDotView.backgroundColor =  UIColor.rgb(red: 0, green: 0, blue: 0)
             } else {
                 self.followFollowingLabel.text = "follow"
                //self.followFollowingLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
                self.followFollowingLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
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
        /*
        addSubview(logoImage1)
        logoImage1.translatesAutoresizingMaskIntoConstraints = false
        logoImage1.anchor(top: imageTranslucentBar.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 170, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
         logoImage1.layer.cornerRadius = 200 / 2
        
        addSubview(logoImage2)
        logoImage2.translatesAutoresizingMaskIntoConstraints = false
        logoImage2.anchor(top: imageTranslucentBar.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 50, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        logoImage2.layer.cornerRadius = 100 / 2
        */
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
                    
                    self.centerCard.removeFromSuperview()
                    //self.checkInProfileBlock.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
                        self.centerCard.backgroundColor = UIColor.rgb(red: 252, green: 252, blue: 252)
                    
                    Database.fetchLogos(with: postId) { (post) in
                        
                        //guard let logoImageUrl1 = post.logo1 else { return }
                        //self.logoImage1.loadImage(with: logoImageUrl1)
                        
                        /*
                        self.addSubview(self.checkInProfileBlock)
                        self.checkInProfileBlock.translatesAutoresizingMaskIntoConstraints = false
                        self.checkInProfileBlock.anchor(top: self.imageTranslucentBar.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
                        
                        self.checkInProfileBlock.addSubview(self.logoImage1)
                        self.logoImage1.translatesAutoresizingMaskIntoConstraints = false
                        self.logoImage1.anchor(top: self.imageTranslucentBar.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 150, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
                        self.logoImage1.layer.cornerRadius = 200 / 2
                        
 */
                    }
                    
                    //self.circleView1()
                    
                        
                    print("choose function 1")
                    
                    case 2: numberOfLogos = 2
                    
                        
                        
                    self.centerCard.removeFromSuperview()
                    //self.centerCard.backgroundColor = UIColor(red: 255/255 , green: 255/255, blue: 255/255, alpha: 1)
                    
                          Database.fetchLogos(with: postId) { (post) in
                              
                                //guard let logoImageUrl1 = post.logo1 else { return }
                                //self.logoImage1.loadImage(with: logoImageUrl1)
                            
                                //guard let logoImageUrl2 = post.logo2 else { return }
                                //self.logoImage2.loadImage(with: logoImageUrl2)
                              /*
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
                            
                                        */
                          }
                    
                    
                        print("choose function 2")
                    
                  
                    
                    case 3: numberOfLogos = 3
                    
                    self.tripCompletedBackground.alpha = 0

                    // var i = 1
                        
                    DataService.instance.REF_POSTS.child(postId).observe(.childAdded) {(snapshot: DataSnapshot) in
                             
                        guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                            
                            allObjects.forEach({ (snapshot) in
                                let logo = snapshot.key

                                 Database.fetchAnimatedLogo(with: postId, logoNum: logo) { (post) in   // i = 4 this guard statement stops
                                       
                                    if logo == "logo1" {
                                    guard let logoImageUrl1 = post.logoUrl1 else { return }
                                    self.logoImage1.loadImage(with: logoImageUrl1)
                                        
                                    guard let storeImageUrl1 = post.storeImageUrl1 else { return }
                                    self.storeImage1.loadImage(with: storeImageUrl1)
                                        
                                    guard let titleLabel1 = post.title1 else { return }
                                        self.title1.text = titleLabel1
                                    }
                                    
                                    if logo == "logo2" {
                                    guard let logoImageUrl2 = post.logoUrl2 else { return }
                                    self.logoImage2.loadImage(with: logoImageUrl2)
                                        
                                        guard let storeImageUrl2 = post.storeImageUrl2 else { return }
                                        self.storeImage2.loadImage(with: storeImageUrl2)
                                        
                                        guard let titleLabel2 = post.title2 else { return }
                                            self.title2.text = titleLabel2
                                        
                                    }
                                    
                                    if logo == "logo3" {
                                    guard let logoImageUrl3 = post.logoUrl3 else { return }
                                    self.logoImage3.loadImage(with: logoImageUrl3)
                                        
                                        guard let storeImageUrl3 = post.storeImageUrl3 else { return }
                                        self.storeImage3.loadImage(with: storeImageUrl3)
                                        
                                        guard let titleLabel3 = post.title3 else { return }
                                            self.title3.text = titleLabel3
                                    }
                                    
            self.checkInBackground.addSubview(self.storeImage1)
           self.storeImage1.translatesAutoresizingMaskIntoConstraints = false
            self.storeImage1.anchor(top: self.checkInBackground.topAnchor, left: self.checkInBackground.leftAnchor, bottom: self.checkInBackground.bottomAnchor, right: self.checkInBackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
                                    
         self.lineViewTop.addSubview(self.logoImage1)
        self.logoImage1.translatesAutoresizingMaskIntoConstraints = false
         self.logoImage1.anchor(top: self.lineViewTop.topAnchor, left: self.lineViewTop.leftAnchor, bottom: self.lineViewTop.bottomAnchor, right: nil, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 0, width: 62, height: 0)
                                    
            self.lineViewTop.addSubview(self.title1)
            self.title1.translatesAutoresizingMaskIntoConstraints = false
            self.title1.anchor(top: self.lineViewTop.topAnchor, left: self.logoImage1.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
                                                                
    self.lineViewTop.addSubview(self.categoryLabel1)
    self.categoryLabel1.anchor(top: self.title1.bottomAnchor, left: self.title1.leftAnchor, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
                                    
        self.lineViewTop.addSubview(self.starRatingButton)
        self.starRatingButton.anchor(top: self.categoryLabel1.bottomAnchor, left: self.title1.leftAnchor, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 55, height: 10)
                                    
                                    
                                    
                                    
                                    
          self.checkInBackground.addSubview(self.storeImage2)
            self.storeImage2.translatesAutoresizingMaskIntoConstraints = false
             self.storeImage2.anchor(top: self.checkInBackground.topAnchor, left: self.checkInBackground.leftAnchor, bottom: self.checkInBackground.bottomAnchor, right: self.checkInBackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
                    self.storeImage2.alpha = 0
                                    
                self.lineViewTop.addSubview(self.logoImage2)
            self.logoImage2.translatesAutoresizingMaskIntoConstraints = false
            self.logoImage2.anchor(top: self.lineViewTop.topAnchor, left: self.lineViewTop.leftAnchor, bottom: self.lineViewTop.bottomAnchor, right: nil, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 0, width: 62, height: 0)
                self.logoImage2.alpha = 0
                                    
            self.lineViewTop.addSubview(self.title2)
            self.title2.translatesAutoresizingMaskIntoConstraints = false
            self.title2.anchor(top: self.lineViewTop.topAnchor, left: self.logoImage2.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
               self.title2.alpha = 0
               
                                    
                                    
       self.checkInBackground.addSubview(self.storeImage3)
           self.storeImage3.translatesAutoresizingMaskIntoConstraints = false
               self.storeImage3.anchor(top: self.checkInBackground.topAnchor, left: self.checkInBackground.leftAnchor, bottom: self.checkInBackground.bottomAnchor, right: self.checkInBackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
                                                                
                    self.storeImage3.alpha = 0
                                    
        self.lineViewTop.addSubview(self.logoImage3)
        self.logoImage3.translatesAutoresizingMaskIntoConstraints = false
        self.logoImage3.anchor(top: self.lineViewTop.topAnchor, left: self.lineViewTop.leftAnchor, bottom: self.lineViewTop.bottomAnchor, right: nil, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 0, width: 62, height: 0)
        self.logoImage3.alpha = 0
                                    
        self.lineViewTop.addSubview(self.title3)
        self.title3.translatesAutoresizingMaskIntoConstraints = false
        self.title3.anchor(top: self.lineViewTop.topAnchor, left: self.logoImage3.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
           self.title3.alpha = 0
                                    
                                    
                                    /*
                                    self.checkInBackground.addSubview(self.actionLabel1)  // fortune
                                    self.actionLabel1.anchor(top: self.checkInBackground.topAnchor, left: self.checkInBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
                                    */
                                 
                                   
                                    
                                    /*
                                let logoDim: CGFloat = 80
                                self.checkInBackground.addSubview(self.logoImage1)
                                self.logoImage1.translatesAutoresizingMaskIntoConstraints = false
                                self.logoImage1.anchor(top: nil, left: self.checkInBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: logoDim, height: logoDim)
                                self.logoImage1.layer.cornerRadius = logoDim / 2
                                self.logoImage1.centerYAnchor.constraint(equalTo: self.checkInBackground.centerYAnchor).isActive = true


                                self.checkInBackground.addSubview(self.logoImage2)
                                self.logoImage2.translatesAutoresizingMaskIntoConstraints = false
                                self.logoImage2.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: logoDim, height: logoDim)
                                self.logoImage2.layer.cornerRadius = logoDim / 2
                                self.logoImage2.centerXAnchor.constraint(equalTo: self.checkInBackground.centerXAnchor).isActive = true
                                    self.logoImage2.centerYAnchor.constraint(equalTo: self.checkInBackground.centerYAnchor).isActive = true
                                
                                    
                                self.checkInBackground.addSubview(self.logoImage3)
                                self.logoImage3.translatesAutoresizingMaskIntoConstraints = false
                                self.logoImage3.anchor(top: nil, left: nil, bottom: nil, right: self.checkInBackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: logoDim, height: logoDim)
                                self.logoImage3.layer.cornerRadius = logoDim / 2
                                    self.logoImage3.centerYAnchor.constraint(equalTo: self.checkInBackground.centerYAnchor).isActive = true
                    */
                                    
                                }
                            })
                        
                        }
                    
                    
                    self.tripCompletedBackground.transform = CGAffineTransform(scaleX: 0, y: 0)
                         
                    UIView.animate(withDuration: 0.75, delay: 3, usingSpringWithDamping: 0.60, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                            
                            self.tripCompletedBackground.alpha = 1
                             self.tripCompletedBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
                             

                         }) { (_) in

                             self.tripCompletedBackground.transform = .identity
                         }
                    
                    
                    
                    
                    
                            
                    var i = 1
                    var limit = 0
                    
                    if self.timerStarted {
                        print("Do nothing")
                        
                        
                    } else {
                        
                        self.timerStarted = true
                        print("Timer started set to true")
                        
                        self.storeImage1.alpha = 1
                        self.logoImage1.alpha = 1
                        self.title1.alpha = 1
                    
                    //self.favoritesButton.alpha = 0
                    //self.mapBackgroundView.alpha = 1
                   // self.checkInBackground.alpha = 1
                   // self.checkInBackground.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0)
                        
                    //self.logoImage1.alpha = 0
                   // self.logoImage2.alpha = 0
                   // self.logoImage3.alpha = 0
                  /*
                    UIView.animate(withDuration: 0 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {

                        //self.mapBackgroundView.alpha = 0
                        self.checkInBackground.alpha = 1
                        
                    }) { (_) in
                */
                       // self.checkInBackground.alpha = 1
                        
                        UIView.animate(withDuration: 0 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {

                            let timer = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: true){ t in
                                
                                print("timer started")
                                
                                let logoImage = "logo\(i)"
                                
                                if i == 1 {
                                    self.storeImage1.alpha = 1
                                    self.storeImage2.alpha = 0
                                    self.storeImage3.alpha = 0
                                    
                                    self.logoImage1.alpha = 1
                                    self.logoImage2.alpha = 0
                                    self.logoImage3.alpha = 0
                                    
                                    self.title1.alpha = 1
                                    self.title2.alpha = 0
                                    self.title3.alpha = 0
                                    
                                }
                                
                                if i == 2 {
                                    self.storeImage1.alpha = 0
                                    self.storeImage2.alpha = 1
                                    self.storeImage3.alpha = 0
                                    
                                    self.logoImage1.alpha = 0
                                    self.logoImage2.alpha = 1
                                    self.logoImage3.alpha = 0
                                    
                                    self.title1.alpha = 0
                                    self.title2.alpha = 1
                                    self.title3.alpha = 0
                                    
                                }
                                
                                if i == 3 {
                                    self.storeImage1.alpha = 0
                                    self.storeImage2.alpha = 0
                                    self.storeImage3.alpha = 1
                                    
                                    self.logoImage1.alpha = 0
                                    self.logoImage2.alpha = 0
                                    self.logoImage3.alpha = 1
                                    
                                    self.title1.alpha = 0
                                    self.title2.alpha = 0
                                    self.title3.alpha = 1
                                    
                                }
                                
                                
/*
                                if i == 1 {
                                    self.actionLabel1.alpha = 1
                                }
                                if i == 2 {
                                    self.actionLabel2.alpha = 1
                                    self.actionLabel1.alpha = 0
                                }
                                if i == 3 {
                                    self.actionLabel3.alpha = 1
                                    self.actionLabel2.alpha = 0
                                    
                                    UIView.animate(withDuration: 0 , delay: 0.25, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                                        self.actionLabel4.alpha = 1
                                        self.actionLabel3.alpha = 0
                                    })
                                }
                                
                                if i == 4 {
                                    
                                    
                                    self.walkzillaLogo.alpha = 1
                                    self.actionLabel1.alpha = 0
                                    self.actionLabel2.alpha = 0
                                    self.actionLabel3.alpha = 0
                                    self.actionLabel4.alpha = 0
                                }
                                
                                if i == 5 {
                                    
                                    
                                    UIView.animate(withDuration: 0 , delay: 0.75, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                                        
                                        self.walkzillaLogo.tintColor = UIColor.rgb(red: 255, green: 0, blue: 0)
                                        self.checkInBackground.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
                                    })
                                }
                                
                                if i == 6 {
                                    
                                    UIView.animate(withDuration: 0 , delay: 0.50, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                                        
                                        self.walkzillaLogo.tintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
                                        self.walkzillaLogo.alpha = 0
                                        
                                        self.logoImage1.alpha = 1
                                        self.logoImage2.alpha = 1
                                        self.logoImage3.alpha = 1
                                        
                                       // self.favoritesButton.alpha = 1
                                    })
                                }
                    
                                
                                i += 1
                                
                                if i > 6 {
                                    print("timer stopped")
                                    t.invalidate()
                                    self.timerStarted = false
                                    
                                }
 
 */
                                
                        i += 1

                        if i > 3 {
                            if limit < 8 {
                                
                                print("limit value is \(limit)")
                                i = 1
                                limit += 1
                            } else {
                
                           print("timer stopped")
                             t.invalidate()
                             self.timerStarted = false
                            }
                         }
                                
                                
                                
                            }
                            
                            
                            
                            
                            })
 

                      //  }
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

            let attributedText = NSMutableAttributedString(string: "\(numberOfComments!)", attributes: [NSAttributedString.Key.font:  UIFont(name: "HelveticaNeue", size: 13)!])
            
            attributedText.append(NSAttributedString(string: " comments", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 50, green: 80, blue: 150)]))

            
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




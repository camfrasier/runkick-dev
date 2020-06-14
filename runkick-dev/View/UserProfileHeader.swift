//
//  UserProfileHeader.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/28/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel

class UserProfileHeader: UICollectionViewCell {
    
    let shapeLayer = CAShapeLayer()
    // Mark: - Properties
    
    var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        didSet {  // Did set here means we are going to be setting the user for our header in the controller file UserProfileVC.
            
            // Configure edit profile button
            configureEditProfileFollowButton()
            
            // configure either a send message button or photo button
            configureSendMessageButton()
            
            // Set user status
            setUserStats(for: user)
            setAdminNavigationBar(for: user)
            
            let firstname = user?.firstname
            firstnameLabel.text = firstname
            
            let lastname = user?.lastname
            lastnameLabel.text = lastname
            
            guard let username = user?.username else { return }
            usernameLabel.text = "@\(username)"
            
            guard let profileImageUrl = user?.profileImageURL else { return }  // Unwrapping this safely. Use in other functions as well.
            profileImageView.loadImage(with: profileImageUrl)
        }
    }
    
    let gradientProfileView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        iv.image = UIImage(named: "userProfileSilhouetteWhite")
        return iv
    } ()
    
    lazy var messageInboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "simpleMarineCircleSendText"), for: .normal)
        button.addTarget(self, action: #selector(handleMessagesTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        button.layer.borderWidth = 3
        button.alpha = 1
        button.backgroundColor = .clear
        return button
    }()
    
    let firstnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        return label
    } ()
    
    let lastnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        //label.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        return label
    } ()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.textColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        return label
    } ()
    
    // i would like this label to aventually be able to pinpoint your hometown on apple maps with photos
    let userBioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.rgb(red: 60, green: 60, blue: 60)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        //label.textAlignment = .left
        label.text = "I'm so, I'm so re-born.."
        return label
    } ()
    
    
    lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 100, green: 100, blue: 100)
        
        /*
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        //attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        */
        
        // add gesture recognizer
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        followTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        
        return label
    } ()
    
    lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 100, green: 100, blue: 100)
        
        /*
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        //attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        */
        
        // add gesture recognizer
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        followTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    } ()
    
    lazy var postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)]))
        label.attributedText = attributedText
        
        let postTap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        postTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(postTap)
        return label
    } ()
    
    lazy var refreshCategories: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Refresh", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), for: .normal)
        button.backgroundColor = UIColor.actionRed()
        button.addTarget(self, action: #selector(handleUpdateCategory), for: .touchUpInside)
        return button
    } ()
    
    let followersLabelText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)
        label.text = "followers"
        return label
    } ()
    
    let followingLabelText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)
        label.text = "following"
        return label
    } ()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        button.layer.borderColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        button.layer.borderWidth = 0.25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        //button.titleLabel?.font =  UIFont(name: "HelveticaNeue-CondensedBold", size: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    } ()
    
    lazy var analyticsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "simpleAnalyticsLime"), for: .normal)
        button.addTarget(self, action: #selector(handleAnalytics), for: .touchUpInside)
        return button
    } ()
    
    lazy var analyticsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1)
        let attributedText = NSMutableAttributedString(string: "Analytics\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        attributedText.append(NSAttributedString(string: "Track Progress", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)]))
        label.attributedText = attributedText

        // add gesture recognizer
        let analyticsTap = UITapGestureRecognizer(target: self, action: #selector(handleAnalytics))
        analyticsTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(analyticsTap)
        return label
    } ()
    
    let analyticsButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        //view.layer.borderColor = UIColor(red: 163/255, green: 219/255, blue: 34/255, alpha: 1).cgColor
        //view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 28
        return view
    }()
    
    lazy var favoriteItemsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "simpleBrightYellowCircleForkKnife"), for: .normal)
        button.addTarget(self, action: #selector(handleFavorites), for: .touchUpInside)
        return button
    } ()
    
    lazy var favoriteItemsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1)
        let attributedText = NSMutableAttributedString(string: "Favorites\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        attributedText.append(NSAttributedString(string: "Your Favorites", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)]))
        label.attributedText = attributedText

        // add gesture recognizer
        let favoritesTap = UITapGestureRecognizer(target: self, action: #selector(handleFavorites))
        favoritesTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(favoritesTap)
        return label
    } ()
    
    let favoritesButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        //view.layer.borderColor = UIColor(red: 163/255, green: 219/255, blue: 34/255, alpha: 1).cgColor
        //view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 28
        return view
    }()
    
    lazy var searchFriendsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "simpleBlueSearchFriends"), for: .normal)
        button.addTarget(self, action: #selector(handleSearchFriends), for: .touchUpInside)
        return button
    } ()
    
    lazy var searchFriendsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1)
        let attributedText = NSMutableAttributedString(string: "Search\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        attributedText.append(NSAttributedString(string: "Find Friends", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)]))
        label.attributedText = attributedText

        // add gesture recognizer
        let searchFriendsTap = UITapGestureRecognizer(target: self, action: #selector(handleSearchFriends))
        searchFriendsTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(searchFriendsTap)
        return label
    } ()
    
    let searchFriendsButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        //view.layer.borderColor = UIColor(red: 163/255, green: 219/255, blue: 34/255, alpha: 1).cgColor
        //view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 28
        return view
    }()
    
    lazy var searchGroupsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "simpleCirclePurpleGroups"), for: .normal)
        button.addTarget(self, action: #selector(handleSearchGroups), for: .touchUpInside)
        return button
    } ()
    
    lazy var searchGroupsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1)
        let attributedText = NSMutableAttributedString(string: "Groups\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        attributedText.append(NSAttributedString(string: "Join/Create Group", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)]))
        label.attributedText = attributedText

        // add gesture recognizer
        let searchGroupsTap = UITapGestureRecognizer(target: self, action: #selector(handleSearchGroups))
        searchGroupsTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(searchGroupsTap)
        return label
    } ()
    
    let searchGroupsButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        //view.layer.borderColor = UIColor(red: 163/255, green: 219/255, blue: 34/255, alpha: 1).cgColor
        //view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 28
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1).cgColor
        return view
    }()
    
    let separatorViewGradient: GradientView = {
        let view = GradientView()
        return view
    }()
    
    let separatorViewPost: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 181/255, green: 201/255, blue: 215/255, alpha: 1).cgColor
        return view
    }()
    
    
    lazy var roundRewardsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "simpleBlueComment"), for: .normal)
        //button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        button.layer.borderWidth = 2.5
        button.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        button.layer.cornerRadius = 60 / 2
        return button
    } ()
    
    lazy var roundSendMessageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "simpleBlueComment"), for: .normal)
        //button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        button.layer.borderWidth = 2.5
        button.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        button.layer.cornerRadius = 60 / 2
        return button
    } ()
    
    lazy var roundNotificationsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "simpleBlueComment"), for: .normal)
        //button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        button.layer.borderWidth = 2.5
        button.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        button.layer.cornerRadius = 60 / 2
        return button
    } ()
    
    let aboutSectionBlock: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return view
    }()
    
    let aboutSeparator: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        label.text = "About Me"
        return label
    }()
    
    let aboutLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .left
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1)
        label.text = "Just a guy trying to eat and live healthy is his crazy world. Loving this new app Poppwalk! Happy to meet new people."
        return label
    } ()
    
    
    let postsSeparator: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        label.text = "My Posts"
        return label
    }()
    
    lazy var gridViewButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        button.addTarget(self, action: #selector(handleGridViewTapped), for: .touchUpInside)
        button.alpha = 1
        return button
    }()
    
    lazy var activityHistoryView: UIButton = {  // when clicked make color turn gradient action blue to action red
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        button.addTarget(self, action: #selector(handleActivityTapped), for: .touchUpInside)
        button.alpha = 1
        return button
    }()
    
    lazy var messageBackgroundButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setImage(UIImage(named: "trueBlueCirclePlus"), for: .normal)
        button.addTarget(self, action: #selector(handleMessagesTapped), for: .touchUpInside)
        //button.backgroundColor = UIColor.rgb(red: 122, green: 206, blue: 53)
        button.backgroundColor = UIColor.rgb(red: 26, green: 172, blue: 239)
        button.layer.cornerRadius = 50 / 2
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.alpha = 1
        return button
    }()
    
    lazy var beBoppMessageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "beBoppSendMessage"), for: .normal)
        button.addTarget(self, action: #selector(handleMessagesTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        button.layer.shadowRadius = 3.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.alpha = 1
        return button
       }()
    
    lazy var addPhotoBackgroundButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setImage(UIImage(named: "trueBlueCirclePlus"), for: .normal)
        button.addTarget(self, action: #selector(handleAddPhotoTapped), for: .touchUpInside)
        button.backgroundColor = UIColor.rgb(red: 252, green: 180, blue: 16)
        button.layer.cornerRadius = 50 / 2
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.alpha = 1
        return button
    }()
    
    lazy var beBoppAddPhotoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "beBoppAddPhotoIcon"), for: .normal)
        button.addTarget(self, action: #selector(handleAddPhotoTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        button.layer.shadowRadius = 3.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.alpha = 1
        return button
       }()
    
    /*
    let aboutLabel: ActiveLabel = { // Will replace later with an action label.
        let label = ActiveLabel()
        label.numberOfLines = 0
        return label
    } ()
    */
    
   
    // moved to the top of the class to be accessed as a global property
    
     override init(frame: CGRect) {
     
         super.init(frame: frame)
        
        layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        
        
        configureViewComponents()
        
        configureSendMessageButton()
        
        updateAdminStorePosts()
        
        /*
        if Auth.auth().currentUser != nil {
            
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            
            print("DEBUG: The current user id is \(currentUid)")
            DataService.instance.REF_USERS.child(currentUid).child("isStoreadmin").observe(.value) { (snapshot) in
                let isStoreadmin = snapshot.value as! Bool
                
                print(snapshot.value as! Bool)
                
                if isStoreadmin == false {
        
                    self.configureViewComponents()
                    
                    self.configureSendMessageButton()
                    
                    //self.configureUserAnalytics()
                    

                } else {
        
                    self.configureViewComponents()
                    
                }
            }
        }
        */
        
     }
    
    // MARK: - Handlers (We want to delegate these actions to the controller).
    
    @objc func handleFollowersTapped() {
        delegate?.handleFollowersTapped(for:self)
    }
    
    @objc func handleFollowingTapped() {
        delegate?.handleFollowingTapped(for:self)
    }
    
    @objc func handlePostTapped() {
        delegate?.handlePostTapped(for:self)
    }
    
    // Excecutes code in the UserProfileVC
    @objc func handleEditProfileFollow() {   
        delegate?.handleEditFollowTapped(for:self)
    }
    
    @objc func handleAnalytics() {
        delegate?.handleAnalyticsTapped(for: self)
    }
    
    @objc func handleFavorites() {
        delegate?.handleFavoritesTapped(for: self)
    }
    
    @objc func handleSearchFriends() {
        delegate?.handledSearchFriendsTapped(for: self)
    }
    
    @objc func handleSearchGroups() {
        delegate?.handleSearchGroupsTapped(for: self)
    }
    
    @objc func handleCheckInTap() {
        delegate?.handleCheckInTapped(for: self)
    }
    
    @objc func handlePointsTapped() {
        delegate?.handlePointsTapped(for: self)
    }
    
    @objc func handleDistanceTapped() {
        delegate?.handleDistanceTapped(for: self)
    }
    
    @objc func handleMessagesTapped() {
        
        print("DEBUG: trying to find this issue DID IT TAP?")
        delegate?.handleMessagesTapped(for: self)
    }
    
    @objc func handleAddPhotoTapped() {
        delegate?.handleAddPhotoTapped(for: self)
    }
    
    @objc func handleGridViewTapped() {
        delegate?.handleGridViewTapped(for: self)
        
        //separatorViewGradient.transform = CGAffineTransform(translationX: 1, y: 1)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.separatorViewGradient.transform = CGAffineTransform(translationX: 210, y: 0)
        })
    }
    
    @objc func handleActivityTapped() {
        delegate?.handleActivityTapped(for: self)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.separatorViewGradient.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }

    func configureViewComponents() {
        
        let profileCircleDimension: CGFloat = 96
        addSubview(gradientProfileView)
        gradientProfileView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: profileCircleDimension, height: profileCircleDimension)
        gradientProfileView.layer.cornerRadius = profileCircleDimension / 2
        gradientProfileView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        let profileDimension: CGFloat = 90
        gradientProfileView.addSubview(profileImageView)
        profileImageView.anchor(top: gradientProfileView.topAnchor, left: gradientProfileView.leftAnchor, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: profileDimension, height: profileDimension)
        profileImageView.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.cornerRadius = profileDimension / 2
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true


        let stackView = UIStackView(arrangedSubviews: [followingLabel, followersLabel, postLabel])
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 28
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.anchor(top: usernameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        stackView.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: stackView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 14, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 35)
        editProfileFollowButton.layer.cornerRadius = 0
        editProfileFollowButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        addSubview(userBioLabel)
         userBioLabel.anchor(top: editProfileFollowButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 14, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        userBioLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        addSubview(separatorView)
        separatorView.anchor(top: userBioLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 17, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
        
         addSubview(activityHistoryView)
         activityHistoryView.anchor(top: separatorView.topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 7, paddingLeft: 95, paddingBottom: 0, paddingRight: 0, width: 16, height: 16)
         activityHistoryView.tintColor = UIColor(red: 181/255, green: 201/255, blue: 215/255, alpha: 1)
         
         addSubview(gridViewButton)
         gridViewButton.anchor(top: separatorView.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 7, paddingLeft: 95, paddingBottom: 0, paddingRight: 95, width: 16, height: 16)
         gridViewButton.tintColor = UIColor(red: 181/255, green: 201/255, blue: 215/255, alpha: 1)
        
         addSubview(separatorViewGradient)
        separatorViewGradient.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: (frame.width / 2), height: 3)
        
        
        
        /*
        addSubview(firstnameLabel)
        firstnameLabel.anchor(top: gradientProfileView.topAnchor, left: gradientProfileView.rightAnchor, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 27, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(lastnameLabel)
        lastnameLabel.anchor(top: firstnameLabel.topAnchor, left: firstnameLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(separatorView)
        separatorView.anchor(top: gradientProfileView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
        
        let stackView = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.anchor(top: firstnameLabel.bottomAnchor, left: firstnameLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 9, paddingLeft: -11, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: firstnameLabel.topAnchor, left: lastnameLabel.rightAnchor, bottom: nil, right: nil, paddingTop: -1, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 80, height: 23)
        editProfileFollowButton.layer.cornerRadius = 4
        
        addSubview(userBioLabel)
        userBioLabel.anchor(top: stackView.bottomAnchor, left: firstnameLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 9, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
        addSubview(activityHistoryView)
        activityHistoryView.anchor(top: separatorView.topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 95, paddingBottom: 0, paddingRight: 0, width: 22, height: 22)
        activityHistoryView.tintColor = UIColor(red: 181/255, green: 201/255, blue: 215/255, alpha: 1)
        
        addSubview(gridViewButton)
        gridViewButton.anchor(top: separatorView.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 95, paddingBottom: 0, paddingRight: 95, width: 22, height: 22)
        gridViewButton.tintColor = UIColor(red: 181/255, green: 201/255, blue: 215/255, alpha: 1)
       
        addSubview(separatorView2)
        separatorView2.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
        */
        
        /*
        
        
        

        
        */
        

    }
 
    func configureSendMessageButton() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let user = self.user else { return }
        
        if currentUid == user.uid {
            
            DataService.instance.REF_USERS.child(currentUid).child("isStoreadmin").observe(.value) { (snapshot) in
                let isStoreadmin = snapshot.value as! Bool
                        
                print(snapshot.value as! Bool)
                        
                if isStoreadmin == true {
                    
                    // if the current user is the user page in question AND the user is a super admin configure the photo button
                    self.configureAddPhotoButton()
                } else {
                    print("current user is the user in question but is NOT the admin .. do nothing")
                
                }
            }
 
        } else {
            
            DataService.instance.REF_USERS.child(currentUid).child("isStoreadmin").observe(.value) { (snapshot) in
                let isStoreadmin = snapshot.value as! Bool
                        
                print(snapshot.value as! Bool)
                        
                if isStoreadmin == true {
                    
                    // the current user is NOT the user in question but is an admin so we don't need to add the send message button
                    print("when we are not accessing the current users page, and the user is an admin.. allow user to send a message following or not")
                    
                    let backgroundDimension: CGFloat = 50
                    self.addSubview(self.messageBackgroundButton)
                    self.messageBackgroundButton.anchor(top: self.profileImageView.topAnchor, left: self.profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 40, paddingLeft: -25, paddingBottom: 0, paddingRight: 0, width: backgroundDimension, height: backgroundDimension)
                    self.messageBackgroundButton.layer.cornerRadius = backgroundDimension / 2
                    
                    self.messageBackgroundButton.addSubview(self.beBoppMessageButton)
                    self.beBoppMessageButton.anchor(top: self.messageBackgroundButton.topAnchor, left: self.messageBackgroundButton.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 41, height: 41)

                } else {
                    
                    user.checkIfUserIsFollowed(completion: { (followed) in
                        
                        if followed {
                            
                            // show the  send message button ONLY if the user is a user you are following
                            print("User is followed so we can show the send message button")
                            
                            let backgroundDimension: CGFloat = 60
                            self.addSubview(self.messageBackgroundButton)
                            self.messageBackgroundButton.anchor(top: self.profileImageView.topAnchor, left: self.profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 40, paddingLeft: -20, paddingBottom: 0, paddingRight: 0, width: backgroundDimension, height: backgroundDimension)
                            self.messageBackgroundButton.layer.cornerRadius = backgroundDimension / 2
                                   
                            self.messageBackgroundButton.addSubview(self.beBoppMessageButton)
                            self.beBoppMessageButton.anchor(top: self.messageBackgroundButton.topAnchor, left: self.messageBackgroundButton.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 7, paddingBottom: 0, paddingRight: 0, width: 45, height: 45)
                            
                        } else {
                            // don't show the send message button because the current user is not following the other user
                            print("this user is not followed, do not show the send message button")
                        }
                    })
                }
            }
        }
    }
    
    
    @objc func handleUpdateCategory() {
        print("refresh button pressed")
        updateCategories()
    }
    
    func updateCategories() {
        
        
        
        //let creationDate = Int(NSDate().timeIntervalSince1970)
        
        // first i have to search for categories under in the admin post (we can use the follow, like method in
          // next i have to create the category and place it under a section called categories with a title for each section "salads","greens", vegetaraian etc.
          // user the same method we use to create multiple child values under admin-posts
          // lastly i have to syft throught the categories that i created and place those category titles under the appropriate section using the
          
        
        //removing categories before refreshing them ..will need to find a more efficient way to do this
        DataService.instance.REF_CATEGORIES.removeValue()
        
              DataService.instance.REF_ADMIN_STORE_POSTS.observeSingleEvent(of: .value) { (snapshot) in
                  guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                  
                  allObjects.forEach({ (snapshot) in
                      guard let postId = snapshot.key as? String else { return }
                      print(postId)

                      DataService.instance.REF_ADMIN_STORE_POSTS.child(postId).child("category").observeSingleEvent(of: .value) { (snapshot) in
                          guard let category = snapshot.value as? String else { return }
                          print(category)
                          
                          
                          if category.contains("Salad"){   // will need to make this case insensitive
                              print("Salad has been found")
                             // print(postId) // with this post id we can find the image url, the store id, etc
                              
                              // we create a category and add the post id under the database category feed
                            //DataService.instance.REF_CATEGORIES.child("salads").childByAutoId().updateChildValues(["postId" : postId])
                            
                            // now go into the post using the post id and pull the category and store id
                            DataService.instance.REF_ADMIN_STORE_POSTS.child(postId).observeSingleEvent(of: .value) { (snapshot) in
                                
                                guard let marketDictionary = snapshot.value as? [String: Any] else { return }
                                           // may not be the right postId
                                let market = Category(postId: postId, dictionary: marketDictionary as Dictionary<String, AnyObject>)
                                           print(marketDictionary)
                                
                                //print("DEBUG: This is the caption for this section \(market.caption)")
                                           
                                guard let sendCaption = market.caption else { return }
                                guard let sendUrl = market.imageUrl else { return }
                                //let sendPoints = market.points  // may not need point value here, it represent the store and not the post
                                guard let sendStoreId = market.storeId else { return }
                                guard let sendPrice = market.price else { return }  // NEED to find a way to turn this into a decimal value I forget the name of what that is called..
                                guard let sendPoppPrice = market.poppPrice else { return }
                                //guard let creationDate = market.creationDate as? String else { return }// not the correct way to store
                                guard let sendAddress = market.address else { return }
                                let creationDate = Int(NSDate().timeIntervalSince1970)
                        
                                DataService.instance.REF_CATEGORIES.childByAutoId().updateChildValues(["postId" : postId,
                                                                                                                       "caption" : sendCaption,
                                                                                                                       "imageUrl" : sendUrl,
                                                                                                                       "storeId" : sendStoreId,
                                                                                                                       "creationDate": creationDate,
                                                                                                                       "price": Float(sendPrice),// need to be float value to load with precision
                                                                                                                       "poppPrice": Float(sendPoppPrice),
                                                                                                                       "address": sendAddress,
                                                                                                                       "category": "Salad"])
   
                                // also update category for the store unique feeds themselves based on the storeId
                            }

                          }
                          
                        
                          if category.contains("Seafood") {
                              print("Seafood has been found")
                            
                            // now go into the post using the post id and pull the category and store id
                            DataService.instance.REF_ADMIN_STORE_POSTS.child(postId).observeSingleEvent(of: .value) { (snapshot) in
                                
                                guard let marketDictionary = snapshot.value as? [String: Any] else { return }
                                           // may not be the right postId
                                let market = Category(postId: postId, dictionary: marketDictionary as Dictionary<String, AnyObject>)
                                           print(marketDictionary)
                                
                                //print("DEBUG: This is the caption for this section \(market.caption)")
                                           
                                guard let sendCaption = market.caption else { return }
                                guard let sendUrl = market.imageUrl else { return }
                                //let sendPoints = market.points  // may not need point value here, it represent the store and not the post
                                guard let sendStoreId = market.storeId else { return }
                                //guard let creationDate = market.creationDate else { return }
                                guard let sendPrice = market.price else { return }
                                guard let sendPoppPrice = market.poppPrice else { return }
                                guard let sendAddress = market.address else { return }
                                let creationDate = Int(NSDate().timeIntervalSince1970)
                                
                                print("THIS IS THE POP PRICE \(sendPrice)")
                                
                                DataService.instance.REF_CATEGORIES.childByAutoId().updateChildValues(["postId" : postId,
                                                                                                                       "caption" : sendCaption,
                                                                                                                       "imageUrl" : sendUrl,
                                                                                                                       "storeId" : sendStoreId,
                                                                                                                       "creationDate": creationDate,
                                                                                                                       "price": Float(sendPrice),
                                                                                                                       "poppPrice": Float(sendPoppPrice),
                                                                                                                       "address": sendAddress,
                                                                                                                       "category": "Seafood"])
                            }
                          }
                          
                          if category.contains("Vegetarian") {
                              print("Vegetarian has been found")
                            
                            // now go into the post using the post id and pull the category and store id
                            DataService.instance.REF_ADMIN_STORE_POSTS.child(postId).observeSingleEvent(of: .value) { (snapshot) in
                                
                                guard let marketDictionary = snapshot.value as? [String: Any] else { return }
                                           // may not be the right postId
                                let market = Category(postId: postId, dictionary: marketDictionary as Dictionary<String, AnyObject>)
                                           print(marketDictionary)
                                
                                //print("DEBUG: This is the caption for this section \(market.caption)")
                                           
                                guard let sendCaption = market.caption else { return }
                                guard let sendUrl = market.imageUrl else { return }
                                //let sendPoints = market.points  // may not need point value here, it represent the store and not the post
                                guard let sendStoreId = market.storeId else { return }
                                //guard let creationDate = market.creationDate else { return }
                                guard let sendPrice = market.price else { return }
                                guard let sendPoppPrice = market.poppPrice else { return }
                                guard let sendAddress = market.address else { return }
                                let creationDate = Int(NSDate().timeIntervalSince1970)
                                
                                DataService.instance.REF_CATEGORIES.childByAutoId().updateChildValues(["postId" : postId,
                                                                                                                       "caption" : sendCaption,
                                                                                                                       "imageUrl" : sendUrl,
                                                                                                                       "storeId" : sendStoreId,
                                                                                                                       "creationDate": creationDate,
                                                                                                                       "price": Float(sendPrice),
                                                                                                                       "poppPrice": Float(sendPoppPrice),
                                                                                                                       "address": sendAddress,
                                                                                                                       "category": "Vegetarian"])
                            }
                          }
                          
                          if category.contains("Mexican") {  // will need to make this case insensitive
                              print("Mexican has been found")
                            
                            // now go into the post using the post id and pull the category and store id
                            DataService.instance.REF_ADMIN_STORE_POSTS.child(postId).observeSingleEvent(of: .value) { (snapshot) in
                                
                                guard let marketDictionary = snapshot.value as? [String: Any] else { return }
                                           // may not be the right postId
                                let market = Category(postId: postId, dictionary: marketDictionary as Dictionary<String, AnyObject>)
                                           print(marketDictionary)
                                
                                //print("DEBUG: This is the caption for this section \(market.caption)")
                                           
                                guard let sendCaption = market.caption else { return }
                                guard let sendUrl = market.imageUrl else { return }
                                //let sendPoints = market.points  // may not need point value here, it represent the store and not the post
                                guard let sendStoreId = market.storeId else { return }
                                //guard let creationDate = market.creationDate else { return }
                                guard let sendPrice = market.price else { return }   // may not have to convert because they are ocming from the admin post as ints already
                                guard let sendPoppPrice = market.poppPrice else { return }
                                guard let sendAddress = market.address else { return }
                                let creationDate = Int(NSDate().timeIntervalSince1970)
                                
                                DataService.instance.REF_CATEGORIES.childByAutoId().updateChildValues(["postId" : postId,
                                                                                                                       "caption" : sendCaption,
                                                                                                                       "imageUrl" : sendUrl,
                                                                                                                       "storeId" : sendStoreId,
                                                                                                                       "creationDate": creationDate,
                                                                                                                       "price": Float(sendPrice),
                                                                                                                       "poppPrice": Float(sendPoppPrice),
                                                                                                                       "address": sendAddress,
                                                                                                                       "category": "Mexican"])
                            }
                          }
                        
                        if category.contains("American") {
                            print("American has been found")
                          
                          // now go into the post using the post id and pull the category and store id
                          DataService.instance.REF_ADMIN_STORE_POSTS.child(postId).observeSingleEvent(of: .value) { (snapshot) in
                              
                              guard let marketDictionary = snapshot.value as? [String: Any] else { return }
                                         // may not be the right postId
                              let market = Category(postId: postId, dictionary: marketDictionary as Dictionary<String, AnyObject>)
                                         print(marketDictionary)
                              
                              //print("DEBUG: This is the caption for this section \(market.caption)")
                                         
                              guard let sendCaption = market.caption else { return }
                              guard let sendUrl = market.imageUrl else { return }
                              //let sendPoints = market.points  // may not need point value here, it represent the store and not the post
                              guard let sendStoreId = market.storeId else { return }
                              //guard let creationDate = market.creationDate else { return }
                              guard let sendPrice = market.price else { return }
                              guard let sendPoppPrice = market.poppPrice else { return }
                              guard let sendAddress = market.address else { return }
                              let creationDate = Int(NSDate().timeIntervalSince1970)
                              
                              DataService.instance.REF_CATEGORIES.childByAutoId().updateChildValues(["postId" : postId,
                                                                                                                     "caption" : sendCaption,
                                                                                                                     "imageUrl" : sendUrl,
                                                                                                                     "storeId" : sendStoreId,
                                                                                                                     "creationDate": creationDate,
                                                                                                                     "price": Float(sendPrice),
                                                                                                                     "poppPrice": Float(sendPoppPrice),
                                                                                                                     "address": sendAddress,
                                                                                                                     "category": "All American"])
                          }
                        }
                        
                        if category.contains("Mediterranean") {
                            print("Mediterranean has been found")
                          
                          // now go into the post using the post id and pull the category and store id
                          DataService.instance.REF_ADMIN_STORE_POSTS.child(postId).observeSingleEvent(of: .value) { (snapshot) in
                              
                              guard let marketDictionary = snapshot.value as? [String: Any] else { return }
                                         // may not be the right postId
                              let market = Category(postId: postId, dictionary: marketDictionary as Dictionary<String, AnyObject>)
                                         print(marketDictionary)
                              
                              //print("DEBUG: This is the caption for this section \(market.caption)")
                                         
                              guard let sendCaption = market.caption else { return }
                              guard let sendUrl = market.imageUrl else { return }
                              //let sendPoints = market.points  // may not need point value here, it represent the store and not the post
                              guard let sendStoreId = market.storeId else { return }
                              //guard let creationDate = market.creationDate else { return }
                              guard let sendPrice = market.price else { return }
                              guard let sendPoppPrice = market.poppPrice else { return }
                              guard let sendAddress = market.address else { return }
                              let creationDate = Int(NSDate().timeIntervalSince1970)
                              
                              DataService.instance.REF_CATEGORIES.childByAutoId().updateChildValues(["postId" : postId,
                                                                                                                     "caption" : sendCaption,
                                                                                                                     "imageUrl" : sendUrl,
                                                                                                                     "storeId" : sendStoreId,
                                                                                                                     "creationDate": creationDate,
                                                                                                                     "price": Float(sendPrice),
                                                                                                                     "poppPrice": Float(sendPoppPrice),
                                                                                                                     "address": sendAddress,
                                                                                                                     "category": "Mediterranean"])
                          }
                        }
                        
                        if category.contains("Protein") {
                            print("Protein has been found")
                          
                          // now go into the post using the post id and pull the category and store id
                          DataService.instance.REF_ADMIN_STORE_POSTS.child(postId).observeSingleEvent(of: .value) { (snapshot) in
                              
                              guard let marketDictionary = snapshot.value as? [String: Any] else { return }
                                         // may not be the right postId
                              let market = Category(postId: postId, dictionary: marketDictionary as Dictionary<String, AnyObject>)
                                         print(marketDictionary)
                              
                              //print("DEBUG: This is the caption for this section \(market.caption)")
                                         
                              guard let sendCaption = market.caption else { return }
                              guard let sendUrl = market.imageUrl else { return }
                              //let sendPoints = market.points  // may not need point value here, it represent the store and not the post
                              guard let sendStoreId = market.storeId else { return }
                              //guard let creationDate = market.creationDate else { return }
                              guard let sendPrice = market.price else { return }
                              guard let sendPoppPrice = market.poppPrice else { return }
                              guard let sendAddress = market.address else { return }
                              let creationDate = Int(NSDate().timeIntervalSince1970)
                              
                              DataService.instance.REF_CATEGORIES.childByAutoId().updateChildValues(["postId" : postId,
                                                                                                                     "caption" : sendCaption,
                                                                                                                     "imageUrl" : sendUrl,
                                                                                                                     "storeId" : sendStoreId,
                                                                                                                     "creationDate": creationDate,
                                                                                                                     "price": Float(sendPrice),
                                                                                                                     "poppPrice": Float(sendPoppPrice),
                                                                                                                     "address": sendAddress,
                                                                                                                     "category": "Protein"])
                          }
                        }
                        
                            
                      }
                  })
              }
    }
    
    func updateLocationData() {
        
        // maybe utilize a function here where the user location is added to the store based on the store ID. maybe we can get this distance from the specific store menu
   
   
    }
    
    func updateAdminStorePosts() {
        
        DataService.instance.REF_STORES.observeSingleEvent(of: .value) { (snapshot) in
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.forEach({ (snapshot) in
                guard let storeId = snapshot.key as? String else { return }

                DataService.instance.REF_STORES.child(storeId).observeSingleEvent(of: .value) { (snapshot) in
                    guard let storeDictionary = snapshot.value as? [String: Any] else { return }
                  
                    let store = Store(storeId: storeId, dictionary: storeDictionary as Dictionary<String, AnyObject>)
                    
                    guard let sendAddress = store.location else { return }
                    guard let sendLong = store.long else { return }
                    guard let sendLat = store.lat else { return }
                    guard let sendPoints = store.points else { return }
                    
                    DataService.instance.REF_ADMIN_STORE_POSTS.observeSingleEvent(of: .value) { (snapshot) in
                        guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                        
                        allObjects.forEach({ (snapshot) in
                            guard let key = snapshot.key as? String else { return }
                            
                            // circling through the each key and retrieving the storeId
                            DataService.instance.REF_ADMIN_STORE_POSTS.child(key).child("storeId").observeSingleEvent(of: .value) { (snapshot) in
                            guard let storeIdentifier = snapshot.value as? String else { return }

                                // if any store identifier matches any of the admin posts that have been put in place, then update the below values
                                if storeIdentifier == storeId {
                                    print("THIS IDENTIFIER MATCHES\(storeIdentifier)")
                                    
                                    DataService.instance.REF_ADMIN_STORE_POSTS.child(key).updateChildValues(["lat" : sendLat,
                                    "long" : sendLong,
                                    "address" : sendAddress,
                                    "points" : sendPoints])
                                    
                                }

                            }
                        })
            
                    }
                    // we can also update the store date here when it's time to set up the store specific feed view or menu view
                    
                }
            })
        }
    }
    
    
    func configureAddPhotoButton() {
        
        let backgroundDimension: CGFloat = 50
        addSubview(addPhotoBackgroundButton)
        addPhotoBackgroundButton.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 40, paddingLeft: -25, paddingBottom: 0, paddingRight: 0, width: backgroundDimension, height: backgroundDimension)
        addPhotoBackgroundButton.layer.cornerRadius = backgroundDimension / 2
               
        addPhotoBackgroundButton.addSubview(beBoppAddPhotoButton)
        beBoppAddPhotoButton.anchor(top: addPhotoBackgroundButton.topAnchor, left: addPhotoBackgroundButton.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 43, height: 43)
        
        addSubview(refreshCategories)
        refreshCategories.anchor(top: editProfileFollowButton.topAnchor, left: editProfileFollowButton.rightAnchor, bottom: nil, right: nil, paddingTop: 1, paddingLeft: 2, paddingBottom: 0, paddingRight: 0, width: 70, height: 20)
        refreshCategories.layer.cornerRadius = 2
        
    }
    
    func configureUserAnalytics() {
        
        // this can be users on the analytics page
        
        //let center = self.center
        let center = CGPoint(x: self.center.x, y: self.center.y - 90)
        let circularPath = UIBezierPath(arcCenter: center, radius: 55, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        // create my track layer
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 3
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        
        //layer.addSublayer(trackLayer)
        layer.insertSublayer(trackLayer, below: self.layer)
        
        

        // use the negative CGFloat value to bring start position to 12 o'clock
       // let circularPath = UIBezierPath(arcCenter: center, radius: 30, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        
        layer.insertSublayer(shapeLayer, below: self.layer)
        
        // we can coment this out and just add the handle function to let it animate later
        //addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        //calculateAnalytics()
    }
    
    private func beginDownloadingDistance() {
        print("attempting to download from firebase")
        
        // basically in this function we want to divide the total distance covered by the total distance expected
    }
    
    fileprivate func animateDistanceCircle() {
        
        print("attempting to animate stroke")
        
        // the key path is the thing you want to animate on the shape layer.
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        
        basicAnimation.duration = 1.5
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "basicFit")
        
    }
    /*
    @objc private func handleTap() {

        beginDownloadingDistance()
        
        animateDistanceCircle()
    }
    */
    
    func calculateAnalytics() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.beginDownloadingDistance()
            
            self.animateDistanceCircle()
  
        }
    }
    
    
    func setUserStats(for user: User?) {
        delegate?.setUserStats(for: self)
    }
    
    func setAdminNavigationBar(for user: User?) {
        delegate?.setAdminNavigationBar(for: self)
    }
    
    func configureEditProfileFollowButton() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let user = self.user else { return }

        if currentUid == user.uid {
            
            // Configure button as edit profile
            editProfileFollowButton.setTitle("Edit Profile", for: .normal)
            editProfileFollowButton.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), for: .normal)
            
        } else {
            
            // Configure button as follow button
            editProfileFollowButton.setTitleColor(UIColor.rgb(red: 0, green: 0, blue: 0), for: .normal)
            //editProfileFollowButton.backgroundColor = UIColor.trueBlue()
            editProfileFollowButton.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
            editProfileFollowButton.layer.borderWidth = 0
           
            user.checkIfUserIsFollowed(completion: { (followed) in
                
                if followed {
                    self.editProfileFollowButton.setTitle("Following", for: .normal)
                } else {
                    self.editProfileFollowButton.setTitle("Follow", for: .normal)
                }
            })
        }
    }
    
    // Mark: - Init
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

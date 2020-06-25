//
//  AdminProfileHeader.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 4/17/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

class AdminProfileHeader: UICollectionViewCell {
    
    var delegate: AdminProfileHeaderDelegate?
    
    var user: User? {
        didSet {  // Did set here means we are going to be setting the user for our header in the controller file UserProfileVC.
            
            // Configure edit profile button
            configureEditProfileFollowButton()
            
            // Set user status
            setUserStats(for: user)
            
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
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.borderWidth = 6
        iv.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        iv.image = UIImage(named: "userProfileSilhouetteGray")
        return iv
    } ()
    
    let firstnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        label.textColor = UIColor(red: 71/255, green: 98/255, blue: 112/255, alpha: 1)  //dark blue
        return label
    } ()
    
    let lastnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        label.textColor = UIColor(red: 71/255, green: 98/255, blue: 112/255, alpha: 1)  //dark blue
        return label
    } ()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 16)
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        label.textAlignment = .center
        label.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        return label
    } ()
    
    lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        
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
        label.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        
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
    
    // i would like this label to aventually be able to pinpoint your hometown on apple maps with photos
    let hometownLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
       // label.textColor = UIColor(red: 160/255, green: 218/255, blue: 22/255, alpha: 1)
        label.textColor = UIColor.rgb(red: 26, green: 172, blue: 239)
        label.textAlignment = .center
        label.text = "Huntington, CA"
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
    
    let followersLabelText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
        label.text = "followers"
        return label
    } ()
    
    let followingLabelText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
        label.text = "following"
        return label
    } ()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.backgroundColor = UIColor.rgb(red: 26, green: 172, blue: 239).cgColor
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        button.layer.borderWidth = 2
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
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
        button.addTarget(self, action: #selector(handleFavorited), for: .touchUpInside)
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
        let favoritedTap = UITapGestureRecognizer(target: self, action: #selector(handleFavorited))
        favoritedTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(favoritedTap)
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
        button.addTarget(self, action: #selector(handleModifyPoints), for: .touchUpInside)
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
        let searchFriendsTap = UITapGestureRecognizer(target: self, action: #selector(handleModifyPoints))
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
        button.addTarget(self, action: #selector(handleStoreAccount), for: .touchUpInside)
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
        let searchGroupsTap = UITapGestureRecognizer(target: self, action: #selector(handleStoreAccount))
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
    
    let separatorViewPost: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1).cgColor
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
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1)
        label.text = "This is an admin profile. Admin users will have the ability to adjust points, check analytics, and view favorites."
        return label
    } ()
    
    
    let postsSeparator: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        label.text = "My Posts"
        return label
    }()
    
    let gridViewButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        //button.addTarget(self, action: #selector(handleCenterMapBtnPressed), for: .touchUpInside)
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
        button.layer.shadowRadius = 5.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.alpha = 1
        return button
       }()
    
    
    
    override init(frame: CGRect) {
    
        super.init(frame: frame)
       
        configureViewComponents()
        configureUserStats()
    }
    
    
    
    
    
    // MARK: - Handlers (We want to delegate these actions to the controller).
    
    @objc func handleFollowersTapped() {
        //delegate?.handleFollowersTapped(for:self)
    }
    
    @objc func handleFollowingTapped() {
       // delegate?.handleFollowingTapped(for:self)
    }
    
    @objc func handlePostTapped() {
        //delegate?.handlePostTapped(for:self)
    }
    
    @objc func handleEditProfileFollow() {
        //delegate?.handleEditFollowTapped(for:self)
        
        print("print handle edit profile tapped")
    }
    
    @objc func handleAddPhotoTapped() {
        delegate?.handleAddPhotoTapped(for:self)
    }
    
    @objc func handleFavorited() {
       // delegate?.handleFavoritedTapped(for:self)
        
         print("print handle favorite tapped")
    }
    
    @objc func handleAnalytics() {
        //delegate?.handleAnalyticsTapped(for: self)
        
         print("print handle analytics tapped")
    }
    
    @objc func handleStoreAccount() {
        //delegate?.handleStoreAccountTapped(for: self)
        
         print("print handle store account tapped")
    }
    
    @objc func handleModifyPoints() {
        //delegate?.handleModifyPointsTapped(for: self)
        
         print("print handle modify points tapped")
    }
    
    
    // MARK: - Helper Functions

    func configureViewComponents() {
        
        let profileDimension: CGFloat = 100
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: profileDimension, height: profileDimension)
        profileImageView.layer.cornerRadius = profileDimension / 2
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        addSubview(hometownLabel)
        hometownLabel.anchor(top: usernameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        hometownLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [followersLabel, followingLabel, postLabel])
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.anchor(top: hometownLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        stackView.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: stackView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 105, height: 40)
        editProfileFollowButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        editProfileFollowButton.layer.cornerRadius = 20

        addSubview(gridViewButton)
        gridViewButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 290, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
        gridViewButton.tintColor = UIColor(red: 26/255, green: 172/255, blue: 239/255, alpha: 1)
        
        let backgroundDimension: CGFloat = 60
        addSubview(addPhotoBackgroundButton)
        addPhotoBackgroundButton.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 40, paddingLeft: -20, paddingBottom: 0, paddingRight: 0, width: backgroundDimension, height: backgroundDimension)
        addPhotoBackgroundButton.layer.cornerRadius = backgroundDimension / 2
               
        addPhotoBackgroundButton.addSubview(beBoppAddPhotoButton)
        beBoppAddPhotoButton.anchor(top: addPhotoBackgroundButton.topAnchor, left: addPhotoBackgroundButton.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 7, paddingBottom: 0, paddingRight: 0, width: 45, height: 45)
               
        
        
        /*
        let profileDimension: CGFloat = 100
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: profileDimension, height: profileDimension)
        profileImageView.layer.cornerRadius = profileDimension / 2
        
        addSubview(firstnameLabel)
        firstnameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(lastnameLabel)
        lastnameLabel.anchor(top: profileImageView.topAnchor, left: firstnameLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: firstnameLabel.bottomAnchor, left: firstnameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(hometownLabel)
        hometownLabel.anchor(top: usernameLabel.bottomAnchor, left: firstnameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(aboutSeparator)
        aboutSeparator.anchor(top: profileImageView.bottomAnchor, left: profileImageView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(aboutSectionBlock)
        aboutSectionBlock.anchor(top: aboutSeparator.bottomAnchor, left: aboutSeparator.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        aboutSectionBlock.translatesAutoresizingMaskIntoConstraints = false
        
        aboutSectionBlock.addSubview(aboutLabel)
        aboutLabel.anchor(top: aboutSectionBlock.topAnchor, left: aboutSectionBlock.leftAnchor, bottom: aboutSectionBlock.bottomAnchor, right: aboutSectionBlock.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 2, paddingRight: 0, width: 0, height: 0)
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(followersLabel)
        followersLabel.anchor(top: hometownLabel.bottomAnchor, left: firstnameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        followersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(followersLabelText)
        followersLabelText.anchor(top: hometownLabel.bottomAnchor, left: followersLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        followersLabelText.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(followingLabel)
        followingLabel.anchor(top: hometownLabel.bottomAnchor, left: followersLabelText.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        followingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(followingLabelText)
        followingLabelText.anchor(top: hometownLabel.bottomAnchor, left: followingLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        followingLabelText.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 25, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 95, height: 33)
        
        
        // profile header buttons
        
        let buttonDimension: CGFloat = 55
        let containerWidth: CGFloat = 175
        
        addSubview(separatorView)
        separatorView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 105, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
        
        
        // analytics button
        
        addSubview(analyticsButtonContainer)
        analyticsButtonContainer.anchor(top: separatorView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: containerWidth, height: buttonDimension)
        
        analyticsButtonContainer.addSubview(analyticsButton)
        analyticsButton.anchor(top: nil, left: analyticsButtonContainer.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: buttonDimension, height: buttonDimension)
        analyticsButton.centerYAnchor.constraint(equalTo: analyticsButtonContainer.centerYAnchor).isActive = true
        
        analyticsButtonContainer.addSubview(analyticsLabel)
        analyticsLabel.anchor(top: nil, left: analyticsButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        analyticsLabel.centerYAnchor.constraint(equalTo: analyticsButton.centerYAnchor).isActive = true
        
        
        // favorites button
        
        addSubview(favoritesButtonContainer)
        favoritesButtonContainer.anchor(top: separatorView.bottomAnchor, left: analyticsButtonContainer.rightAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: containerWidth, height: buttonDimension)
        
        favoritesButtonContainer.addSubview(favoriteItemsButton)
        favoriteItemsButton.anchor(top: nil, left: favoritesButtonContainer.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: buttonDimension, height: buttonDimension)
        favoriteItemsButton.centerYAnchor.constraint(equalTo: favoritesButtonContainer.centerYAnchor).isActive = true
        
        favoritesButtonContainer.addSubview(favoriteItemsLabel)
        favoriteItemsLabel.anchor(top: nil, left: favoriteItemsButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        favoriteItemsLabel.centerYAnchor.constraint(equalTo: favoriteItemsButton.centerYAnchor).isActive = true
        
        
        
        // search friends button
        
        addSubview(searchFriendsButtonContainer)
        searchFriendsButtonContainer.anchor(top: analyticsButtonContainer.bottomAnchor, left: analyticsButtonContainer.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: containerWidth, height: buttonDimension)
        
        searchFriendsButtonContainer.addSubview(searchFriendsButton)
        searchFriendsButton.anchor(top: nil, left: searchFriendsButtonContainer.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: buttonDimension, height: buttonDimension)
        searchFriendsButton.centerYAnchor.constraint(equalTo: searchFriendsButtonContainer.centerYAnchor).isActive = true
        
        searchFriendsButtonContainer.addSubview(searchFriendsLabel)
        searchFriendsLabel.anchor(top: nil, left: searchFriendsButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        searchFriendsLabel.centerYAnchor.constraint(equalTo: searchFriendsButton.centerYAnchor).isActive = true
        
        
        
        // search groups button
        
        addSubview(searchGroupsButtonContainer)
        searchGroupsButtonContainer.anchor(top: favoritesButtonContainer.bottomAnchor, left: favoritesButtonContainer.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: containerWidth, height: buttonDimension)
        
        searchGroupsButtonContainer.addSubview(searchGroupsButton)
        searchGroupsButton.anchor(top: nil, left: searchGroupsButtonContainer.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: buttonDimension, height: buttonDimension)
        searchGroupsButton.centerYAnchor.constraint(equalTo: searchGroupsButtonContainer.centerYAnchor).isActive = true
        
        searchGroupsButtonContainer.addSubview(searchGroupsLabel)
        searchGroupsLabel.anchor(top: nil, left: favoriteItemsButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        searchGroupsLabel.centerYAnchor.constraint(equalTo: searchGroupsButton.centerYAnchor).isActive = true
        
        
        /*
        addSubview(separatorViewPost)
        separatorViewPost.anchor(top: searchGroupsButtonContainer.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 25, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
        
        addSubview(postsSeparator)
        postsSeparator.anchor(top: separatorViewPost.bottomAnchor, left: aboutSeparator.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(postLabel)
        postLabel.anchor(top: separatorViewPost.bottomAnchor, left: nil, bottom: nil, right: editProfileFollowButton.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        */
        
        
        /*
        let stackView = UIStackView(arrangedSubviews: [firstnameLabel, lastnameLabel])
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        stackView.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
         */
 
 
 */
    }
    
    func configureUserStats() {
        
        // possible user stats here
    }
    
    func setUserStats(for user: User?) {
           delegate?.setUserStats(for: self)
    
    }
       
    func configureEditProfileFollowButton() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let user = self.user else { return }
        
        if currentUid == user.uid {
            
            // Configure button as edit profile
            editProfileFollowButton.setTitle("Edit", for: .normal)
            editProfileFollowButton.setTitleColor( UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), for: .normal)
            
        } else {
            
            // Configure button as follow button
            editProfileFollowButton.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), for: .normal)
            editProfileFollowButton.backgroundColor = UIColor(red: 163/255, green: 219/255, blue: 34/255, alpha: 1)
            
            user.checkIfUserIsFollowed(completion: { (followed) in
                
                if followed {
                    self.editProfileFollowButton.setTitle("Following", for: .normal)
                } else {
                    self.editProfileFollowButton.setTitle("Follow", for: .normal)
                }
            })
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

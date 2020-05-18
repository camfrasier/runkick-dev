//
//  LeftSidePanelVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/6/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//
import UIKit
import Firebase

class LeftSidePanelVC: UIViewController {
    
    // MARK: - Properties
    
    var user: User?
    var homeVC: HomeVC?
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "userProfileIcon")
        return iv
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let viewProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleEditUserProfile), for: .touchUpInside)
        return button
    }()
    
    let userAccountTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let userLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleUserLogin), for: .touchUpInside)
        return button
    }()
    
    let completeProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleCompleteProfile), for: .touchUpInside)
        return button
    }()
    
    let profileCompleteIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.borderColor = UIColor(red: 220/355, green: 40/255, blue: 40/255, alpha: 1).cgColor
        return view
    }()
    
    let paymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Payment", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleUserPayment), for: .touchUpInside)
        return button
    }()
    
    let walletButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Wallet", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleUserWallet), for: .touchUpInside)
        return button
    }()
    
    let tripHistory: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Trip History", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleUserTrips), for: .touchUpInside)
        return button
    }()
    
    let helpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Help", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleUserHelp), for: .touchUpInside)
        return button
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Settings", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleUserSettings), for: .touchUpInside)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "User"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // the below is from lesson 13 of udemy (modified for waywalk)
    }
    
    // We want these updates as soon as the screen appears so we need it to call it in something in viewWillApper. This allow us to make it hidden before the screen loads.
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .white
        
        //observeUsernameStatus()
        
        fetchCurrentUserData()
        
        if Auth.auth().currentUser == nil {
            userAccountTypeLabel.text = ""
            viewProfileButton.isHidden = true
            profileCompleteIndicator.isHidden = true
            completeProfileButton.isHidden = true
            userLoginButton.setTitle("Sign Up / Login", for: .normal)
            
        } else {

            userAccountTypeLabel.text = ""
            viewProfileButton.isHidden = false
            userLoginButton.isHidden = true
        }
        
        observeUserandAdmins()
        
        configureUserProfile()
        
        configureUserProfileStatus()
        
        configurUserMenu()
    }
    
    
    func observeUserandAdmins() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USERS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            
            if user.isAdmin == false {
                print("user is not an admin")
                self.userAccountTypeLabel.text = "Waywalker"
                
            } else {
                print("user is an admin")
                self.userAccountTypeLabel.text = "Administrator"
            }
        }
    }
    
    func observeUsernameStatus() {
        
        if Auth.auth().currentUser != nil {
            
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            
            print("DEBUG: The current user id is \(currentUid)")
            DataService.instance.REF_USERS.child(currentUid).child("profileCompleted").observe(.value) { (snapshot) in
                let isProfileComplete = snapshot.value as! Bool
                
                print(snapshot.value as! Bool)
                
                if isProfileComplete == false {
                    self.viewProfileButton.isHidden = true
                    self.completeProfileButton.isHidden = false
                    self.profileCompleteIndicator.isHidden = false
                    self.completeProfileButton.setTitle("Complete Sign In?", for: .normal)
                    self.userLoginButton.isHidden = true
                    print("user profile is NOT complete")
                    
                } else {
                    self.viewProfileButton.isHidden = false
                    self.completeProfileButton.isHidden = true
                    self.profileCompleteIndicator.isHidden = true
                    self.userLoginButton.isHidden = true
                    print("user profile is complete")
                }
            }
            
        } else {
            
            usernameLabel.isHidden = true
            userLoginButton.isHidden = false
            userLoginButton.setTitle("Sign Up / Login", for: .normal)
            viewProfileButton.isHidden = true
            completeProfileButton.isHidden = true
            profileCompleteIndicator.isHidden = true
            profileImageView.image = UIImage(named: "userProfileIcon")
        }
    }
    
    func configurUserMenu() {
        
        let stackView = UIStackView(arrangedSubviews: [paymentButton, walletButton, tripHistory, helpButton, settingsButton])
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 130, paddingLeft: 120, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func configureUserProfile() {
        
        view.addSubview(profileImageView)
        let dimension: CGFloat = 70
        profileImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 35, paddingBottom: 0, paddingRight: 0, width: dimension, height: dimension)
        profileImageView.layer.cornerRadius = dimension / 2
        
        view.addSubview(viewProfileButton)
        viewProfileButton.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 34, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(separatorView)
        separatorView.anchor(top: viewProfileButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    func configureUserProfileStatus() {
        
        view.addSubview(userLoginButton)
        userLoginButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 120, paddingBottom: 350, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(completeProfileButton)
        completeProfileButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 120, paddingBottom: 156, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(profileCompleteIndicator)
        profileCompleteIndicator.anchor(top: nil, left: completeProfileButton.rightAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 166, paddingRight: 0, width: 10, height: 10)
        profileCompleteIndicator.layer.cornerRadius = 10/2
        
        view.addSubview(userAccountTypeLabel)
        userAccountTypeLabel.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 120, paddingBottom: 178, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(usernameLabel)
        usernameLabel.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 120, paddingBottom: 200, paddingRight: 0, width: 0, height: 0)
    }
    
    func fetchCurrentUserData() {
        
        // Set the user in header.
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USERS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            
            guard let profileImageUrl = user.profileImageURL else { return }
            self.profileImageView.loadImage(with: profileImageUrl)
        
            guard let username = user.username else { return }
            
            self.usernameLabel.text = username
        }
    }
    
    // MARK: - Handlers
    
    @objc func handleUserPayment() {
        print("handle user payments")
    }
    
    @objc func handleUserWallet() {
        print("handle user wallet")
    }
    
    @objc func handleUserTrips() {
        print("handle user trips")
    }
    
    @objc func handleUserHelp() {
        print("handle user help")
    }
    
    @objc func handleUserSettings() {
        
        let settingsVC = SettingsVC()
        present(settingsVC, animated: true, completion:nil)
    }
    
    @objc func handleUserAccountLabel() {
        print("handle user handle User accounts label")
    }
    
    @objc func handleCompleteProfile() {
        
        print("complete user sign up here")
    }
    @objc func handleUserLogin() {
        
        if Auth.auth().currentUser == nil {
            
            let loginVC = LoginVC()
            present(loginVC, animated: true, completion:nil)
            
        } else {
    
            print("DEBUG: There is a user alogin error.")
        }
    }
    
    @objc func handleEditUserProfile() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USERS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            
            if user.isAdmin == false {
                
                print("this user is an NOT admin")

                let editProfileController = EditProfileController()
                editProfileController.user = user
                            
                let navigationController = UINavigationController(rootViewController: editProfileController)
                self.present(navigationController, animated: true, completion: nil)
                            
                } else {
                
                print("user is an admin")
                            
                let editAdminProfileController = EditAdminProfileController()
                editAdminProfileController.user = user
                            
                let navigationController = UINavigationController(rootViewController: editAdminProfileController)
                self.present(navigationController, animated: true, completion: nil)
            }
        }
    }
}





//
//  MenuVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 12/4/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "MenuOptionCell"

class MenuVC: UIViewController {
    // MARK: - Properties
    
    var tableView: UITableView!
    var delegate: HomeControllerDelegate?
    //var storeAdminStatus: Bool?
    
    let menuSubView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return view
    }()
    
    let titleView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(red: 188/255, green: 208/255, blue: 214/255, alpha: 1)
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        return view
    }()
    
    let greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "Hi"
        label.textColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
        //label.textColor = UIColor(red: 26/255, green: 172/255, blue: 239/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "User"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    let firstnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Poppstar"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1)
        //label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    let userAccountTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)  //dark blue
        label.textAlignment = .center
        return label
    }()
    
    lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 0.25
        iv.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        iv.image = UIImage(named: "userProfileSilhouetteWhite")
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(handleViewProfile))
        profileTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(profileTap)
        return iv
    }()
    
    /*
    let viewProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View Profile", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleViewProfile), for: .touchUpInside)
        return button
    }()
    */
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 148/255, green: 168/255, blue: 174/255, alpha: 1)
        return view
    }()
    
    lazy var sleepButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "simpleCirclePowerButton"), for: .normal)
        button.addTarget(self, action: #selector(handleSleep), for: .touchUpInside)
        button.backgroundColor = .clear
        button.alpha = 1
        return button
    }()
    
    let ghostModeLabel: UILabel = {
        let label = UILabel()
        label.text = "Ghost"  //Visible to Ghosting
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor(red: 122/255, green: 206/255, blue: 53/255, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    let checkInLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        let attributedText = NSMutableAttributedString(string: "108\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "check-ins", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)]))
        label.attributedText = attributedText
        return label
    } ()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        let attributedText = NSMutableAttributedString(string: "36\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "miles", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)]))
        label.attributedText = attributedText
        return label
    } ()
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        let attributedText = NSMutableAttributedString(string: "22.5K\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "points", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)]))
        label.attributedText = attributedText
        return label
    } ()
    
    let avatarBackgroundButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setImage(UIImage(named: "trueBlueCirclePlus"), for: .normal)
        button.addTarget(self, action: #selector(handleViewProfile), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 181/255, green: 201/255, blue: 215/255, alpha: 1)
        button.layer.cornerRadius = 50 / 2
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.alpha = 1
        return button
    }()
    
    let beBoppAvatarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "beBoppGlassesRed"), for: .normal)
        button.addTarget(self, action: #selector(handleViewProfile), for: .touchUpInside)
        button.backgroundColor = .clear
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.alpha = 1
        return button
       }()
    

    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = UIColor(red: 188/255, green: 212/255, blue: 214/255, alpha: 1)
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        fetchCurrentUserData()
        
        configureTableView()
        
        observeUserandAdmins()
        
        configureViewComponents()
        
        // adjust the corner radius of the slide menu view
        let myControlLayer: CALayer = self.view.layer
        myControlLayer.masksToBounds = true
        myControlLayer.cornerRadius = 0
    }
    
    // MARK: - Handlers
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = UIColor.rgb(red: 181, green: 201, blue: 215)
        //tableView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        // disables the scrolling feature for the table view
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        tableView.rowHeight = 60

        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        view.addSubview(menuSubView)
        menuSubView.translatesAutoresizingMaskIntoConstraints = false
        menuSubView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 170, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        menuSubView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: menuSubView.topAnchor, left: menuSubView.leftAnchor, bottom: menuSubView.bottomAnchor, right: menuSubView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc func handleViewProfile() {
        print("Profile picture pressed")
        //delegate?.handleProfileToggle(shouldDismiss: true)
    }
    
    @objc func handleSleep() {
        print("sleep will be toggled here")
    }

    
    func configureViewComponents() {
        
        view.addSubview(titleView)
        titleView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 170)

        //titleView.layer.shadowColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 0.50).cgColor
        //titleView.layer.shadowOffset = CGSize(width: 0, height: 2)
        //titleView.layer.shadowRadius = 3.0
        //titleView.layer.shadowOpacity = 0.80
        
        titleView.addSubview(separatorView)
        separatorView.anchor(top: nil, left: titleView.leftAnchor, bottom: titleView.bottomAnchor, right: titleView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
    
        let profileDimension: CGFloat = 65
        titleView.addSubview(profileImageView)
        profileImageView.anchor(top: titleView.topAnchor, left: titleView.leftAnchor, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 180, paddingBottom: 0, paddingRight: 0, width: profileDimension, height: profileDimension)
        profileImageView.layer.cornerRadius = profileDimension / 2
        
        titleView.addSubview(greetingLabel)
        greetingLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        titleView.addSubview(firstnameLabel)
        firstnameLabel.anchor(top: greetingLabel.topAnchor, left: greetingLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let avatarDimension: CGFloat = 45
        titleView.addSubview(avatarBackgroundButton)
        avatarBackgroundButton.anchor(top: profileImageView.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: -30, paddingLeft: -20, paddingBottom: 0, paddingRight: 0, width: avatarDimension, height: avatarDimension)
        
        avatarBackgroundButton.addSubview(beBoppAvatarButton)
        beBoppAvatarButton.anchor(top: avatarBackgroundButton.topAnchor, left: avatarBackgroundButton.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 2, paddingBottom: 0, paddingRight: 0, width: 43, height: 43)
        
        /*
        titleView.addSubview(sleepButton)
        sleepButton.anchor(top: profileImageView.topAnchor, left: nil, bottom: nil, right: titleView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 25, width: 30, height: 30)
        
        titleView.addSubview(ghostModeLabel)
        ghostModeLabel.anchor(top: sleepButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        ghostModeLabel.centerXAnchor.constraint(equalTo: sleepButton.centerXAnchor).isActive = true
        */
        
        /*
        titleView.addSubview(viewProfileButton)
        viewProfileButton.anchor(top: greetingLabel.bottomAnchor, left: greetingLabel.leftAnchor, bottom: nil, right: nil, paddingTop: -6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        */
        
        titleView.addSubview(userAccountTypeLabel)
        userAccountTypeLabel.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        userAccountTypeLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [checkInLabel, distanceLabel, pointsLabel])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        
        
        //titleView.addSubview(stackView)
        //stackView.anchor(top: nil, left: profileImageView.leftAnchor, bottom: titleView.bottomAnchor, right: titleView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 25, width: 0, height: 0)
        
        /*
        titleView.addSubview(checkInLabel)
        checkInLabel.anchor(top: greetingLabel.bottomAnchor, left: titleView.leftAnchor, bottom: nil, right: nil, paddingTop: 55, paddingLeft: 170, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        titleView.addSubview(distanceLabel)
        distanceLabel.anchor(top: greetingLabel.bottomAnchor, left: checkInLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 55, paddingLeft: 35, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        titleView.addSubview(pointsLabel)
        pointsLabel.anchor(top: greetingLabel.bottomAnchor, left: distanceLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 55, paddingLeft: 35, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        */
        
        /*
        titleView.addSubview(profileImageView)
          let dimension: CGFloat = 75
        
        profileImageView.anchor(top: titleView.topAnchor, left: titleView.leftAnchor, bottom: nil, right: nil, paddingTop: 45, paddingLeft: 250, paddingBottom: 0, paddingRight: 0, width: dimension, height: dimension)
        profileImageView.layer.cornerRadius = dimension / 2
        profileImageView.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        profileImageView.layer.borderWidth = 5
        
        let stackView = UIStackView(arrangedSubviews: [greetingLabel, firstnameLabel])
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(stackView)
        stackView.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        stackView.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        */
        

        //tableView.addSubview(separatorView)
        //separatorView.anchor(top: menuTitleView.bottomAnchor, left: menuTitleView.leftAnchor, bottom: nil, right: menuTitleView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)

        
    }
    
    func observeUserandAdmins() {
        
        if Auth.auth().currentUser != nil {
            
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            
            print("DEBUG: The current user id is \(currentUid)")
            DataService.instance.REF_USERS.child(currentUid).child("isStoreadmin").observe(.value) { (snapshot) in
                let isStoreadmin = snapshot.value as! Bool
                
                print(snapshot.value as! Bool)
                
                if isStoreadmin == true {    // this is the profile screen for users
                    
                        print("This user has an admin profile")
                        self.userAccountTypeLabel.text = "Admin"
                    // do something
                    
                    
                } else {
                    
                    // do something else
                    print("This user is NOT a store admin")
                    self.userAccountTypeLabel.text = ""
                    
    
                }
            }
        }
        
        
        /*
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USERS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            
            if user.isAdmin == false {
                print("user is not an admin")
                self.userAccountTypeLabel.text = "User Account"
                
            } else {
                print("user is an admin")
                self.userAccountTypeLabel.text = "Admin Account"
            }
        }
        */
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
            guard let firstname = user.firstname else { return }
            
            self.usernameLabel.text = username
            self.firstnameLabel.text = firstname
        }
    }
}


extension MenuVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuOptionCell
        
        // the below will allow us to bring back a value based on the option pressed
        let menuOption = MenuOption(rawValue: indexPath.row)
        cell.descriptionLabel.text = menuOption?.description
        cell.iconImageView.image = menuOption?.image
        cell.iconImageView2.image = menuOption?.image2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = MenuOption(rawValue: indexPath.row)
        //let homeVC = HomeVC()
 
        //homeVC.handleMenuToggle(menuOption: menuOption!)
        delegate?.handleMenuToggle(shouldDismiss: true, menuOption: menuOption!)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//
//  RightMenuVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 4/18/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "RightMenuOptionCell"

class RightMenuVC: UIViewController {
    
    var activities = [Activity]()
    var activity: Activity?
    var currentKey: String?
    
    var tableView: UITableView!
    var delegate: HomeControllerDelegate?
     

    let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return view
    }()
    
    let menuSubView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 181, green: 201, blue: 215)

        return view
    }()
    
    let tableSuperView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        //view.backgroundColor = UIColor.rgb(red: 255, green: 200, blue: 200)
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        return view
    }()
    
    let activityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26)
        label.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        label.text = "Recent Activity"
        return label
    } ()
    
    /*
    lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 122, green: 206, blue: 33)

        /*
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        //attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        */
        
        // add gesture recognizer
        //let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        followTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        
        return label
    } ()
    
    lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 122, green: 206, blue: 33)
        
        /*
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        //attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        */
        
        // add gesture recognizer
        //let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        followTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    } ()
    
    lazy var postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 122, green: 206, blue: 33)
        
        //let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        //attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)]))
        //label.attributedText = attributedText
        
        //let postTap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        postTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(postTap)
        return label
    } ()
    */
    
    let avatarBackgroundButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setImage(UIImage(named: "trueBlueCirclePlus"), for: .normal)
        //button.addTarget(self, action: #selector(handleAnalyticsTapped), for: .touchUpInside)
        button.backgroundColor = UIColor.rgb(red: 122, green: 206, blue: 53)
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
        button.setImage(UIImage(named: "beBoppIconHeadBand"), for: .normal)
        //button.addTarget(self, action: #selector(handleAnalyticsTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.alpha = 1
        return button
       }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        fetchActivityPosts()
        
        //fetchCurrentUserData()
        
        //setUserStats()
        
        configureTableView()
        
        //configureViewComponents()

        // adjust the corner radius of the slide menu view
        let myControlLayer: CALayer = self.view.layer
        myControlLayer.masksToBounds = true
        myControlLayer.cornerRadius = 15
        
        // configure refresh control
        let refreshFeedControl = UIRefreshControl()
        refreshFeedControl.addTarget(self, action: #selector(handleFeedRefresh), for: .valueChanged)
        tableView?.refreshControl = refreshFeedControl
    }
    
    
    func fetchActivityPosts() {
        
        print("fetch activity function called")
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        // fetching posts with pagination and only observing x amount of post at a time
        
        if currentKey == nil {
            DataService.instance.REF_ACTIVITY.child(currentUid).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.tableView?.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let tripId = snapshot.key
                    self.fetchActivity(withTripId: tripId)
                    print("DEBUG: SNAPSHOT \(snapshot)")
                    })
                self.currentKey = first.key
            
        })
        }else {
            DataService.instance.REF_ACTIVITY.child(currentUid).queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 6).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let tripId = snapshot.key
                    if tripId != self.currentKey {
                        self.fetchActivity(withTripId: tripId)
                    }
                })
                self.currentKey = first.key
                })
        }
    }
    
    func fetchActivity(withTripId tripId: String) {
          
        Database.fetchActivity(with: tripId) { (post) in
            
            self.activities.append(post)
            
            self.activities.sort(by: { (activity1, activity2) -> Bool in
                return activity1.creationDate > activity2.creationDate
            })
            self.tableView?.reloadData()
        }
    }
    
    @objc func handleFeedRefresh() {
        // this is a screen pull down function to refresh you feed
        activities.removeAll(keepingCapacity: false)
        self.currentKey = nil
        fetchActivityPosts()
        
        tableView?.reloadData()
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        // register right menu table view
        tableView.register(RightMenuOptionCell.self, forCellReuseIdentifier: reuseIdentifier)
        //tableView.backgroundColor = UIColor(red: 181/255, green: 201/255, blue: 215/255, alpha: 1)
        tableView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
        tableView.rowHeight = 85
        
        // disables the scrolling feature for the table view
        tableView.isScrollEnabled = true

        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
  
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(activityLabel)
        activityLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        /*
        //view.addSubview(tableSuperView)
        tableView.addSubview(tableSuperView)
        
        tableSuperView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 407, paddingLeft: 0, paddingBottom: 0, paddingRight: 340, width: 0, height: 0)
        
        tableSuperView.addSubview(postLabel)
        postLabel.anchor(top: tableSuperView.topAnchor, left: nil, bottom: nil, right: tableSuperView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)
        
        tableSuperView.addSubview(followersLabel)
        followersLabel.anchor(top: postLabel.topAnchor, left: postLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 55, paddingLeft: 0, paddingBottom: 0, paddingRight: 2, width: 0, height: 0)
        
        tableSuperView.addSubview(followingLabel)
        followingLabel.anchor(top: followersLabel.topAnchor, left: followersLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 55, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        */
        
    }
    
    /*
    
    func fetchCurrentUserData() {
        
        // Set the user in header.
        // May need this later for pulling user running values
    
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USERS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            
            guard let profileImageUrl = user.profileImageURL else { return }
            //self.profileImageView.loadImage(with: profileImageUrl)
        
            guard let username = user.username else { return }
            guard let firstname = user.firstname else { return }
            
            //self.usernameLabel.text = username
            //self.firstnameLabel.text = firstname
        }
    }
    
    func setUserStats() {

        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var numberOfFollwers: Int!
        var numberOfFollowing: Int!
        var numberOfPosts: Int!
        
        // get number of followers
        DataService.instance.REF_FOLLOWER.child(uid).observe(.value) { (snapshot) in // Observe doesn't just do it one time. It updates in REALTIME in Firebase.
            
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                numberOfFollwers = snapshot.count
            } else {
                numberOfFollwers = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollwers!)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
            //attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)]))
            
            self.followersLabel.attributedText = attributedText
        }
        
        // get number of following
        DataService.instance.REF_FOLLOWING.child(uid).observe(.value) { (snapshot) in
            
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                numberOfFollowing = snapshot.count
            } else {
                numberOfFollowing = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollowing!)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
            //attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)]))
            
            self.followingLabel.attributedText = attributedText
        }
        
        // get number of posts
        DataService.instance.REF_USER_POSTS.child(uid).observe(.value) { (snapshot) in
            
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                numberOfPosts = snapshot.count
            } else {
                numberOfPosts = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfPosts!)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 19)])
            //attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)]))
            
            self.postLabel.attributedText = attributedText
        }
    }
    
    func configureViewComponents() {
           
           view.addSubview(titleView)
           titleView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60)

           //titleView.layer.shadowColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 0.50).cgColor
           //titleView.layer.shadowOffset = CGSize(width: 0, height: 2)
           //titleView.layer.shadowRadius = 3.0
           //titleView.layer.shadowOpacity = 0.80
           
           titleView.addSubview(separatorView)
           separatorView.anchor(top: nil, left: titleView.leftAnchor, bottom: titleView.bottomAnchor, right: titleView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
           
        /*
        let backgroundDimension: CGFloat = 60
        titleView.addSubview(avatarBackgroundButton)
        avatarBackgroundButton.anchor(top: titleView.topAnchor, left: titleView.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: backgroundDimension, height: backgroundDimension)
        avatarBackgroundButton.layer.cornerRadius = backgroundDimension / 2
        */
        
        //avatarBackgroundButton.addSubview(beBoppAvatarButton)
        //beBoppAvatarButton.anchor(top: avatarBackgroundButton.topAnchor, left: avatarBackgroundButton.leftAnchor, bottom: nil, right: nil, paddingTop: 7, paddingLeft: 5.5, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        
        //tableView.addSubview(tableSuperView)
        //tableSuperView.anchor(top: tableView.topAnchor, left: nil, bottom: nil, right: tableView.rightAnchor, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 100, width: 50, height: 50)

        
        /*
           let stackView = UIStackView(arrangedSubviews: [followersLabel, followingLabel, postLabel])
           stackView.axis = .horizontal
           stackView.distribution = .equalSpacing
           stackView.alignment = .center
           titleView.addSubview(stackView)
        stackView.anchor(top: avatarBackgroundButton.topAnchor, left: avatarBackgroundButton.rightAnchor, bottom: nil, right: titleView.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        */
       }
    
    // MARK: - Handlers (We want to delegate these actions to the controller).
    
    @objc func handleFollowersTapped() {
        print("handle followers tapped")
    }
    
    @objc func handleFollowingTapped() {
        print("handle following tapped")
    }
    
    @objc func handlePostTapped() {
        print("handle posts tapped")
    }
    
    @objc func handleAnalyticsTapped() {
        print("handle analytics tapped")
    }
 */
}

    
extension RightMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
        activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RightMenuOptionCell
        
        //cell.delegate = self
        cell.activity = activities[indexPath.row]
          
   
        /*
        // the below will allow us to bring back a value based on the option pressed
        let rightMenuOption = RightMenuOption(rawValue: indexPath.row)
        cell.descriptionLabel.text = rightMenuOption?.description
        cell.iconImageView.image = rightMenuOption?.image
        cell.iconImageView2.image = rightMenuOption?.image2
        */
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let rightMenuOption = RightMenuOption(rawValue: indexPath.row)
        //delegate?.handleRightMenuToggle(shouldDismiss: true, rightMenuOption: rightMenuOption)
        
        print("THIS IS SELECTED")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if activities.count > 4 {
            if indexPath.item == activities.count - 1 {
                fetchActivityPosts()
            }
        }
    }

}

//
//  UserProfileVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/15/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private let headerIdentifier = "UserProfileHeader"

class UserProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
    
    
    // Mark: - Properties
    
    // here we are using the class photo feed view in order to pull up the photo we need from the subclass PhotoProfileView
    let photoProfileView: PhotoProfileView = {
        let view = PhotoProfileView()
        //view.layer.cornerRadius = 5
        return view
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    let exitProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Exit Profile", for: .normal)
        button.setTitleColor(.init(red: 17/255, green: 140/255, blue: 237/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleExitProfile), for: .touchUpInside)
        return button
    } ()

    var homeVC: HomeVC?
    var user: User?  // Set as an optional because it won't have a value initially.
    var posts = [Post]()
    // current key variable used to support pagination of the user profile
    var currentKey: String?
    let customSearchFriendsButton = UIButton(type: UIButton.ButtonType.custom)
    //let customSearchFriendsIconButton = UIButton(type: UIButton.ButtonType.custom)
    
    lazy var photoUploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Upload Photo", for: .normal)
        button.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), for: .normal)
        button.backgroundColor = UIColor(red: 250/255, green: 150/255, blue: 90/255, alpha: 1)
        button.addTarget(self, action: #selector(handlePhotoButton), for: .touchUpInside)
        button.layer.shadowOpacity = 90 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.35).cgColor
        button.layer.shadowRadius = 1.0
        button.layer.shadowOffset = CGSize(width: -1, height: 2)
        button.layer.cornerRadius = 25
        return button
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //extends the edges beyound the tab bar
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true
        
        
        
        self.collectionView!.register(UserPostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        self.collectionView?.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 235)
        
        if Auth.auth().currentUser != nil {
            
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            
            print("DEBUG: The current user id is \(currentUid)")
            
            self.configureNavigationBar()

            // configure refresh control
            self.configureRefreshControl()

            if self.user == nil {
                self.fetchCurrentUserData()
            }
                
            self.fetchPosts()
          
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //view.addSubview(navigationController!.navigationBar)
        navigationController?.navigationBar.isHidden = false
    }
                
    // Mark: - UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        //return 1
        return 0
    }
    
    // this is a bit smoother to use with pagination, because it loads while your scrolling or when the cell is coming into view
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if posts.count > 9 {
            if indexPath.item == posts.count - 1 {
                fetchPosts()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // sets the vertical spacing between photos
        //return 4
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //return UIEdgeInsets(top:0, left: 4, bottom: 4, right: 4)
        return UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = (view.frame.width - 2) / 3
        
        let width = (view.frame.width - 0) / 3
        //return CGSize(width: width, height: width - 10)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 330)
    }
    
    // Mark: - UICollectionView
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // Declare header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeader
        
        // Set delegate
        header.delegate = self
        
        // Set the user in header.
        header.user = self.user
        navigationItem.title = user?.firstname
        //navigationItem.title = "Hi \(String(describing: user?.firstname))"
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserPostCell
        
        cell.post = posts[indexPath.item]
        cell.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        cell.layer.borderWidth = 2.5
        
        // we need to set the delegate variable in order for this to work. now when we call on the delegate it will go back to the controller and execute it. anytime we have an action inside of a cell to implement a protocol we will need to ensure that the delegate is set. this is a part of the model <-- controller --> view protocol.
        cell.delegate = self
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /*
        let feedVC = FeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        feedVC.viewSinglePost = true
        feedVC.userProfileController = self
        feedVC.post = posts[indexPath.item]

        navigationController?.pushViewController(feedVC, animated: true)
        */
        
        
        let userSpecificFeedVC = UserSpecificFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        userSpecificFeedVC.viewSinglePost = true
        userSpecificFeedVC.userProfileController = self
        userSpecificFeedVC.post = posts[indexPath.item]
        
        navigationController?.pushViewController(userSpecificFeedVC, animated: true)
    }
    
    /*
    func configureUserViewComponents() {
        
        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
        
        if let window:UIWindow = applicationDelegate.window {

            window.addSubview(photoProfileView)
            
            photoProfileView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: window.frame.width - 64, height: 525)
            photoProfileView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            photoProfileView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
            /*
            photoProfileView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: window.frame.width, height: 525)
            photoProfileView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            photoProfileView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            */

            }
            
        }
    }
    */
    
    func fetchCurrentUserData() {
            
            // Set the user in header.
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            
            //if userVariable == true {
            DataService.instance.REF_USERS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                
                let uid = snapshot.key
                let user = User(uid: uid, dictionary: dictionary)
                self.user = user
                //self.navigationItem.title = user.username
                
                //self.navigationItem.title = user.firstname
                
                //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
                self.collectionView?.reloadData() // Very important to call this.
            
            }
        }
    
    
    func configureNavigationBar() {
        
        // this setting works to ensure nav bar is moved at the same time but removes it from other views. Need a resolution
        //view.addSubview(navigationController!.navigationBar)
        
        //navigationController?.navigationBar.clipsToBounds = true
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
        
        let font = UIFont(name: "HelveticaNeue-Bold", size: 17)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)]
        navigationItem.title = ""
        
        navigationController?.navigationBar.tintColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        
        
        
        /*
         // remove nav bar bottom border
         navigationController?.navigationBar.shadowImage = UIImage()
         let lineView = UIView(frame: CGRect(x: 0, y: 45, width: view.frame.width, height: -0.50))
         lineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
         navigationController?.navigationBar.addSubview(lineView)
        */
        
        customSearchFriendsButton.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
               
            customSearchFriendsButton.setTitle("Search", for: .normal)
            customSearchFriendsButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            customSearchFriendsButton.setTitleColor(UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1), for: .normal)
        
        customSearchFriendsButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        customSearchFriendsButton.addTarget(self, action: #selector(handleSearchFriends), for: .touchUpInside)
            //customSearchFriendsButton.tintColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        
        
        
        let customSearchFriendsIconButton = UIButton(type: UIButton.ButtonType.custom)
        customSearchFriendsIconButton.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
    customSearchFriendsIconButton.setImage(UIImage(named:"simpleSearchIcon")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)

        //customSearchFriendsIconButton.setTitleColor(UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1), for: .normal)
        customSearchFriendsIconButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 18, height: 18)
               customSearchFriendsIconButton.addTarget(self, action: #selector(handleSearchFriends), for: .touchUpInside)
        customSearchFriendsIconButton.tintColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        
        let barSearchFriendsButton = UIBarButtonItem(customView: customSearchFriendsButton)
        let barSearchFriendsIconButton = UIBarButtonItem(customView: customSearchFriendsIconButton)
        //self.navigationItem.rightBarButtonItems = [barSearchFriendsIconButton, barSearchFriendsButton]
        
        // custom back button
             
         let returnNavButton = UIButton(type: UIButton.ButtonType.custom)
         
         returnNavButton.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
         
         //using this code to show the true image without rendering color
         returnNavButton.setImage(UIImage(named:"whiteCircleLeftArrowTB")?.withRenderingMode(.alwaysOriginal), for: .normal)
         returnNavButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 33, height: 33 )
        returnNavButton.addTarget(self, action: #selector(SearchVC.handleBackButton), for: .touchUpInside)
         returnNavButton.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
         returnNavButton.backgroundColor = .clear
             
         let notificationBarBackButton = UIBarButtonItem(customView: returnNavButton)
         self.navigationItem.leftBarButtonItems = [notificationBarBackButton]
         
    }
    
    func setAdminNavigationBar(for header: UserProfileHeader) {

        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let uid = header.user?.uid else { return }
        //guard let user = self.user else { return }
        
        print("The current user id is\(currentUid)")
        print("The user profile we are visiting id is\(uid)")
               
        // if the current user DOES match the user profile we are looking at do this..
        if currentUid == uid {
                   
                   DataService.instance.REF_USERS.child(currentUid).child("isStoreadmin").observe(.value) { (snapshot) in
                       let isStoreadmin = snapshot.value as! Bool
                               
                       print(snapshot.value as! Bool)
                               
                       if isStoreadmin == true {
                           
                        self.configureAdminFeedButton()
                        
                        
                       } else {
                        //current user is the user in question but is NOT the admin .. do nothing
                           print("current user is the user in question but is NOT the admin .. do nothing")
                       }
                   }
        
               } else {
                   
       // the current user does NOT match the user profile we are looking at so do nothing..
               }
    }
    
    func configureAdminFeedButton() {
 
            // configure admin feed post button

            let adminStorePostButton = UIButton(type: UIButton.ButtonType.custom)
                
                adminStorePostButton.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
                
                //using this code to show the true image without rendering color
                adminStorePostButton.setImage(UIImage(named:"simpleYellowCircleWhitePlus")?.withRenderingMode(.alwaysOriginal), for: .normal)
 
                adminStorePostButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 33, height: 33 )
                adminStorePostButton.addTarget(self, action: #selector(handleAdminStorePost), for: .touchUpInside)
                adminStorePostButton.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
                adminStorePostButton.backgroundColor = .clear
        
        let adminFeedButton = UIBarButtonItem(customView: adminStorePostButton)
        self.navigationItem.rightBarButtonItems = [adminFeedButton]
    }
    
    @objc func handleAdminStorePost() {
        
        let adminStorePostVC = AdminStorePostVC(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(adminStorePostVC, animated: true)

    }
    
    @objc func handleBackButton() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSearchFriends() {
        
        let searchVC = SearchVC()

        searchVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(searchVC, animated: true)
        //present(notificationsVC, animated: true, completion:nil)
        
    }
    
    @objc func handleExitProfile() {
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - UserProfileHeader Protocol
    
    func handleEditFollowTapped(for header: UserProfileHeader) {
        guard let user = header.user else { return }
        
        // looking for the label string to make the decision of whether or not the user is the current user. Will need this for later functions!
        if header.editProfileFollowButton.titleLabel?.text == "Edit" {
            
            let editProfileController = EditProfileController()
            editProfileController.user = user
            editProfileController.userProfileController = self
            //let navigationController = UINavigationController(rootViewController: editProfileController)
            //present(editProfileController, animated: true, completion: nil)

            navigationController?.pushViewController(editProfileController, animated: true)
            
        } else {
            
            if header.editProfileFollowButton.titleLabel?.text == "Follow" {
                header.editProfileFollowButton.setTitle("Following", for: .normal)
                print("The user just tapped to follow this profile")
                user.follow()
            } else {
                header.editProfileFollowButton.setTitle("Follow", for: .normal)
                user.unfollow()
                print("This user just unfollowed this profile")
            }
        }
    }
    
    func handleMessagesTapped(for header: UserProfileHeader) {
        // send messages to the profile that you select
        
        print("messenger buttong tapped!")
        
        guard let user = header.user else { return }
    /*
        let newMessageController = NewMessageController()
        newMessageController.selectedUser = user
        //let navigationController = UINavigationController(rootViewController: newMessageController)
        navigationController?.pushViewController(newMessageController, animated: true)
*/
        showChatController(forUser: user)

    }
    
    func showChatController(forUser user: User) {
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        navigationController?.pushViewController(chatController, animated: true)
    }
 
    func handleCheckInTapped(for header: UserProfileHeader) {
        print("checkIn button tapped")
    }
    
    func handlePointsTapped(for header: UserProfileHeader) {
        print("Points button tapped")
    }
    
    func handleDistanceTapped(for header: UserProfileHeader) {
        print("Distance button tapped")
    }
    
    func handleAddPhotoTapped(for header: UserProfileHeader) {
        print("Admin add phot tapped here")
        
        let selectImageVC = SelectImageVC(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: selectImageVC)
        navController.modalPresentationStyle = .fullScreen
        
        present(navController, animated: true, completion: nil)
    }
    
    func setUserStats(for header: UserProfileHeader) {
        
        guard let uid = header.user?.uid else { return }
        
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
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollwers!)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
            attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)]))
            
            header.followersLabel.attributedText = attributedText
        }
        
        // get number of following
        DataService.instance.REF_FOLLOWING.child(uid).observe(.value) { (snapshot) in
            
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                numberOfFollowing = snapshot.count
            } else {
                numberOfFollowing = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollowing!)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
            attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)]))
            
            header.followingLabel.attributedText = attributedText
        }
        
        // get number of posts
        DataService.instance.REF_USER_POSTS.child(uid).observe(.value) { (snapshot) in
            
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                numberOfPosts = snapshot.count
            } else {
                numberOfPosts = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfPosts!)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
            attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)]))
            
            header.postLabel.attributedText = attributedText
        }
        
        
        
        
    }
    
    // MARK: - Handlers
    
    @objc func handleRefresh() {
        posts.removeAll(keepingCapacity: false)
        self.currentKey = nil
        fetchPosts()
        collectionView?.reloadData()
    }
    
    @objc func handlePhotoButton() {
        print("handle photo and caption button")
        
        let selectImageVC = SelectImageVC(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: selectImageVC)
        navController.modalPresentationStyle = .fullScreen
        navController.navigationBar.tintColor = .black
        
        present(navController, animated: true, completion: nil)
    }
    
    func configureRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    // MARK: - API
    
    func fetchPosts() {
        
        // To ensure we get the proper post populating under the current user uid.
        var uid: String!
        
        if let user = self.user {
            uid = user.uid
            
        } else {
            uid = Auth.auth().currentUser?.uid
        }
        
        // initial data pull
        if currentKey == nil {
            
            DataService.instance.REF_USER_POSTS.child(uid).queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.collectionView?.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    
                    let postId = snapshot.key
                    self.fetchPost(withPostId: postId)
                    
                })
                self.currentKey = first.key
            })
        } else {
            
            // query ordered by key to organize the snapshot by key instead of their value
            DataService.instance.REF_USER_POSTS.child(uid).queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 7).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    
                    if postId != self.currentKey {
                        self.fetchPost(withPostId: postId)
                    }
                })
                // setting current key again because it will help continue on the process of pagination by reseting the current key
                self.currentKey = first.key
            })
        }
    }
    
    func fetchPost(withPostId postId: String) {
        
        Database.fetchPost(with: postId) { (post) in
            self.posts.append(post)
            
            self.posts.sort(by: { (post1, post2) -> Bool in
                return post1.creationDate > post2.creationDate
            })
            self.collectionView?.reloadData()
        }
    }
    
    func handleFollowersTapped(for header: UserProfileHeader) {
        let followVC = FollowLikeVC()
        followVC.viewingMode = FollowLikeVC.ViewingMode(index: 1)
        followVC.uid = user?.uid
        print("THIS IS follow VC\(followVC.uid)")
        navigationController?.pushViewController(followVC, animated: true)
    }
    
    func handleFollowingTapped(for header: UserProfileHeader) {
        let followVC = FollowLikeVC()
        followVC.viewingMode = FollowLikeVC.ViewingMode(index: 0)
        followVC.uid = user?.uid
        navigationController?.pushViewController(followVC, animated: true)
    }
    
    func handlePostTapped(for header: UserProfileHeader) {
    
        let userSpecificFeedVC = UserSpecificFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        userSpecificFeedVC.uid = user?.uid
        navigationController?.pushViewController(userSpecificFeedVC, animated: true)
    }
    
    func handleAnalyticsTapped(for header: UserProfileHeader) {
        print("Handle analytics here")
    }
    
    func handleFavoritesTapped(for header: UserProfileHeader) {
        print("Handle favorite restaurants here")
    }
    
    func handledSearchFriendsTapped(for header: UserProfileHeader) {
        print("Handle search friends here")
    }
    
    func handleSearchGroupsTapped(for header: UserProfileHeader) {
        print("Handle search groups here")
    }
}

// delegate created under profile for the UserPostCell (profile view cell)
extension UserProfileVC: ProfileCellDelegate {
    func presentPhotoProfileView(withProfileCell post: Post) {
        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            
            if let window:UIWindow = applicationDelegate.window {

               window.addSubview(photoProfileView)
               
               photoProfileView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: window.frame.width - 64, height: 525)
               photoProfileView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
               photoProfileView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
               
               /*
               photoProfileView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: window.frame.width, height: 525)
               photoProfileView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
               photoProfileView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
               */
            }
        }
    }
}


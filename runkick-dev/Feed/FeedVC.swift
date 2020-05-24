//
//  FeedVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/19/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel

private let reuseIdentifier = "Cell"


class FeedVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, FeedCellDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var homeVC: HomeVC!
    
    // MARK: - Properties
    
    var posts = [Post]() // This need to be a variable so we can mutate it.
    var viewSinglePost = false
    var post: Post?
    var currentKey: String?
    var userProfileController: UserProfileVC?
    
    // here we are using the class photo feed view in order to pull up the photo we need from the subclass
    let photoFeedView: PhotoFeedView = {
        let view = PhotoFeedView()
        //view.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        //view.layer.cornerRadius = 5
        return view
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    let photoCommentButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "goldCircle"), for: .normal)
        //button.setImage(UIImage(named: "trueBlueCirclePlus"), for: .normal)
        button.addTarget(self, action: #selector(handlePhotoButton), for: .touchUpInside)
        button.backgroundColor = .clear
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.alpha = 1
        return button
    }()
    
    let beBoppActionButton: UIButton = {
           let button = UIButton(type: .custom)
           button.setImage(UIImage(named: "beBoppAddPhotoIcon"), for: .normal)
           button.addTarget(self, action: #selector(handlePhotoButton), for: .touchUpInside)
           button.backgroundColor = .clear
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
           button.alpha = 1
           return button
       }()
    
    let photoCommentBackground: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.55).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.isUserInteractionEnabled = true
        let photoCommentTap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoButton))
        photoCommentTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(photoCommentTap)
        view.alpha = 1
        return view
    }()
    
    let tabGradientView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        //view.layer.shadowColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 0.98).cgColor
        //view.layer.shadowColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 0.50).cgColor
        //view.layer.shadowOffset = CGSize(width: 0, height: 2)
        //view.layer.shadowRadius = 18.0
        //view.layer.shadowOpacity = 0.80
        //view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.alpha = 1
        return view
    }()
    
    let timelineBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
        view.alpha = 1
        return view
    }()
    
    

    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adding blur effect with this function at alpha 0 initially
        configureViewComponents()
        
        //extends the edges beyound the tab bar
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true
        

        // uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // adjust view background color
        collectionView.backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 240)
        //collectionView.backgroundColor = UIColor.rgb(red: 181, green: 201, blue: 215)
        
        
        // register cell classes
        self.collectionView!.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // configure refresh control
        let refreshFeedControl = UIRefreshControl()
        refreshFeedControl.addTarget(self, action: #selector(handleFeedRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshFeedControl
        
        configureNavigationBar()
        
        configureFeedViewElements()
        
        setUserFCMTocken()
    
        
        // fetch posts if we are not viewing a single post
        if !viewSinglePost {
            fetchPosts()
        }
        
        updateUserFeeds()
        
        configureTabBar()
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            //flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // adding shadow view to the tab bar
        tabBarController?.tabBar.isTranslucent = false
        tabBarController?.tabBar.layer.cornerRadius = 15
        tabBarController?.tabBar.layer.masksToBounds = true
        tabBarController?.tabBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        tabBarController?.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.layoutSubviews()
    }
    
    
    // MARK: UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // if statement safely unwraps status text
        if let captionText = posts[indexPath.item].caption {
            
            let rect = NSString(string: captionText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
            
            // the height of all the variables in the cell
            let knownHeight: CGFloat = 10 + 50 + 180 + 20 + 20 + 15
            
            return CGSize(width: view.frame.width - 0, height: rect.height + knownHeight + 55)
        }
        
        return CGSize(width: view.frame.width - 0, height: 200)
        /*
        let width = view.frame.width
        //var height = width
        var height = width - 150
        
        height += 20
        //height += 10
        
        return CGSize(width: width, height: height)
        */
        
    }

    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if posts.count > 4 {
            if indexPath.item == posts.count - 1 {
                fetchPosts()
            }
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // this logic will allow us to click on our profile and recieve just that picture that was selected and use the FeedVC code
        if viewSinglePost {
            return 1
        } else {
            return posts.count
        }
    }
    
    // creates a space between top cell and cell view... right before scrolling is enabled.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //return CGSize(width: view.frame.width, height: 10)
        return CGSize(width: view.frame.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // sets the vertical spacing between posts
        return 0
    }
    
    // calling function to give space and insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        
        cell.delegate = self
        
        // delegate to view long press post
        cell.altDelegate = self
        
        if viewSinglePost {
            if let post = self.post {
                cell.post = post
            }
        } else {
            cell.post = posts[indexPath.item]

        }
        
        handleHastagTapped(forCell: cell)
        
        handleUsernameLabelTapped(forCell: cell)
        
        handleMentionedTapped(forCell: cell)
        
        return cell
    }
    
    
    func configureViewComponents() {
        
        
        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            
            if let window:UIWindow = applicationDelegate.window {
                
                window.addSubview(visualEffectView)
                visualEffectView.anchor(top: window.topAnchor, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
                visualEffectView.alpha = 0
                
                let gesture = UITapGestureRecognizer(target: self, action: #selector(handleBlurDismiss))
                visualEffectView.addGestureRecognizer(gesture)
            }
        }

    }
    
    @objc func handleBlurDismiss() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.visualEffectView.alpha = 0
            self.photoFeedView.alpha = 0
            self.photoFeedView.transform = CGAffineTransform(scaleX: 1.75, y: 1.75)
        }) { (_) in
            self.photoFeedView.removeFromSuperview()
        }
        
    }
    
    func configureNavigationBar() {
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
         
        let font = UIFont(name: "HelveticaNeue-Bold", size: 17)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)]

        navigationItem.title = "Broadcast"
        
        navigationController?.navigationBar.tintColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
    /*
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1),
             NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 30) ??
                                     UIFont.systemFont(ofSize: 30)]
    */
        
        navigationController?.navigationBar.addSubview(timelineBarView)
        timelineBarView.anchor(top: navigationController?.navigationBar.bottomAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: nil, right: navigationController?.navigationBar.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
        
        /*
        // adding logo to navigation bar
        let logo = UIImage(named: "waywalkLogoBlack")
        let imageView = UIImageView(image: logo)
        
        imageView.contentMode = .scaleAspectFit
        navigationController?.navigationBar.topItem?.titleView = imageView
        */
        
        // add or remove nav bar bottom border
        /*
        navigationController?.navigationBar.shadowImage = UIImage()
        let lineView = UIView(frame: CGRect(x: 0, y: 45, width: view.frame.width, height: -0.50))
        lineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        navigationController?.navigationBar.addSubview(lineView)
        */
        
       
        
        
        //let notifcationImage = UIImage(named: "simpleBlueBell-25x25")
            
        //let notificationButton = UIBarButtonItem(image: notifcationImage, style: .plain, target: self, action: #selector(handleNotificationView))
        
        //self.navigationItem.rightBarButtonItems = [notificationButton]
        //self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 9/255, green: 171/255, blue: 231/255, alpha: 1)
        
        
        
        // can add a boolean statement here for notifications buttons to be included
        
        let customFeedTitle = UIButton(type: UIButton.ButtonType.custom)
        customFeedTitle.frame = CGRect(x: 0, y: 15, width: 40, height: 30)
        
        //let leftBarFont = UIFont(name: "HelveticaNeue-Bold", size: 25)!
        //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: leftBarFont, NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
                   
        customFeedTitle.setTitle("Notifications", for: .normal)
        customFeedTitle.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        customFeedTitle.setTitleColor(UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1), for: .normal)
        
        
            
        customFeedTitle.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //customSearchTitle.addTarget(self, action: #selector(handleSearchFriends), for: .touchUpInside)
        
        customFeedTitle.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        let barFeedButton = UIBarButtonItem(customView: customFeedTitle)
        //self.navigationItem.leftBarButtonItems = [barFeedButton]

        
        
        
        // custom notifications button
            
        //let customNotificationsButton = UIButton(type: UIButton.ButtonType.system)
        let customNotificationsButton = UIButton(type: UIButton.ButtonType.custom)
        
        customNotificationsButton.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        
        //using this code to show the true image without rendering color
        customNotificationsButton.setImage(UIImage(named:"whiteCircleRightArrowTB")?.withRenderingMode(.alwaysOriginal), for: .normal)
       
        //using this code to be able to adjust tint
    //customNotificationsButton.setImage(UIImage(named:"simpleRoundedEnvelope")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        
        //customSearchFriendsIconButton.setTitleColor(UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1), for: .normal)
        customNotificationsButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 33, height: 33 )
        customNotificationsButton.addTarget(self, action: #selector(handleNotificationView), for: .touchUpInside)
        customNotificationsButton.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        customNotificationsButton.backgroundColor = .clear
        //customNotificationsButton.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        //customNotificationsButton.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        //customNotificationsButton.layer.shadowRadius = 2.5
        //customNotificationsButton.layer.shadowOffset = CGSize(width: 0, height: 2)
            
        
        
        //let barSearchTitle = UIBarButtonItem(customView: customSearchTitle)
        let barNotificationButton = UIBarButtonItem(customView: customNotificationsButton)
        self.navigationItem.rightBarButtonItems = [barNotificationButton]
        
        
        
        // custom back button
         /*
         let returnNavButton = UIButton(type: UIButton.ButtonType.custom)
         
         returnNavButton.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
         
         //using this code to show the true image without rendering color
         returnNavButton.setImage(UIImage(named:"whiteCircleLeftArrowTB")?.withRenderingMode(.alwaysOriginal), for: .normal)
         returnNavButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 33, height: 33 )
        returnNavButton.addTarget(self, action: #selector(FeedVC.handleBackButton), for: .touchUpInside)
         returnNavButton.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
         returnNavButton.backgroundColor = .clear
             
         let notificationBarBackButton = UIBarButtonItem(customView: returnNavButton)
         self.navigationItem.leftBarButtonItems = [notificationBarBackButton]
        */
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
    
    @objc func handleNotificationView() {
        
        let notificationsVC = NotificationsVC()

        notificationsVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(notificationsVC, animated: true)
        //present(notificationsVC, animated: true, completion:nil)
    }
    
    @objc func handleMessageInboxView() {
        
        let messagesVC = MessagesController()

        messagesVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(messagesVC, animated: true)
    }
    
    func configureFeedViewElements() {
        
        //let circleViewDimension = 50
        
        
        //view.addSubview(backgroundPhotoIconButton)
        //backgroundPhotoIconButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 15, width: CGFloat(circleViewDimension), height: CGFloat(circleViewDimension))
        //backgroundPhotoIconButton.layer.cornerRadius = CGFloat(circleViewDimension / 2)
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USERS.child(currentUserId).child("isStoreadmin").observe(.value) { (snapshot) in
        let isStoreadmin = snapshot.value as! Bool
        
        print(snapshot.value as! Bool)
            
            if isStoreadmin == true {
                
                // if user is a super user do nothing else  display the buttong on the feed view.
                
            } else {
                
                let tabBarHeight = CGFloat((self.tabBarController?.tabBar.frame.size.height)!)
                
                self.view.addSubview(self.photoCommentButton)
                self.photoCommentButton.anchor(top: nil, left: nil, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: tabBarHeight + 20, paddingRight: 20, width: 60, height: 60)
                
                self.photoCommentButton.addSubview(self.beBoppActionButton)
                self.beBoppActionButton.anchor(top: self.photoCommentButton.topAnchor, left: self.photoCommentButton.leftAnchor, bottom: nil, right: nil, paddingTop: 7, paddingLeft: 5.5, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
                
                /*
                view.addSubview(photoCommentBackground)
                photoCommentBackground.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: tabBarHeight + 20, paddingRight: 20, width: 60, height: 60)
                photoCommentBackground.layer.cornerRadius = 60 / 2
                
                photoCommentBackground.addSubview(photoCommentButton)
                photoCommentButton.anchor(top: photoCommentBackground.topAnchor, left: photoCommentBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: 48, height: 48)
                */
                
            }
        }

    }
    
    
    
    // MARK: - API
    
    func updateUserFeeds() {
        
        // function that allows all followed user post to show up in their feed, retroactively
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // reach into the user-following database to determine which users are following other users
        DataService.instance.REF_FOLLOWING.child(currentUid).observe(.childAdded) { (snapshot) in
            
            let followingUserId = snapshot.key
            
            DataService.instance.REF_USER_POSTS.child(followingUserId).observe(.childAdded, with: { (snapshot) in
                
                let postId = snapshot.key
                
                DataService.instance.REF_FEED.child(currentUid).updateChildValues([postId: 1])
            })
        }
        
        DataService.instance.REF_USER_POSTS.child(currentUid).observe(.childAdded) { (snapshot) in
            
            let postId = snapshot.key
            
            DataService.instance.REF_FEED.child(currentUid).updateChildValues([postId: 1])
        }
    }
    
    func setUserFCMTocken() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let fcmToken = Messaging.messaging().fcmToken else { return }
        
        let values = ["fcmToken": fcmToken]
        
        DataService.instance.REF_USERS.child(currentUid).updateChildValues(values)
    }
    
    func fetchPosts() {
        
        print("fetch post function called")
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        // fetching posts with pagination and only observing x amount of post at a time
        
        if currentKey == nil {
            DataService.instance.REF_FEED.child(currentUid).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                
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
            DataService.instance.REF_FEED.child(currentUid).queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 6).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    if postId != self.currentKey {
                        self.fetchPost(withPostId: postId)
                    }
                })
                self.currentKey = first.key
            })
        }
    }
    
    // helper function
    func fetchPost(withPostId postId: String) {

        Database.fetchPost(with: postId) { (post) in
            
            self.posts.append(post)
            
            self.posts.sort(by: { (post1, post2) -> Bool in
                return post1.creationDate > post2.creationDate
            })
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: - FeedCellDelegate Protocol
    
    // follow the IG tutorial from Udemy lesson #35
    
    func handleUsernameTapped(for cell: FeedCell) {
        
        guard let post = cell.post else { return } // accessing post value from the post value in the FeedCell
       
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        userProfileVC.user = post.user
        
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    func handleOptionTapped(for cell: FeedCell) {
        
        // if user is super user or if user is the current user ... allow all of these options..
        
        guard let post = cell.post else { return }
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USERS.child(currentUserId).child("isStoreadmin").observe(.value) { (snapshot) in
        let isStoreadmin = snapshot.value as! Bool
        
        print(snapshot.value as! Bool)
        
            if post.ownerUid == currentUserId || isStoreadmin == true {    // this is the profile screen for users
            
                print("DEBUG: The user is either the user who owns the post or a super user")
                
                let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
                
                alertController.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { (_) in
                    
                    // this function can be found under the post class
                    post.deletePost(post.ownerUid)
                    
                    // if we are in our reguar feed mode
                    if !self.viewSinglePost {
                        self.handleFeedRefresh()
                    } else {
                        if let userProfileController = self.userProfileController {
                            _ = self.navigationController?.popViewController(animated: true)
                            userProfileController.handleRefresh()
                        }
                    }
                }))
                
                alertController.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { (_) in
                    
                    let uploadPostController = UploadPostVC()
                    let navigationController = UINavigationController(rootViewController: uploadPostController)
                    uploadPostController.postToEdit = post
                    uploadPostController.uploadAction = UploadPostVC.UploadAction(index: 1)
                    self.present(navigationController, animated: true, completion: nil)
                    
                }))
                
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            
            
            }
        }
        
    
        
        
        /*
        if post.ownerUid == Auth.auth().currentUser?.uid {
            
            let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { (_) in
                
                post.deletePost()
                
                // if we are in our reguar feed mode
                if !self.viewSinglePost {
                    self.handleFeedRefresh()
                } else {
                    if let userProfileController = self.userProfileController {
                        _ = self.navigationController?.popViewController(animated: true)
                        userProfileController.handleRefresh()
                    }
                }
            }))
            
            alertController.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { (_) in
                
                let uploadPostController = UploadPostVC()
                let navigationController = UINavigationController(rootViewController: uploadPostController)
                uploadPostController.postToEdit = post
                uploadPostController.uploadAction = UploadPostVC.UploadAction(index: 1)
                self.present(navigationController, animated: true, completion: nil)
                
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
        */
    }
    
    func handlePhotoTapped(for cell: FeedCell) {
        
        print("This will be a photo display eventually")
        /*
        guard let post = cell.post else { return }
        let commentVC = CommentVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        // sending this postId over to the comment view controller
        commentVC.post = post
        navigationController?.pushViewController(commentVC, animated: true)
        */
    }
    
    func handleLikeTapped(for cell: FeedCell, isDoubleTap: Bool) {
        
        guard let post = cell.post else { return }
    
        if post.didLike {
            // handle unlike post
            if !isDoubleTap {
                post.adjustLikes(addLike: false, completion: { (likes) in
                    cell.likesLabel.text = "\(likes)"
                    cell.newLikeButton.setImage(UIImage(named: "simpleBlueHeartGray"), for: .normal)
                })
            }
      
        } else {
            // handle liking post
            post.adjustLikes(addLike: true, completion: { (likes) in
                cell.likesLabel.text = "\(likes)"
                cell.newLikeButton.setImage(UIImage(named: "simpleBlueHeartGray"), for: .normal)
            })
        }
    }
    
    func handleShowLikes(for cell: FeedCell) {
        guard let post = cell.post else { return }
        guard let postId = post.postId else { return }
        
        let followLikeVC = FollowLikeVC()
        followLikeVC.viewingMode = FollowLikeVC.ViewingMode(index: 2)
        followLikeVC.postId = postId
        navigationController?.pushViewController(followLikeVC, animated: true)
    }
    
    func handleConfigureLikeButton(for cell: FeedCell) {
        guard let post = cell.post else { return }
        guard let postId = post.postId else { return }
        // guard statements are placed under individual func so it can be considered optional
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USER_LIKES.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.hasChild(postId) {
                // setting this to true maintains the liked status after a refresh gesture
                // this may work for maintaining the status of store admin and setting the userVariable LoginVC
                post.didLike = true
                cell.newLikeButton.setImage(UIImage(named: "simpleBlueHeartGray"), for: .normal)
            }
        }
    }
    
    func handleCommentTapped(for cell: FeedCell) {
        
        print("comment button tapped")
        guard let post = cell.post else { return }
        let commentVC = CommentVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        // sending this postId over to the comment view controller
        commentVC.post = post
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
    // MARK: - Handlers
    
    @objc func handleFeedRefresh() {
        // this is a screen pull down function to refresh you feed
        posts.removeAll(keepingCapacity: false)
        self.currentKey = nil
        fetchPosts()
        collectionView?.reloadData()
    }
    
    @objc func handleShowMessages() {
        let messagesController = MessagesController()
        navigationController?.pushViewController(messagesController, animated: true)
        
    }
    
    @objc func handlePhotoButton() {
        print("handle photo and caption button")
        
        let selectImageVC = SelectImageVC(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: selectImageVC)
        navController.modalPresentationStyle = .fullScreen
        //navController.navigationBar.tintColor = .black
        
        present(navController, animated: true, completion: nil)
    }
    
    func handleHastagTapped(forCell cell: FeedCell) {
        cell.captionLabel.handleHashtagTap { (hashtag) in
            let hashtagController = HashtagController(collectionViewLayout: UICollectionViewFlowLayout())
            hashtagController.hashtag = hashtag
            self.navigationController?.pushViewController(hashtagController, animated: true)
        }
    }
    
    func handleMentionedTapped(forCell cell: FeedCell) {
        cell.captionLabel.handleMentionTap { (username) in
            self.getMentionedUser(withUsername: username)
        }
    }
    
    func configureTabBar() {
        
        // adding shadow view to the tab bar
        tabBarController?.tabBar.isTranslucent = true
        tabBarController?.tabBar.barTintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        tabBarController?.tabBar.layer.cornerRadius = 15
        tabBarController?.tabBar.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        tabBarController?.tabBar.layer.borderWidth = 1
        tabBarController?.tabBar.layer.masksToBounds = true
        tabBarController?.tabBar.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        tabBarController?.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        collectionView.addSubview(tabGradientView)
        tabGradientView.anchor(top: nil, left: collectionView.leftAnchor, bottom: collectionView.bottomAnchor, right: collectionView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
        
    }
    
    func handleUsernameLabelTapped(forCell cell: FeedCell) {
        
        guard let user = cell.post?.user else { return }
        guard let username = user.username else { return }
        
        // look for username as pattern
        let customType = ActiveType.custom(pattern: "^\(username)\\b")
        
        cell.captionLabel.handleCustomTap(for: customType) { (_) in
            
            let userProfilerController = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
            userProfilerController.user = user
            self.navigationController?.pushViewController(userProfilerController, animated: true)
        }
    }
    
}

// calling the function to present the photo view
extension FeedVC: AltFeedCellDelegate {
    func presentPhotoFeedView(withFeedCell post: Post) {
    
        
        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            
            if let window:UIWindow = applicationDelegate.window {

                window.addSubview(photoFeedView)
                
                // need this to be able to dismiss the photo feed view
                photoFeedView.delegate = self
                
                // this is saying which ever feed post you passed into this feed cell, we will display that same post and it's post elements here
                photoFeedView.post = post
                
                
                //photoFeedView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: window.frame.width - 50, height: 525)
                
                photoFeedView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: window.frame.width, height: 525)
                photoFeedView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                photoFeedView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                //photoFeedView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -14).isActive = true
                
                // should start with a zoomed out and animate into a zoomed in effect
                photoFeedView.transform = CGAffineTransform(scaleX: 0.50, y:0.50)
                photoFeedView.alpha = 0
                
                UIView.animate(withDuration: 0.25) {
                    self.visualEffectView.alpha = 1
                    self.photoFeedView.alpha = 1
                    self.photoFeedView.transform = .identity
                }
                
            }
        }
   
        
    }
}


extension FeedVC: PhotoFeedViewDelegate {
    func dismissPhotoFeedView(withFeed post: Post?) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.visualEffectView.alpha = 0
            self.photoFeedView.alpha = 0
            self.photoFeedView.transform = CGAffineTransform(scaleX: 1.75, y: 1.75)
        }) { (_) in
            self.photoFeedView.removeFromSuperview()
        }
    }
}

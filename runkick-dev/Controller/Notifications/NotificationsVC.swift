//
//  NotificationsVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 9/17/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "NotificationsCell"

class NotificationsVC: UITableViewController, NotificationCellDelegate {
    
    // MARK: - Properties
    
    var notifications = [Notification]()
    var timer: Timer?
    var currentKey: String?
    
    let cancelViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "simpleCancelIcon"), for: .normal)
        button.addTarget(self, action: #selector(dismissNotificationsView), for: .touchUpInside)
        button.tintColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        button.alpha = 1
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        //extends the edges beyound the tab bar
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true
        */
        
        configureTableView()
        
        // fetch notifications
        fetchNotifications()
        
        // configuring navigation bar
        configureNavigationBar()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if notifications.count > 4 {
            if indexPath.item == notifications.count - 1 {
                fetchNotifications()
            }
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationsCell
        
        cell.notification = notifications[indexPath.row]
        
        cell.delegate = self
        
        //cell.layer.anchorPointZ = CGFloat(indexPath.row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let notification = notifications[indexPath.row]
        
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.user = notification.user
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    
    // MARK: - NotificationCellDelegate protocol
    
    func configureTableView() {

        //tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)
        tableView.addSubview(cancelViewButton)
        
        // register cell class
        tableView.register(NotificationsCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // add spacing to the top of the table view
        //tableView.contentInset = UIEdgeInsets(top: 50,left: 0,bottom: 0,right: 0)
        
        tableView.rowHeight = 80
        
        //view.addSubview(cancelViewButton)
        //cancelViewButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 50, height: 50)
        
        
        // clear separator lines
        tableView.separatorStyle = .none
        //tableView.separatorColor = .clear
    }
    
    func handleFollowTapped(for cell: NotificationsCell) {
        
        guard let user = cell.notification?.user else { return }
        
        if user.isFollowed {
            
            // handle unfollow user
            user.unfollow()
            cell.followButton.configure(didFollow: false)
            
        } else {
            
            // handle follow user
            user.follow()
            cell.followButton.configure(didFollow: true)
        }
    }
    
    func handlePostTapped(for cell: NotificationsCell) {
        
        guard let post = cell.notification?.post else { return }
        
        //let feedController = FeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        let feedController = FeedVC()
        feedController.viewSinglePost = true
        feedController.post = post
        navigationController?.pushViewController(feedController, animated: true)

    }
    
    // MARK: - Handlers
    
    func handleReloadTable() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleSortNotifications), userInfo: nil, repeats: false)
    }
    
    @objc func handleSortNotifications() {
        
        self.notifications.sort { (notification1, notification2) -> Bool in
            return notification1.creationDate > notification2.creationDate
        }
        self.tableView.reloadData()
    }
    
    // MARK: - API
    
    // creating a helper function with input parameters for fetchNotifications in order to clean up code
    func fetchNotification(withNotificationId  notificationId: String, dataSnapshot snapshot: DataSnapshot) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
        guard let uid = dictionary["uid"] as? String else { return }
        
        Database.fetchUser(with: uid, completion: { (user) in
            
            if let postId = dictionary["postId"] as? String {
                
                Database.fetchPost(with: postId, completion: { (post) in
                    
                    let notification = Notification(user: user, post: post, dictionary: dictionary)
                    self.notifications.append(notification)
                    self.handleReloadTable()
                })
            } else {
                let notification = Notification(user: user, dictionary: dictionary)
                self.notifications.append(notification)
                self.handleReloadTable()
            }
        })
        DataService.instance.REF_NOTIFICATIONS.child(currentUid).child(notificationId).child("checked").setValue(1)
    }
    
    func fetchNotifications() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        if currentKey == nil {
            DataService.instance.REF_NOTIFICATIONS.child(currentUid).queryLimited(toLast: 5).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let notificationId = snapshot.key
                    
                    self.fetchNotification(withNotificationId: notificationId, dataSnapshot: snapshot)
                })
                self.currentKey = first.key
            }
            
        } else {
            
            DataService.instance.REF_NOTIFICATIONS.child(currentUid).queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 6).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let notificationId = snapshot.key
                    
                    if notificationId != self.currentKey {
                        self.fetchNotification(withNotificationId: notificationId, dataSnapshot: snapshot)
                    }
                })
                self.currentKey = first.key
            })
        }
    }

    func configureNavigationBar() {
        
        //view.addSubview(navigationController!.navigationBar)

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
        
        let font = UIFont(name: "HelveticaNeue-Bold", size: 17)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)]
        navigationItem.title = "Notifications"
        
        navigationController?.navigationBar.tintColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        
        /*
        let returnNavButton = UIButton(type: UIButton.ButtonType.custom)
         
         returnNavButton.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
         
         //using this code to show the true image without rendering color
         returnNavButton.setImage(UIImage(named:"whiteCircleLeftArrowTB")?.withRenderingMode(.alwaysOriginal), for: .normal)
         returnNavButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 33, height: 33 )
        returnNavButton.addTarget(self, action: #selector(NotificationsVC.handleBackButton), for: .touchUpInside)
         returnNavButton.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
         returnNavButton.backgroundColor = .clear
             
         let notificationBarBackButton = UIBarButtonItem(customView: returnNavButton)
         self.navigationItem.leftBarButtonItems = [notificationBarBackButton]
        */
    }
    
    // may not need this function in the future
    @objc func handleBackButton() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissNotificationsView() {
        
        print("this function should dismiss notification view")
    }

}

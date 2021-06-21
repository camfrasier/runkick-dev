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
private let reuseAltMessageIdentifier = "AltMessageCell"

//class NotificationsVC: UITableViewController, NotificationCellDelegate {
  class NotificationsVC: UIViewController, NotificationCellDelegate {

    // MARK: - Properties
    
    var notifications = [Notification]()
    var timer: Timer? // helps fix the bug where pics get jumbled up with follow like
    var timer1: Timer?
    var currentKey: String?
    var tableView: UITableView!
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()  // consolidating user message
    
    // this is for importing the message VC, may not need
  //  let messagesVC = MessagesController()
    
    let cancelViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "simpleCancelIcon"), for: .normal)
        button.addTarget(self, action: #selector(dismissNotificationsView), for: .touchUpInside)
        button.tintColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        button.alpha = 1
        return button
    }()
    
    lazy var backButtonBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var messagesBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        let rewardsTap = UITapGestureRecognizer(target: self, action: #selector(handleMessagesView))
        rewardsTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(rewardsTap)
        view.alpha = 1
        return view
    }()
    
    lazy var notificationsBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        let rewardsTap = UITapGestureRecognizer(target: self, action: #selector(handleNotificationsView))
        rewardsTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(rewardsTap)
        view.alpha = 1
        return view
    }()
    
    lazy var messageNotificationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize = .zero
        layout.sectionInset = .zero
        //layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.contentInset = .zero
        return cv
    }()
    
    let messagesLabel: UILabel = {
        let label = UILabel()
        label.text = "Messages"
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        return label
    }()
    
    let notificationsLabel: UILabel = {
        let label = UILabel()
        label.text = "Notifications"
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        return label
    }()
    
    lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.walkzillaYellow()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = UIColor.walkzillaYellow()
        
        /*
        //extends the edges beyound the tab bar
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true
        */
        
        configureMessageNotificationView()
        
        configureTableView()
        
        // fetch notifications
        fetchNotifications()
        
        configureCollectionView()
        fetchMessages()
        
        // configuring navigation bar
        configureNavigationBar()
        
        // configure refresh control
        configureRefreshControl()
        
        //tableView.isHidden = true
        //collectionView.isHidden = true
    }
    
    /*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        case 0: self = .Like
        case 1: self = .Comment
        case 2: self = .Follow
        case 3: self = .CommentMention
        case 4: self = .PostMention
        case 5: self = .Message
        default: self = .Message
        */
        
        let notification = notifications[indexPath.row]
        
        print("THIs is the NOTITIFCATION TYPE \(notification.notificationType)")
        if notification.notificationType == .Like {
            // type like go to the post identified
            
            print("The notification type is a LIKE")
            guard let post = notification.post else { return }
            
            
            //let userSpecificFeedVC = UserSpecificFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
            
            let userSpecificFeedVC = UserSpecificFeedVC()
            userSpecificFeedVC.viewSinglePost = true
            userSpecificFeedVC.post = post
            //navigationController?.pushViewController(userSpecificFeedVC, animated: true)

            let nav = self.navigationController
            DispatchQueue.main.async {
                nav?.view.layer.add(CATransition().popFromRight(), forKey: nil)
                nav?.pushViewController(userSpecificFeedVC, animated: false)
            }
        }
            if notification.notificationType == .Comment {
                
                print("Go to the post comment that was mentioned")
                
            }
            
            if notification.notificationType == .Follow {
                
                let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
             
                userProfileVC.user = notification.user
                //navigationController?.pushViewController(userProfileVC, animated: true)
                /*
                let transition = CATransition()
                transition.duration = 5
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
                transition.type = CATransitionType.moveIn
                transition.subtype = CATransitionSubtype.fromRight
                */
         
                //self.view.window!.backgroundColor = UIColor.white
                
                //navigationController?.view.layer.add(transition, forKey: kCATransition)
                //navigationController?.pushViewController(userProfileVC, animated: false)
                
  
                // SUPER IMPORTANT FUNCTION!!!!
                let nav = self.navigationController
                DispatchQueue.main.async {
                    self.view.window!.backgroundColor = UIColor.white
                    nav?.view.layer.add(CATransition().popFromRight(), forKey: kCATransition)
                    nav?.pushViewController(userProfileVC, animated: false)
                }
                
            }
            
            if notification.notificationType == .CommentMention {
                print("Go to the post comment that you were mentioned in ")
            }
            
            if notification.notificationType == .PostMention {
                
                print("Go to the post comment that you were mentioned in")
                
            }
            
            if notification.notificationType == .Message {
                
                print("Go to the user specific messages")
                
            }
            
        
    }
    */
    
    // MARK: - CollectionView
    
    func configureCollectionView() {
        
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        

        tableView.addSubview(collectionView)
        collectionView.register(AltMessageCell.self, forCellWithReuseIdentifier: reuseAltMessageIdentifier)
        
    }
    
    
    // MARK: - NotificationCellDelegate protocol
    
    func configureTableView() {
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.translatesAutoresizingMaskIntoConstraints = false

        //tableView = UITableView()
        //tableView.delegate = self
        //tableView.dataSource = self
        
        //tableView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        tableView.backgroundColor = UIColor.walkzillaYellow()
        tableView.addSubview(cancelViewButton)
        
        // register cell class
        tableView.register(NotificationsCell.self, forCellReuseIdentifier: reuseIdentifier)

        
        //tableView.rowHeight = 80

        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: messageNotificationView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        // clear separator lines
        tableView.separatorStyle = .none
        //tableView.separatorColor = .clear
        
        // giving the top border a bit of buffer
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    func configureMessageNotificationView() {
        
        view.addSubview(messageNotificationView)
        messageNotificationView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
        
        messageNotificationView.addSubview(lineView)
        lineView.anchor(top: nil, left: messageNotificationView.leftAnchor, bottom: messageNotificationView.bottomAnchor, right: messageNotificationView.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 0.75)
        
        messageNotificationView.addSubview(indicatorView)
        indicatorView.anchor(top: nil, left: lineView.leftAnchor, bottom: lineView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -1, paddingRight: 0, width: 70, height: 4)
        
        messageNotificationView.addSubview(messagesBackground)
        messagesBackground.anchor(top: nil, left: messageNotificationView.leftAnchor, bottom: lineView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 25, paddingBottom: 10, paddingRight: 0, width: 90, height: 40)
        
        messagesBackground.addSubview(messagesLabel)
        messagesLabel.anchor(top: nil, left: messagesBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        messagesLabel.centerYAnchor.constraint(equalTo: messagesBackground.centerYAnchor).isActive = true
        
        
        messageNotificationView.addSubview(notificationsBackground)
        notificationsBackground.anchor(top: nil, left: messagesBackground.rightAnchor, bottom: lineView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: 90, height: 40)
        
        notificationsBackground.addSubview(notificationsLabel)
        notificationsLabel.anchor(top: nil, left: notificationsBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        notificationsLabel.centerYAnchor.constraint(equalTo: notificationsBackground.centerYAnchor).isActive = true
        
       
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
        
        
        //let userSpecificFeedVC = UserSpecificFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        let userSpecificFeedVC = UserSpecificFeedVC()
        userSpecificFeedVC.viewSinglePost = true
        userSpecificFeedVC.post = post
        //navigationController?.pushViewController(userSpecificFeedVC, animated: true)

        let nav = self.navigationController
        DispatchQueue.main.async {
            nav?.view.layer.add(CATransition().popFromRight(), forKey: nil)
            nav?.pushViewController(userSpecificFeedVC, animated: false)
        }

    }
    
    // MARK: - Handlers
    
    // MARK: - Handlers
    
    
    
    @objc func handleNotificationsView() {
        
        indicatorView.transform = CGAffineTransform(translationX: 1, y: 1)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            //self.indicatorView.transform = CGAffineTransform(scaleX: 1.25, y: 1)
            self.indicatorView.transform = CGAffineTransform(translationX: 105, y: 0)
            
        })
        

        
        print("transition to notifications")
      //  tableView.isHidden = false
        collectionView.isHidden = true
        
    }
    
    @objc func handleMessagesView() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            

            self.indicatorView.transform = CGAffineTransform(translationX: 0, y: 0)
            //self.indicatorView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
        
        print("transition to messages")
       // tableView.isHidden = true
        collectionView.isHidden = false
        
    }
    

    
    
    @objc func handleRefresh() {
        notifications.removeAll(keepingCapacity: false)
        self.currentKey = nil
        fetchNotifications()
        
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    func configureRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.tableView?.refreshControl = refreshControl
    }
    
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
    
    func handleReloadMessagesTable() {
        self.timer1?.invalidate()
        
        self.timer1 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleSortMessages), userInfo: nil, repeats: false)
    }
    
    @objc func handleSortMessages() {
        
        self.messages.sort(by: { (message1, message2) -> Bool in
            return message1.creationDate > message2.creationDate
        })

        self.collectionView.reloadData()
        print("Handle reload messafes called")
        
   
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
                    //self.handleReloadTable()
                    self.handleSortNotifications()
                })
            } else {
                let notification = Notification(user: user, dictionary: dictionary)
                self.notifications.append(notification)
                //self.handleReloadTable()
                self.handleSortNotifications()
            }
        })
        DataService.instance.REF_NOTIFICATIONS.child(currentUid).child(notificationId).child("checked").setValue(1)
    }
    
    

    
    
    
    func fetchNotifications() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        self.tableView.refreshControl?.endRefreshing()
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
    
    
     
     func fetchMessages() {
     
         guard let currentUid = Auth.auth().currentUser?.uid else { return }
         
       
         self.messages.removeAll()
         self.messagesDictionary.removeAll()
         //self.messagesTableView.reloadData()
        self.collectionView.reloadData()
        
        self.collectionView.refreshControl?.endRefreshing()
        
         DataService.instance.REF_USER_MESSAGES.child(currentUid).observe(.childAdded) { (snapshot) in
             let uid = snapshot.key
             
             DataService.instance.REF_USER_MESSAGES.child(currentUid).child(uid).observe(.childAdded, with: { (snapshot) in
                 
                 let messageId = snapshot.key
                 
                 //self.fetchMessage(withMessageId: messageId)
                    Database.fetchMessage(withMessageId: messageId) { message in
                    
                    let chatPartnerId = message.getChatPartnerId()
                        self.messagesDictionary[chatPartnerId] = message
                        self.messages = Array(self.messagesDictionary.values)
                        //self.collectionView.reloadData()
                        self.handleReloadMessagesTable()
                        
                        print("I just need some data here and maybe I can be money")
                        
                    //self.handleReloadMessagesTable()
                        //self.messagesTableView.reloadData()
                }
                
                
             })
         }
         
     }
   
    
    func showChatController(forUser user: User) {
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        navigationController?.pushViewController(chatController, animated: true)
    }
    

    func configureNavigationBar() {
        
        //view.addSubview(navigationController!.navigationBar)

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

        
        // add or remove nav bar bottom border
        navigationController?.navigationBar.shadowImage = UIImage()
        //let lineView = UIView(frame: CGRect(x: 0, y: 45, width: view.frame.width, height: 0.25))
        //lineView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
        
        let font = UIFont(name: "ArialRoundedMTBold", size: 17)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1)]
        navigationItem.title = "Recent Activity"
        
        navigationController?.navigationBar.tintColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        

        

    
        /*
        let returnNavButton = UIButton(type: UIButton.ButtonType.system)
         
         returnNavButton.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
         
         //using this code to show the true image without rendering color
         returnNavButton.setImage(UIImage(named:"cancelButtonBackground")?.withRenderingMode(.alwaysOriginal), for: .normal)
         returnNavButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 45, height: 45 )
        returnNavButton.addTarget(self, action: #selector(HomeVC.handleBackButton), for: .touchUpInside)
         returnNavButton.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
         returnNavButton.backgroundColor = .clear
             
         let notificationBarBackButton = UIBarButtonItem(customView: returnNavButton)
         self.navigationItem.leftBarButtonItems = [notificationBarBackButton]
        */
        
    }
    
    // may not need this function in the future
    @objc func handleBackButton() {
       // _ = self.navigationController?.popViewController(animated: false)

        let nav = self.navigationController
        DispatchQueue.main.async {

            self.view.window!.backgroundColor = UIColor.white
            nav?.view.layer.add(CATransition().popFromLeft(), forKey: kCATransition)
            nav?.popViewController(animated: false)
        }
    }
    
    @objc func dismissNotificationsView() {
        
        print("this function should dismiss notification view")
    }

}

extension NotificationsVC: UITableViewDataSource, UITableViewDelegate  {
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
           return 70
       }
       
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of rows
            
           return notifications.count
       }
       
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           if notifications.count > 4 {
               if indexPath.item == notifications.count - 1 {
                   fetchNotifications()
               }
           }
       }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
           let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationsCell
           
           cell.notification = notifications[indexPath.row]
           
           cell.delegate = self
           
           //cell.layer.anchorPointZ = CGFloat(indexPath.row)
           
           cell.selectionStyle = .none
           
           return cell
       }
       
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            
           /*
           case 0: self = .Like
           case 1: self = .Comment
           case 2: self = .Follow
           case 3: self = .CommentMention
           case 4: self = .PostMention
           case 5: self = .Message
           default: self = .Message
           */
           
           let notification = notifications[indexPath.row]
           
           print("THIs is the NOTITIFCATION TYPE \(notification.notificationType)")
           if notification.notificationType == .Like {
               // type like go to the post identified
               
               print("The notification type is a LIKE")
               guard let post = notification.post else { return }
               
               
               //let userSpecificFeedVC = UserSpecificFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
               
               let userSpecificFeedVC = UserSpecificFeedVC()
               userSpecificFeedVC.viewSinglePost = true
               userSpecificFeedVC.post = post
               //navigationController?.pushViewController(userSpecificFeedVC, animated: true)

               let nav = self.navigationController
               DispatchQueue.main.async {
                   nav?.view.layer.add(CATransition().popFromRight(), forKey: nil)
                   nav?.pushViewController(userSpecificFeedVC, animated: false)
               }
           }
               if notification.notificationType == .Comment {
                   
                   print("Go to the post comment that was mentioned")
                   
               }
               
               if notification.notificationType == .Follow {
                   
                   let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
                
                   userProfileVC.user = notification.user
                   //navigationController?.pushViewController(userProfileVC, animated: true)
                   /*
                   let transition = CATransition()
                   transition.duration = 5
                   transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
                   transition.type = CATransitionType.moveIn
                   transition.subtype = CATransitionSubtype.fromRight
                   */
            
                   //self.view.window!.backgroundColor = UIColor.white
                   
                   //navigationController?.view.layer.add(transition, forKey: kCATransition)
                   //navigationController?.pushViewController(userProfileVC, animated: false)
                   
     
                   // SUPER IMPORTANT FUNCTION!!!!
                   let nav = self.navigationController
                   DispatchQueue.main.async {
                       self.view.window!.backgroundColor = UIColor.white
                       nav?.view.layer.add(CATransition().popFromRight(), forKey: kCATransition)
                       nav?.pushViewController(userProfileVC, animated: false)
                   }
                   
               }
               
               if notification.notificationType == .CommentMention {
                   print("Go to the post comment that you were mentioned in ")
               }
               
               if notification.notificationType == .PostMention {
                   
                   print("Go to the post comment that you were mentioned in")
                   
               }
               
               if notification.notificationType == .Message {
                   
                   print("Go to the user specific messages")
                   
               }
       }
}

extension NotificationsVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let width = (view.frame.width )
        let height = (width - width + 70)
        return CGSize(width: width, height: height)

    }
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
          return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
  
        return 0
    }
      

      


      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
      }

      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
          
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseAltMessageIdentifier, for: indexPath) as! AltMessageCell
          
        cell.message = messages[indexPath.item]

          return cell
      }
      
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          
        let message = messages[indexPath.item]
        
        let chatPartnerId = message.getChatPartnerId()
        Database.fetchUser(with: chatPartnerId) { (user) in // fetching our user or chat partner with the chat partner id
            self.showChatController(forUser: user)
          
        }
      }
      

}


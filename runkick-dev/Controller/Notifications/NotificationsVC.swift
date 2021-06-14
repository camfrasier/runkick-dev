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
private let reuseMessageIdentifier = "MessagesCell"

//class NotificationsVC: UITableViewController, NotificationCellDelegate {
  class NotificationsVC: UIViewController, NotificationCellDelegate {

    // MARK: - Properties
    
    var notifications = [Notification]()
    var timer: Timer?   // helps fix the bug where pics get jumbled up with follow like
    var currentKey: String?
    var tableView: UITableView!
    var messagesTableView: UITableView!
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()  // consolidating user message
    
    // this is for importing the message VC, may not need
    let messagesVC = MessagesController()
    
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
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
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
        
        configureMessagesView()
        
        fetchMessages()
    
        //tableView.isHidden = true
        messagesTableView.isHidden = true
        
        //configureMessagesVC()
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
    
    // MARK: - NotificationCellDelegate protocol
    
    func configureTableView() {

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        tableView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        tableView.addSubview(cancelViewButton)
        
        // register cell class
        tableView.register(NotificationsCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // add spacing to the top of the table view
        tableView.contentInset = UIEdgeInsets(top: 15,left: 0,bottom: 0,right: 0)
        
        tableView.rowHeight = 80

        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        // clear separator lines
        tableView.separatorStyle = .none
        //tableView.separatorColor = .clear
        
    }
    
    func configureMessagesView() {
        

        messagesTableView = UITableView()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
        //tableView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        messagesTableView.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 255)
        messagesTableView.addSubview(cancelViewButton)
        
        // register cell class
        messagesTableView.register(MessageCell.self, forCellReuseIdentifier: reuseMessageIdentifier)
        
        // add spacing to the top of the table view
        messagesTableView.contentInset = UIEdgeInsets(top: 15,left: 0,bottom: 0,right: 0)
        
        messagesTableView.rowHeight = 80

        
        view.addSubview(messagesTableView)
        messagesTableView.translatesAutoresizingMaskIntoConstraints = false
        messagesTableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        // clear separator lines
        messagesTableView.separatorStyle = .none
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
    
    
     
     func fetchMessages() {
     
         guard let currentUid = Auth.auth().currentUser?.uid else { return }
         
         self.messages.removeAll()
         self.messagesDictionary.removeAll()
         self.messagesTableView.reloadData()
         
         DataService.instance.REF_USER_MESSAGES.child(currentUid).observe(.childAdded) { (snapshot) in
             
             let uid = snapshot.key
             
             DataService.instance.REF_USER_MESSAGES.child(currentUid).child(uid).observe(.childAdded, with: { (snapshot) in
                 
                 let messageId = snapshot.key
                 
                 self.fetchMessage(withMessageId: messageId)
             })
         }
     }
     
     func fetchMessage(withMessageId messageId: String) {
         
         DataService.instance.REF_MESSAGES.child(messageId).observeSingleEvent(of: .value) { (snapshot) in
             guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
             
             let message = Message(dictionary: dictionary)
             let chatPartnerId = message.getChatPartnerId()
             self.messagesDictionary[chatPartnerId] = message
             self.messages = Array(self.messagesDictionary.values)
             
             self.messagesTableView?.reloadData()
         }
     }
     
    
    func configureMessagesVC() {
    
           print("DEBUG: Right menu is configured at this point.")
           
           //messagesVC.delegate = self

        messagesVC.tableView.delegate = self
        //messagesVC.datasource = self
        messagesVC.view.frame = CGRect(x: 0, y: 15, width: view.frame.width, height: view.frame.height - 15)
               
        view.addSubview(messagesVC.view)

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
        let lineView = UIView(frame: CGRect(x: 0, y: 45, width: view.frame.width, height: 0.25))
        lineView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
        
        let font = UIFont(name: "ArialRoundedMTBold", size: 17)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)]
        navigationItem.title = "Recent Activity"
        
        navigationController?.navigationBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        

        

    
        
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
            
            if tableView == messagesTableView {
                
                return messages.count
            }
            
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
            
            if tableView == messagesTableView {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseMessageIdentifier, for: indexPath) as! MessageCell
                
                cell.message = messages[indexPath.row]
                
                return cell
            }
            
           let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationsCell
           
           cell.notification = notifications[indexPath.row]
           
           cell.delegate = self
           
           //cell.layer.anchorPointZ = CGFloat(indexPath.row)
           
           cell.selectionStyle = .none
           
           return cell
       }
       
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            
            if tableView == messagesTableView {
                let message = messages[indexPath.row]
                
                let chatPartnerId = message.getChatPartnerId()
                Database.fetchUser(with: chatPartnerId) { (user) in // fetching our user or chat partner with the chat partner id
                    self.showChatController(forUser: user)
                }
            } else {
            
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
}

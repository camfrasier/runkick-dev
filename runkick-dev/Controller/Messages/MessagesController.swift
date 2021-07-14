//
//  MessagesController.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 9/25/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "MessagesCell"

class MessagesController: UITableViewController {
    
    // MARK: - Properties
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()  // consolidating user message
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        //extends the edges beyound the tab bar
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true
        */
        
        //view.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)
        view.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)
        tableView.separatorStyle = .none
        
        configureNavigationBar()
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: reuseIdentifier)
    
       fetchMessages()
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        
        cell.message = messages[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        let chatPartnerId = message.getChatPartnerId()
        Database.fetchUser(with: chatPartnerId) { (user) in // fetching our user or chat partner with the chat partner id
            self.showChatController(forUser: user)
        }
    }
    
    // MARK: - Handlers
    /*
    @objc func handleNewMessage() {
        // way to trick the current view into being a navigation controller view
        let newMessageController = NewMessageController()
        // udemy lesson 53 ig clone
        newMessageController.messagesController = self
        let navigationController = UINavigationController(rootViewController: newMessageController)
        //navigationController.pushViewController(navigationController, animated: true)
        self.present(navigationController, animated: true, completion: nil)
    }
 */
    
    func showChatController(forUser user: User) {
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        navigationController?.pushViewController(chatController, animated: true)
    }
    
    
    // MARK: - API
    
    func fetchMessages() {
    
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        self.messages.removeAll()
        self.messagesDictionary.removeAll()
        self.tableView.reloadData()
        
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
            print("Here are the chat dictionary is \(self.messages)")
            
            
           // self.tableView?.reloadData()
            
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
        navigationItem.title = "Messages"
        
        navigationController?.navigationBar.tintColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)

        // custom back button
        let returnNavButton = UIButton(type: UIButton.ButtonType.custom)
         
         returnNavButton.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
         
         //using this code to show the true image without rendering color
         returnNavButton.setImage(UIImage(named:"leftCircleArrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
         returnNavButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 33, height: 33 )
        returnNavButton.addTarget(self, action: #selector(MessagesController.handleBackButton), for: .touchUpInside)
         returnNavButton.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
         returnNavButton.backgroundColor = .clear
             
         let notificationBarBackButton = UIBarButtonItem(customView: returnNavButton)
         self.navigationItem.leftBarButtonItems = [notificationBarBackButton]
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewMessage))

    }
    
    @objc func handleBackButton() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    
}


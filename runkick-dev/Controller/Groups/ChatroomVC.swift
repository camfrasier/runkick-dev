//
//  ChatroomVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 11/27/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "ChatroomCell"

class ChatroomVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties

    var groupId: String! {
        didSet {
            guard let groupIdentifier = groupId else { return }
            
            print("THis is the chatroom group Id \(groupIdentifier)")

        }
    }
    var messages = [ChatroomMessage]()
    var currentKey: String?
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 55)
        containerView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        // embedding the send button within container view with a target
        containerView.addSubview(sendButton)
        sendButton.anchor(top: nil, left: nil, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 50, height: 0)
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
  
        let searchBarBackground = UIView()
        containerView.addSubview(searchBarBackground)
        searchBarBackground.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 10, paddingLeft: 22, paddingBottom: 10, paddingRight: 5, width: 0, height: 0)
        searchBarBackground.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        //searchBarBackground.layer.cornerRadius = 15
        
        // send button should be above message field in order to have it not run over when typing int the text field
        containerView.addSubview(messageTextField)
        messageTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: sendButton.leftAnchor, paddingTop:10, paddingLeft: 40, paddingBottom: 10, paddingRight: 5, width: 0, height: 0)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        containerView.addSubview(separatorView)
        separatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
        
        
        
        messageTextField.attributedPlaceholder = NSAttributedString(string:" What's up?", attributes:[NSAttributedString.Key.foregroundColor: UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1)])
        messageTextField.font = UIFont.systemFont(ofSize: 22)
        messageTextField.keyboardType = UIKeyboardType.default
        messageTextField.layer.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
        messageTextField.layer.cornerRadius = 13
        
        return containerView
    } ()
        /*
    let returnHomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "home_unselected"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleReturnHome), for: .touchUpInside)
        return button
    } ()
    */
    
    let messageTextField: UITextField = {
        let tf = UITextField()
         tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    } ()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.tintColor = UIColor.actionRed()
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
        
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        formValidation()
        
        // Do any additional setup after loading the view.
        
        //view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        
        collectionView?.register(ChatroomCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.walkzillaYellow()
         
        observeMessages()
        
        configureNavigationBar()
        
        setupToHideKeyboardOnTap()
        
        configureNavigationBar()
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    // MARK: - UICollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
        
        //return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 70
        
        let message = messages[indexPath.item]
        
        //height = estimateFrameForText(message.messageText).height + 20
        height = estimateFrameForText(message.messageText).height + 15
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    /*
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if messages.count > 4 {
            if indexPath.item == messages.count - 1 {
            observeMessages()   // THIS COULD CAUSE A LOOP
            }
        }
    }
   */
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatroomCell
        
        cell.message = messages[indexPath.item]
        
        configureMessage(cell: cell, message: messages[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    // MARK: - Handlers
    
        @objc func handleSend() {
        uploadMessageToServer()
        
        messageTextField.text = nil
        
        formValidation()
    }
    
    func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
    }
    
    

    
    // MARK: - API
    
    func configureMessage(cell: ChatroomCell, message: ChatroomMessage) {
       // guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // accounting for the width of the message bubble based on text
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(message.messageText).width
        
        // accounting for the height of the message bubble based on text
        
        
        cell.frame.size.height = estimateFrameForText(message.messageText).height + 10
        
        cell.bubbleViewLeftAnchor?.isActive = true
        //cell.bubbleView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        cell.bubbleView.backgroundColor = UIColor.clear
        cell.textView.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        cell.textView.isScrollEnabled = false
        cell.profileImageView.isHidden = false
        
    }
    
    
    func uploadMessageToServer() {
    
        guard let messageText = messageTextField.text else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        

        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        let messageValues = ["creationDate": creationDate,
                             "fromId": currentUid,
                             "groupId": groupId,
                             "messageText": messageText] as [String: Any]
        
        let messageRef = DataService.instance.REF_GROUP_MESSAGES.child(groupId).childByAutoId()
        guard let messageRefKey = messageRef.key else { return }

        
        messageRef.updateChildValues(messageValues)
        
        DataService.instance.REF_USER_GROUP_MESSAGES.child(groupId).child(currentUid).updateChildValues([messageRefKey : 1])

       // DataService.instance.REF_USER_GROUP_MESSAGES.child(currentUid).child(groupId).updateChildValues([messageRefKey : 1])
        
    }
    

/*
    func observeMessages() {
        
        if currentKey == nil {
            DataService.instance.REF_GROUP_MESSAGES.child(groupId).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                
                //self.collectionView?.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                
                allObjects.forEach({ (snapshot) in
                    let chatId = snapshot.key

                    self.fetchMessage(withChatId: chatId, groupIdentifier: self.groupId)  // fix the group id
                    
                })
                self.currentKey = first.key
            })
        } else {
            DataService.instance.REF_GROUP_MESSAGES.child(groupId).queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 6).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let chatId = snapshot.key
                    if chatId != self.currentKey {
                        self.fetchMessage(withChatId: chatId, groupIdentifier: self.groupId)
                    }
                })
                self.currentKey = first.key
            })
        }

            // use helper funtion to pass in the helper id
        //fetchMessage(withGroupId: groupId)
        
    }
    
 */
    
    func observeMessages() {
        
        DataService.instance.REF_GROUP_MESSAGES.child(groupId).observe(.childAdded) { (snapshot) in
            print(snapshot)
            
            let chatId = snapshot.key
            
            print("Just printing the chat key \(chatId)")
            self.fetchMessage(withChatId: chatId, groupIdentifier: self.groupId)
            
            
        }
    }
    
    
    
    func fetchMessage(withChatId chatId: String, groupIdentifier: String) {
        
        /*
        Database.fetchChatroomMessages(with: chatId, groupId: groupIdentifier) { (chat) in
            
            self.messages.append(chat)
           
            
            self.messages.sort(by: { (chat1, chat2) -> Bool in
                return chat2.creationDate > chat1.creationDate
            })
            self.collectionView?.reloadData()
        }
        */
        
        DataService.instance.REF_GROUP_MESSAGES.child(groupId).child(chatId).observeSingleEvent(of: .value) { (snapshot) in
        
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let fromId = dictionary["fromId"] as? String else { return }  // Parsing through JSON data.
            
            print("THIS IS THE OWNER ID \(fromId)")
            
            let message = ChatroomMessage(dictionary: dictionary)
            self.messages.append(message)
            self.collectionView?.reloadData()
            
            /*
            Database.fetchUser(with: fromId, completion: { (user) in
                
                
                let chat = ChatroomMessage(dictionary: dictionary)
                
                completion(chat)
            })
            */
        }  
    }
    
    
    /*
    func fetchMessage(withChatId chatId: String, groupIdentifier: String) {
        
        DataService.instance.REF_GROUP_MESSAGES.child(groupId).child(chatId).observeSingleEvent(of: .value) { (snapshot) in
        
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let fromId = dictionary["fromId"] as? String else { return }  // Parsing through JSON data.
            
            print("THIS IS THE OWNER ID \(fromId)")
            
            let chat = ChatroomMessage(dictionary: dictionary)
            self.messages.append(chat)
             self.collectionView?.reloadData()
            
        }
    }
    */

    func configureNavigationBar() {
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        //guard let user = self.user else { return }
        
        //navigationItem.title = user.username
        navigationItem.title = "Chatroom"

    }
    
    @objc func formValidation() {
        guard
            
            messageTextField.hasText == true else {
        
                sendButton.isEnabled = false
                sendButton.tintColor = UIColor(red: 80/255, green: 180/255, blue: 180/255, alpha: 1)
                
                return
        }
        
        sendButton.isEnabled = true
        sendButton.tintColor = UIColor.actionRed()
    }

}



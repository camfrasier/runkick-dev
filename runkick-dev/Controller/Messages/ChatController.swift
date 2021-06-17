//
//  ChatController.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 9/30/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "ChatCell"

class ChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var user: User?
    var messages = [Message]()
    
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
        searchBarBackground.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 20, paddingLeft: 22, paddingBottom: 10, paddingRight: 5, width: 0, height: 0)
        //searchBarBackground.layer.backgroundColor = UIColor.rgb(red: 181, green: 201, blue: 215).cgColor
        searchBarBackground.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 250).cgColor
        searchBarBackground.layer.cornerRadius = 15
        
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
        messageTextField.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        messageTextField.layer.cornerRadius = 0
        
        return containerView
    } ()
    
    let messageTextField: UITextField = {
        let tf = UITextField()
        //tf.placeholder = "What's up?"
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
    
    // MARK: - Init
    
    override func viewDidLoad() {
            super.viewDidLoad()
        /*
        //extends the edges beyound the tab bar
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true
        */
        
        //collectionView?.backgroundColor = UIColor.rgb(red: 181, green: 201, blue: 215)  // launch screen color
        collectionView?.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        collectionView?.register(ChatCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        configureNavigationBar()
        
        observeMessages()
        
       // setupToHideKeyboardOnTap()
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
        
        var height: CGFloat = 80
        
        let message = messages[indexPath.item]
        
        height = estimateFrameForText(message.messageText).height + 20
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatCell
        
        cell.message = messages[indexPath.item]
        
        configureMessage(cell: cell, message: messages[indexPath.item])
        
        return cell
    }
    
    // MARK: - Handlers
    
    @objc func handleInfoTapped() {
        let userProfileController = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.user = user
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    @objc func handleSend() {
        uploadMessageToServer()
        
        messageTextField.text = nil
    }
    
    func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func configureMessage(cell: ChatCell, message: Message) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // accounting for the width of the message bubble based on text
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(message.messageText).width + 32
        
        // accounting for the height of the message bubble based on text
        cell.frame.size.height = estimateFrameForText(message.messageText).height + 20
        
        if message.fromId == currentUid {
            // color can change with the colorway of the actual app
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            //cell.bubbleView.backgroundColor = UIColor.rgb(red: 236, green: 38, blue: 125) // action red
            //cell.bubbleView.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 250)
            cell.bubbleView.backgroundColor = UIColor.walkzillaYellow() // true blue
            cell.textView.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
            cell.profileImageView.isHidden = true
            
        } else {
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            //cell.bubbleView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
            cell.bubbleView.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 245)
            cell.textView.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
            cell.profileImageView.isHidden = false
        }
    }
    
    func configureNavigationBar() {
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        guard let user = self.user else { return }
        
        navigationItem.title = user.username
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.tintColor = .black
        infoButton.addTarget(self, action: #selector(handleInfoTapped), for: .touchUpInside)

        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = infoBarButtonItem
        
        
        // custom back button
        let returnNavButton = UIButton(type: UIButton.ButtonType.custom)
         
         returnNavButton.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
         
         //using this code to show the true image without rendering color
         returnNavButton.setImage(UIImage(named:"whiteCircleLeftArrowTB")?.withRenderingMode(.alwaysOriginal), for: .normal)
         returnNavButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 33, height: 33 )
        returnNavButton.addTarget(self, action: #selector(ChatController.handleBackButton), for: .touchUpInside)
         returnNavButton.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
         returnNavButton.backgroundColor = .clear
             
         let notificationBarBackButton = UIBarButtonItem(customView: returnNavButton)
         self.navigationItem.leftBarButtonItems = [notificationBarBackButton]
    }
    
    @objc func handleBackButton() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - API
    
    func uploadMessageToServer() {
        
        guard let messageText = messageTextField.text else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let user = self.user?.uid else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        let messageValues = ["creationDate": creationDate,
                             "fromId": currentUid,
                             "toId": user,
                             "messageText": messageText] as [String: Any]
        
        let messageRef = DataService.instance.REF_MESSAGES.childByAutoId()
        guard let messageRefKey = messageRef.key else { return }

        
        messageRef.updateChildValues(messageValues)
        
        DataService.instance.REF_USER_MESSAGES.child(currentUid).child(user).updateChildValues([messageRefKey : 1])

        DataService.instance.REF_USER_MESSAGES.child(user).child(currentUid).updateChildValues([messageRefKey : 1])
        
    }
    
    func observeMessages() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let chatPartnerId = self.user?.uid else { return }
        
        DataService.instance.REF_USER_MESSAGES.child(currentUid).child(chatPartnerId).observe(.childAdded) { (snapshot) in
            print(snapshot)
            
            let messageId = snapshot.key
            
            // use helper funtion to pass in the helper id
            self.fetchMessage(withMessageId: messageId)
        }
    }
    
    func fetchMessage(withMessageId messageId: String) {
        
        DataService.instance.REF_MESSAGES.child(messageId).observeSingleEvent(of: .value) { (snapshot) in

            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let message = Message(dictionary: dictionary)
            self.messages.append(message)
            self.collectionView?.reloadData()
        }
    }
}


//
//  CommentVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 9/16/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseidentifier = "CommentCell"

class CommentVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var comments = [Comment]()  // will use this array to populate our table view
    var post: Post?
    
    // note we can adjust the hight of our container view
    lazy var containerView: CommentInputAccessoryView = {
     
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let containerView = CommentInputAccessoryView(frame: frame)
    
        containerView.backgroundColor = .white
        
        containerView.delegate = self
        
        return containerView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color
        collectionView?.backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 240)
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        
        // navigation title
        navigationItem.title = "Comments"
        
        // register cell class
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: reuseidentifier)
        
        // fetch comments
        fetchComments()
    }
    
    // showing and hiding the navigation bar everytime the screen loads
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // dynamically adjusting the comment box size to fit text
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    // MARK: - UICollectionVIew
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseidentifier, for: indexPath) as! CommentCell
        
        handleHashtagTapped(forCell: cell)
        
        handleMentionTapped(forCell: cell)
        
        cell.comment = comments[indexPath.item]
        return cell
    }
    
    // MARK: - Handlers
    
    func handleHashtagTapped(forCell cell: CommentCell) {
        cell.commentLabel.handleHashtagTap { (hashtag) in
            let hashtagController = HashtagController(collectionViewLayout: UICollectionViewFlowLayout())
            hashtagController.hashtag = hashtag
            self.navigationController?.pushViewController(hashtagController, animated: true)
        }
    }
    
    func handleMentionTapped(forCell cell: CommentCell) {
        cell.commentLabel.handleMentionTap { (username) in
            self.getMentionedUser(withUsername: username)
        }
    }
    
    // MARK: - API
    
    func fetchComments() {
        
        guard let postId = post?.postId else { return }
        
        DataService.instance.REF_USER_POST_COMMENT.child(postId).observe(.childAdded) { (snapshot) in
            
            // cast our snapshot as a dictionary
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            Database.fetchUser(with: uid, completion: { (user) in
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                self.collectionView?.reloadData()
            })
        }
    }
    
    
    func uploadCommentNotificationToServer() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let postId = self.post?.postId else { return }
        guard let uid = post?.user?.uid else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        // notification values
        let values = ["checked": 0,
                      "creationDate": creationDate,
                      "uid": currentUid,
                      "type": COMMENT_INT_VALUE,
                      "postId": postId] as [String : Any]
        
        // upload comment notification ot server
        if uid != currentUid {
            DataService.instance.REF_NOTIFICATIONS.child(uid).childByAutoId().updateChildValues(values)
        }
    }
}

extension CommentVC: CommentInputAccessoryViewDelagate {
    func didSubmit(forComment comment: String) {
        
        guard let postId = post?.postId else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        let values = ["commentText": comment,
                      "creationDate": creationDate,
                      "uid": uid] as [String : Any]
        
        DataService.instance.REF_USER_POST_COMMENT.child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
            
            self.uploadCommentNotificationToServer()
            
            if comment.contains("@") {
                self.uploadMentionNotification(forPostId: postId, withText: comment, isForComment: true)
            }
            // whenever our comment child values are finished updating in the database it will reset this comment text field to nil
            self.containerView.clearCommentTextView()
        }
    }
}


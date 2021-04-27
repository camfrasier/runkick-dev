//
//  UserSpecificFeedVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 4/12/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel

private let reuseIdentifier = "Cell"


class UserSpecificFeedVC: UIViewController, UserSpecificFeedCellDelegate, UIScrollViewDelegate {

    
    
    // MARK: - Properties
    
    var posts = [Post]() // This need to be a variable so we can mutate it.
    
    var user: User?
    var post: Post?  // i believe this is for the single view post function.. not sure just yet
    var currentKey: String?
    var userProfileController: UserProfileVC?
    var adminProfileController: AdminProfileVC?  // may not need if i don't add a view photo component.
    var viewSinglePost = false
    var uid: String?
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        //cv.register(UserCarouselCell.self, forCellWithReuseIdentifier: reuseCarouselIdentifier)
        return cv
    }()

    lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "userProfileIcon")
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(handleProfileSelected))
        profileTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(profileTap)
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("THE single post status is equal to \(viewSinglePost)")
       
        fetchProfileData()
        /*
        //extends the edges beyound the tab bar
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true
        */
        
        //collectionView.backgroundColor = UIColor.rgb(red: 181, green: 201, blue: 215)
        collectionView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        // Register cell classes
        //self.collectionView.register(UserSpecificFeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // register cell classes
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserSpecificFeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    
        
        // configure refresh control
        let refreshFeedControl = UIRefreshControl()
        refreshFeedControl.addTarget(self, action: #selector(handleFeedRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshFeedControl
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        collectionView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        configureNavigationBar()
        
        // fetch posts if we are not viewing a single post --- altimately want to view all post but start at the needed post
        if !viewSinglePost {
            fetchPosts()
        }

        // Do any additional setup after loading the view.
        

    }

    // MARK: UICollectionViewFlowLayout
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
           var bounds = UIScreen.main.bounds
           var width = bounds.size.width
           var height = bounds.size.height

           
           if viewSinglePost {
            
             if let post = self.post {
                if let captionText = post.caption {
                    
                    let photoStyle = post.photoStyle
                    
                    if photoStyle == "landscape" {
                        
                        let rect = NSString(string: captionText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
                                   
                                   // the height of all the variables in the cell
                                   //let knownHeight: CGFloat = 10 + 40 + 175 + 20 + 30 + 35
                                   
                                   return CGSize(width: width, height: (height - 300) + rect.height)
                        
                    } else {
                        let rect = NSString(string: captionText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
                    
                        return CGSize(width: width, height: (height - 200) + rect.height)
                    }
                }
                
            }
           } else {
               
                   let photoStyle = posts[indexPath.item].photoStyle
          
               if photoStyle == "landscape" {
                       
               print("Photo is landscape")
               // if statement safely unwraps status text
               if let captionText = posts[indexPath.item].caption {
                   

                   let rect = NSString(string: captionText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
      
                       return CGSize(width: width, height: (height - 300) + rect.height)
               
                       }
                   } else {
                       
                   print("Photo is portrait")
                   
                   if let captionText = posts[indexPath.item].caption {
                           

                           let rect = NSString(string: captionText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
         
                       return CGSize(width: width, height: (height - 200) + rect.height)
                   }
               }
    
           }
              
           return CGSize(width: width, height: height - 250)
  
       }
    
    
    func handleUsernameTapped(for cell: UserSpecificFeedCell) {
        print("handle username tapped")
    }
    
    func handleOptionTapped(for cell: UserSpecificFeedCell) {
        print("handle username tapped")
    }
    
    func handleFollowFollowingTapped(for cell: UserSpecificFeedCell) {
        print("handle follow following tapped")
    }
    
    func handleLikeTapped(for cell: UserSpecificFeedCell, isDoubleTap: Bool) {
        print("handle like tapped")
    }
    
    func handlePhotoTapped(for cell: UserSpecificFeedCell) {
        print("handle photo tapped")
    }
    
    func handleCommentTapped(for cell: UserSpecificFeedCell) {
        print("handle comment tapped")
    }
    
    func handleConfigureLikeButton(for cell: UserSpecificFeedCell) {
        print("handle like button tapped")
    }
    
    func handleShowLikes(for cell: UserSpecificFeedCell) {
        print("handle show likes tapped")
    }
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        
        if viewSinglePost {
            
        if let post = self.post {
            if let captionText = post.caption {
                let rect = NSString(string: captionText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
                           
                           // the height of all the variables in the cell
                          // let knownHeight: CGFloat = 10 + 40 + 175 + 20 + 30 + 35
                           
                          // return CGSize(width: view.frame.width - 0, height: rect.height + knownHeight + 250)
                
                    return CGSize(width: view.frame.width, height: (view.frame.height - 40) + rect.height)
            }
            
        }
        } else {
            
            // if statement safely unwraps status text
            if let captionText = posts[indexPath.item].caption {
                
                let rect = NSString(string: captionText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
                
                // the height of all the variables in the cell
               // let knownHeight: CGFloat = 10 + 40 + 175 + 20 + 30 + 35
                
                //return CGSize(width: view.frame.width - 0, height: rect.height + knownHeight + 250)
                
                //return CGSize(width: view.frame.width - 0, height: view.frame.height - 50)
                
                return CGSize(width: view.frame.width, height: (view.frame.height - 40) + rect.height)
            }
            
        }
        // return CGSize(width: view.frame.width - 0, height: 200)
        //return CGSize(width: view.frame.width - 0, height: view.frame.height + 50)
        return CGSize(width: view.frame.width, height: view.frame.height - 40)
        
    /*
        if viewSinglePost {
            
        if let post = self.post {
            if let captionText = post.caption {
                let rect = NSString(string: captionText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
                           
                           // the height of all the variables in the cell
                           let knownHeight: CGFloat = 10 + 40 + 175 + 20 + 30 + 35
                           
                           return CGSize(width: view.frame.width - 0, height: rect.height + knownHeight + 30)
            }
            
        }
        } else {
            
            // if statement safely unwraps status text
            if let captionText = posts[indexPath.item].caption {
                
                let rect = NSString(string: captionText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
                
                // the height of all the variables in the cell
                let knownHeight: CGFloat = 10 + 40 + 175 + 20 + 30 + 35
                
                return CGSize(width: view.frame.width - 0, height: rect.height + knownHeight + 30)
            }
            
        }

        
        return CGSize(width: view.frame.width - 0, height: 200)
    */
    }
   */

    /*
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if posts.count > 4 {
            if indexPath.item == posts.count - 1 {
                fetchPosts()
            }
        }
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
        // sets the vertical spacing between photos
        return 0
    }
    
    // calling function to give space and insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserSpecificFeedCell
        
        
        if viewSinglePost {
            if let post = self.post {
                cell.post = post
            }
        } else {
            
            // this must be set in order to see the image for whoever made the post should show up in the user specific feed
            cell.post = posts[indexPath.item]
            
        }
        
        handleHastagTapped(forCell: cell)
        
        handleMentionedTapped(forCell: cell)
    
        return cell
    }
    */
    
    func configureNavigationBar() {
        
           //view.addSubview(navigationController!.navigationBar)
        
            navigationController?.navigationBar.isHidden = false
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
               
               navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

               UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
                
               let font = UIFont(name: "HelveticaNeue-Bold", size: 17)!
               self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)]

               navigationItem.title = "Posts"
               
               navigationController?.navigationBar.tintColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        
        
            let returnNavButton = UIButton(type: UIButton.ButtonType.system)
             
             returnNavButton.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
             
             //using this code to show the true image without rendering color
             returnNavButton.setImage(UIImage(named:"cancelButtonHeavy")?.withRenderingMode(.alwaysOriginal), for: .normal)
             returnNavButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 15, height: 15 )
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
                nav?.view.layer.add(CATransition().popFromLeft(), forKey: nil)
                nav?.popViewController(animated: false)
            }
            
        }
    
    
    // MARK: - Handlers
    
    // this function follows the options post.. if we want to delete a particular post.
    
    @objc func handleFeedRefresh() {
        // this is a screen pull down function to refresh you feed
        posts.removeAll(keepingCapacity: false)
        self.currentKey = nil
        fetchPosts()
        collectionView.reloadData()
    }
    
    
    func handleHastagTapped(forCell cell: UserSpecificFeedCell) {
        cell.captionLabel.handleHashtagTap { (hashtag) in
            let hashtagController = HashtagController(collectionViewLayout: UICollectionViewFlowLayout())
            hashtagController.hashtag = hashtag
            self.navigationController?.pushViewController(hashtagController, animated: true)
        }
    }
    
    func handleMentionedTapped(forCell cell: UserSpecificFeedCell) {
        cell.captionLabel.handleMentionTap { (username) in
            self.getMentionedUser(withUsername: username)
        }
    }
    /*
    func fetchPosts() {
        
        print("fetch post function called")
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_POSTS.observe(.childAdded) { (snapshot) in
            
            let postId = snapshot.key
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            
            let user = User(uid: currentUid, dictionary: dictionary)
            
            let post = Post(postId: postId, user: user, dictionary: dictionary)
            
            // mutation happens here
            self.posts.append(post)
            
            
            // sorting our user posts
            self.posts.sort(by: { (post1, post2) -> Bool in
                return post1.creationDate > post2.creationDate
            })
            
            print("Post caption is", post.caption)
            self.collectionView.reloadData()
        }
        */
    
    func fetchPosts() {
        
        // To ensure we get the proper post populating under the current user uid.
        
        /*
        var uid: String!
        
        if let user = self.user {
            uid = user.uid
            
        } else {
            uid = Auth.auth().currentUser?.uid
        }
        */
        
        guard let observedUserId = uid else { return }
        
        print("THIS IS THE VALUE OF THE UID is \(observedUserId)")
        
        // initial data pull
        if currentKey == nil {
            
            DataService.instance.REF_USER_POSTS.child(observedUserId).queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.collectionView.refreshControl?.endRefreshing()
                
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
            DataService.instance.REF_USER_POSTS.child(observedUserId).queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 7).observeSingleEvent(of: .value, with: { (snapshot) in
                
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
                self.collectionView.reloadData()
            }
        }
    
    func fetchProfileData() {
        
        // Set the user in header.
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USERS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            
            guard let profileImageUrl = user.profileImageURL else { return }
            self.profileImageView.loadImage(with: profileImageUrl)
        }
    }
    
    @objc func handleProfileSelected() {
        print("DEBUG: Profile view selected")
        
        let profileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        //profileVC.modalPresentationStyle = .fullScreen
        //present(profileVC, animated: true, completion:nil)
        navigationController?.pushViewController(profileVC, animated: true)
    }
        
        /*
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
 */
    }

extension UserSpecificFeedVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
          // #warning Incomplete implementation, return the number of sections
          return 1
      }
      
     func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
          if posts.count > 4 {
              if indexPath.item == posts.count - 1 {
                  fetchPosts()
              }
          }
      }

      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          
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
          // sets the vertical spacing between photos
          return 0
      }
      
      // calling function to give space and insets
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          
          return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserSpecificFeedCell
          
        cell.delegate = self
          
          if viewSinglePost {
              if let post = self.post {
                  cell.post = post
                
                print("WE ARE TRYING TO FIND THE VALUE OF POST \(cell.post)")
              }
          } else {
              
              // this must be set in order to see the image for whoever made the post should show up in the user specific feed
              cell.post = posts[indexPath.item]
              
          }
          
          handleHastagTapped(forCell: cell)
          
          handleMentionedTapped(forCell: cell)
      
          return cell
      }
     
}






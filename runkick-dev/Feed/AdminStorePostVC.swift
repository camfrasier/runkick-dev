//
//  AdminStorePostVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 5/2/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel

private let reuseIdentifier = "Cell"

class AdminStorePostVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, AdminStorePostCellDelegate {

    // MARK: - Properties
    
    var posts = [StorePost]() // This need to be a variable so we can mutate it.
    var post: StorePost?
    var currentKey: String?
    var userProfileController: UserProfileVC?
    
    let tabGradientView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.alpha = 1
        return view
    }()
    
    
    // MARK: - Init
       
       override func viewDidLoad() {
           super.viewDidLoad()

        //extends the edges beyound the tab bar
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true

        // uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        collectionView.backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 240)
        
        // register cell classes
        self.collectionView!.register(AdminStorePostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // configure refresh control
        let refreshFeedControl = UIRefreshControl()
        refreshFeedControl.addTarget(self, action: #selector(handleFeedRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshFeedControl
        
        configureNavigationBar()
        
        fetchPosts()
        
        //setUserFCMTocken()
        
        configureTabBar()

       }
    
    override func viewDidAppear(_ animated: Bool) {
        // adding shadow view to the tab bar
        tabBarController?.tabBar.isTranslucent = false
        tabBarController?.tabBar.layer.cornerRadius = 15
        tabBarController?.tabBar.layer.masksToBounds = true
        tabBarController?.tabBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        tabBarController?.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    }
    
    
    // MARK: UICollectionViewFlowLayout
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
           let width = view.frame.width
           //var height = width
            var height =  width + 55
           
           height += 55
           height += 65
         
           return CGSize(width: width, height: height)
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
       
            return posts.count
    }
    
    // creates a space between top cell and cell view... right before scrolling is enabled.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //return CGSize(width: view.frame.width, height: 10)
        return CGSize(width: view.frame.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // sets the vertical spacing between photos
        return 20
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AdminStorePostCell
        
        cell.delegate = self
        
            cell.storePost = posts[indexPath.item]
        
        return cell
    }
    
    func fetchPosts() {
        
        print("fetch post function called")
        
        //guard let currentUid = Auth.auth().currentUser?.uid else { return }

        // fetching posts with pagination and only observing x amount of post at a time
        
        if currentKey == nil {
            DataService.instance.REF_ADMIN_STORE_POSTS.queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.collectionView?.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    self.fetchPost(withPostId: postId)
                    
                    print(snapshot)
                })
                self.currentKey = first.key
            })
        } else {
            DataService.instance.REF_ADMIN_STORE_POSTS.queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 6).observeSingleEvent(of: .value, with: { (snapshot) in
                
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
    
    func handlePhotoTapped(for cell: AdminStorePostCell) {
        print("Handle photo tapped")
    }
    
    func handleOptionTapped(for cell: AdminStorePostCell) {
        
        guard let post = cell.storePost else { return }

        if post.ownerUid == Auth.auth().currentUser?.uid {
            
            let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { (_) in
                
                // this entire view controller is unecessary. if this works it will need to be commented out
                post.deletePost()
                
            
                    self.handleFeedRefresh()
           
            }))
            
            alertController.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { (_) in
                
                let uploadPostController = UploadStorePostVC()
                let navigationController = UINavigationController(rootViewController: uploadPostController)
                uploadPostController.postToEdit = post
                uploadPostController.uploadAction = UploadStorePostVC.UploadAction(index: 1)
                self.present(navigationController, animated: true, completion: nil)
                
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // helper function
    func fetchPost(withPostId postId: String) {
        
        Database.fetchStorePost(with: postId) { (post) in
            self.posts.append(post)
            
            self.posts.sort(by: { (post1, post2) -> Bool in
                return post1.creationDate > post2.creationDate
            })
            self.collectionView?.reloadData()
        }
    }
    
    // don't think I need to reapply this token because it appears to be strictly for messaging. will revisit
    func setUserFCMTocken() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let fcmToken = Messaging.messaging().fcmToken else { return }
        
        let values = ["fcmToken": fcmToken]
        
        DataService.instance.REF_USERS.child(currentUid).updateChildValues(values)
    }
    
    func configureNavigationBar() {
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
         
        let font = UIFont(name: "HelveticaNeue-Bold", size: 17)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)]

        navigationItem.title = "Admin Posts"
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
    
    
    
   
    @objc func handleFeedRefresh() {
        // this is a screen pull down function to refresh you feed

        posts.removeAll(keepingCapacity: false)
        self.currentKey = nil
        fetchPosts()
        collectionView?.reloadData()
    }
       

}

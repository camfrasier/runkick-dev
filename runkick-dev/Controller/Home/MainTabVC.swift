//
//  MainTabVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/19/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

class MainTabVC: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Properties
    
    let dot = UIView()
    var notificationIdArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Mark: - Delagate
        self.delegate = self
        
        // Tab bar tint color
        //tabBar.tintColor = UIColor.rgb(red: 242, green: 96, blue: 98)
        tabBar.tintColor = UIColor.rgb(red: 243, green: 78, blue: 92)
        tabBar.unselectedItemTintColor = UIColor.rgb(red: 0, green: 0, blue: 0)
                
        
        /*
        self.tabBar.isTranslucent = false
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.masksToBounds = true
        self.tabBar.backgroundColor = .clear
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        */
        
        // call view controllers
        configureViewControllers()
        
        
        // observe notifications
        // observeNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 60
        tabBar.frame.origin.y = view.frame.height - 60
    }

    // Function to create view controllers that exist within tab bar controller
    func configureViewControllers() {
        
        // if user is storeadmin we can replace the photo find to the slider view for points, the home map will remain the feed will remain with no options to comment. the search will be replaced by store menu and photos.
        

        // Mark: - Home map controller
        //let homeVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeVC())
        
        // maybe have the below images get smaller when they are unselected.. and can change the tint color
        
        // Mark: - Main feed controller
        let feedVC = constructNavController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, title: "EXPLORE", rootViewController: FeedVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let userFeedVC = constructNavController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, title: "User Posts", rootViewController: UserSpecificFeedVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // Mark: - marketplace controller placeholder
        let marketplaceVC = constructNavController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, title: "MENU", rootViewController: MarketplaceVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // Mark: - Notification controller
        let notificationsVC = constructNavController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, title: "Updates", rootViewController: NotificationsVC())
        
        // Mark: - Profile controller
        let userProfileVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), title: "ME", rootViewController: UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // Mark: - Search feed controller
        let searchVC = constructNavController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, title: "Find", rootViewController: SearchVC())
        
        // Mark: - home feed controller
        let homeVC = constructNavController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, title: "MAP", rootViewController: HomeVC())
        
        let categoryFeedVC = constructNavController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, title: "User Posts", rootViewController: CategoryFeedVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // Mark: - Upload image controller
        //let selectImageVC = constructNavController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, title: "Photo")
        
        //viewControllers = [homeVC, feedVC, marketplaceVC, notificationsVC, searchVC]
        viewControllers = [homeVC, marketplaceVC, feedVC, userProfileVC]
        
    
        // configure notification dot
        configureNotificationDot()

        // observe notifications with delay to prevent fire auth errors.. temporary while troubleshooting slide menu
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.observeNotifications()
        })
        
    }
    
    // MARK: - Handlers

    // Construct navigation controllers
    func constructNavController(unselectedImage: UIImage, selectedImage: UIImage, title: String, rootViewController: UIViewController = UIViewController ()) -> UINavigationController {
        
        // Mark: Construct Nav controller
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.tabBarItem.title = title
        
        
        return navController
    }
    
    func configureNotificationDot() {
        
        // need to write code out to determine what ios device we are using. basically creating the dot frame
        
        if UIDevice().userInterfaceIdiom == .phone {
            
            let tabBarHeight = tabBar.frame.height
            
            if UIScreen.main.nativeBounds.height == 2436 {
                // configure dot for iphone x
                dot.frame = CGRect(x: view.frame.width / 5 * 3, y: view.frame.height - tabBarHeight, width: 6, height: 6)
            
            } else if UIScreen.main.nativeBounds.height == 1792 {
                
                dot.frame = CGRect(x: view.frame.width / 5 * 3, y: view.frame.height - tabBarHeight, width: 6, height: 6)

            } else {
                // configure dot for other phone models
                dot.frame = CGRect(x: view.frame.width / 5 * 3, y: view.frame.height - 16, width: 6, height: 6)
            }
            
            // now here we are creating the actual notification dot. multiply by index 3 in the tab bar
            dot.center.x = (view.frame.width / 5 * 3 + (view.frame.width / 5) / 2)
            dot.backgroundColor = UIColor(red: 233/255, green: 30/255, blue: 99/255, alpha: 1)
            dot.layer.cornerRadius = dot.frame.width / 2
            self.view.addSubview(dot)
            dot.isHidden = true
        }
    }
    
    // MARK: - UITableBarController
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.firstIndex(of: viewController)
        
        // will need to go back and clean this up for another index value later.
        if index == 10 {
            
            let selectImageVC = SelectImageVC(collectionViewLayout: UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: selectImageVC)
            navController.modalPresentationStyle = .fullScreen
            navController.navigationBar.tintColor = UIColor(red: 60/255, green: 124/255, blue: 222/255, alpha: 1)
            
            present(navController, animated: true, completion: nil)
            
            return false
            
        } else if index == 3 {
            // hides the red notification dot
            dot.isHidden = true
            return true
        }
        return true
    }
    
    // MARK: - API
    
    func observeNotifications() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        self.notificationIdArray.removeAll()
        
        DataService.instance.REF_NOTIFICATIONS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in

            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.forEach({ (snapshot) in
                
                let notificationId = snapshot.key
                
                DataService.instance.REF_NOTIFICATIONS.child(currentUid).child(notificationId).child("checked").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let checked = snapshot.value as? Int else { return }
                    
                    if checked == 0 {
                        self.dot.isHidden = false
    
                    } else {
                        self.dot.isHidden = true
                    }
                })
            })
        }
    }
}



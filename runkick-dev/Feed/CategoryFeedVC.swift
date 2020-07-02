//
//  CategoryFeedVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 5/11/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class CategoryFeedVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, CategoryFeedCellDelegate {

    //var categories = [MarketCategory]() // This need to be a variable so we can mutate it.
    //var category: MarketCategory?
    var currentKey: String?
    var selectedCategory: String?
    var posts = [Category]() // This need to be a variable so we can mutate it.
    var post: MarketCategory?
    
    var shoppingCartButton = UIButton(type: UIButton.ButtonType.custom)
    
    /*
    let shoppingCartButton: UIButton = {
     let button = UIButton(type: UIButton.ButtonType.custom)
     //button.setImage(UIImage(named: "simpleCartLimer"), for: .normal)
     button.setImage(UIImage(named: "trueBlueCircle"), for: .normal)
     button.addTarget(self, action: #selector(handleShoppingCart), for: .touchUpInside)
     button.backgroundColor = .clear
     button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
     button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
     button.layer.shadowRadius = 5.0
     button.layer.shadowOffset = CGSize(width: 0, height: 3)
     button.alpha = 1
     return button
    }()
    
    let beBoppShoppingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "beBoppShoppingCart"), for: .normal)
        button.addTarget(self, action: #selector(handleShoppingCart), for: .touchUpInside)
        button.backgroundColor = .clear
     button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
     button.layer.shadowColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 0.75).cgColor
     button.layer.shadowRadius = 4.0
     button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.alpha = 1
        return button
    }()
    */
    
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
        
        //print("THIS SHOULD BE THE CORRECT CATEGORY \(post?.category)")
        
        
        
        /*
        //extends the edges beyound the tab bar
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true
        */
        
        //collectionView.backgroundColor = UIColor.rgb(red: 181, green: 201, blue: 215)
        collectionView.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 250)
        
        // register cell classes
        self.collectionView!.register(CategoryFeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // configure refresh control
        let refreshFeedControl = UIRefreshControl()
        refreshFeedControl.addTarget(self, action: #selector(handleFeedRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshFeedControl
        
        configureNavigationBar()

        //fetchPosts()
        
        guard let category = post?.category else { return }
        selectedCategory = post?.category
        fetchCategory(withCategory: selectedCategory!)
        
        print("SELECTED CATEGORY \(selectedCategory)")
                
        //updateUserFeeds()
            
        configureTabBar()
        
        //configureViewComponents()
    }
    
    // MARK: UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width - 170
        
        height += 40
        
        return CGSize(width: width, height: height)
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if posts.count > 4 {
            if indexPath.item == posts.count - 1 {
                
                //guard let category = post?.category else { return }
                fetchCategory(withCategory: selectedCategory!)
                //fetchPosts()
            }
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
            return posts.count
    }
    
    // creates a space between top cell and cell view... right before scrolling is enabled.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // sets the vertical spacing between photos
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryFeedCell
        
        // don't forget to add the delegate value in order to delegate communication from the VC to the cell class
        cell.delegate = self
        
        cell.categoryPost = posts[indexPath.item]
        
        return cell
    }
    
    
    func handlePhotoTapped(for cell: CategoryFeedCell) {
             
             print("THIS SHOULD TAKE US TO THE PROPER POST Store item selection VC")
             guard let post = cell.categoryPost else { return }
             let storeItemSelectionVC = StoreItemSelectionVC(collectionViewLayout: UICollectionViewFlowLayout())
             
             // sending this postId over to the comment view controller
        storeItemSelectionVC.categoryPost = post
             navigationController?.pushViewController(storeItemSelectionVC, animated: true)
    }
    
    func handleRedeemAddToCart(for cell: CategoryFeedCell, category: Category?) {
        print("handle redeem cart")
        StripeCart.addItemToCart(item: category!)
    }
     
    func configureNavigationBar() {
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
         
        let font = UIFont(name: "HelveticaNeue-Bold", size: 17)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)]

        //navigationItem.title = "Category"
        navigationItem.title = post?.category
        
        navigationController?.navigationBar.tintColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        
        
        
        // configure shopping cart button.. need to clean up code
        
        //let customNotificationsButton = UIButton(type: UIButton.ButtonType.system)
        shoppingCartButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            
        //using this code to show the true image without rendering color
        shoppingCartButton.setImage(UIImage(named:"shoppingCart")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
        //let shoppingCartButton = UIButton(type: UIButton.ButtonType.custom)

        shoppingCartButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 27, height: 27 )
        shoppingCartButton.addTarget(self, action: #selector(handleShoppingCartView), for: .touchUpInside)
        shoppingCartButton.tintColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        shoppingCartButton.backgroundColor = .clear

        let shoppingCart = UIBarButtonItem(customView: shoppingCartButton)
        self.navigationItem.rightBarButtonItems = [shoppingCart]
        
    }
    
    /*
    func fetchPosts() {
        
        print("fetch post function called")
        
        //guard let currentUid = Auth.auth().currentUser?.uid else { return }

        // fetching posts with pagination and only observing x amount of post at a time
        
        if currentKey == nil {
            DataService.instance.REF_CATEGORIES.queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.collectionView?.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    //print("DEBUG: THIS WILL BE THE POST ID \(postId)")
                    
                    self.fetchPost(withPostId: postId)
                    
                    
                })
                self.currentKey = first.key
                print("THIS IS THE CURRENT KEY\(first.key)")
            })
        } else {
            DataService.instance.REF_CATEGORIES.queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 6).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    if postId != self.currentKey {
                        self.fetchPost(withPostId: postId)
                    }
                })
                self.currentKey = first.key
                
                print("THIS IS THE SECOND CURRENT KEY\(first.key)")
            })
        }
    }
    */
    
    func fetchCategory(withCategory category: String) {
        
        DataService.instance.REF_CATEGORIES.observeSingleEvent(of: .value) { (snapshot) in
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.forEach({ (snapshot) in
                let key = snapshot.key
                
                DataService.instance.REF_CATEGORIES.child(key).child("category").observeSingleEvent(of: .value) { (snapshot) in
                guard let categoryValue = snapshot.value as? String else { return }
                
                    // finds the specific key values that are relevant to the category picked
                if categoryValue.contains(category){   // will need to make this case insensitive
                    print("THIS iS THE KEY FOR THIS SPECIFIC CATEGORY\(key)")
                    self.fetchPostByCategory(withCategoryKey: key)
                
            }
        
        }
            })
        }
    }
    
    func fetchPostByCategory(withCategoryKey categoryKey: String) {

               if currentKey == nil {
                
                print("THE CURRENT KEY IS NIL DOGG!!!!!!!")
                DataService.instance.REF_CATEGORIES.queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                       
                       self.collectionView?.refreshControl?.endRefreshing()
                       
                       guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                     //  guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                       
                     //  allObjects.forEach({ (snapshot) in
  
                           //let postId = snapshot.key
                        let postId = categoryKey
                           print("DEBUG: THIS WILL BE THE POST ID \(postId)")
                           
                           self.fetchPost(withPostId: postId)
   
                      // })
                    self.currentKey = first.key
                    print("THIS IS THE CURRENT KEY\(first.key)")
                    
                   })
               } else {
                DataService.instance.REF_CATEGORIES.queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 6).observeSingleEvent(of: .value, with: { (snapshot) in
                       
                     print("THE CURRENT KEY IS NIL SO now we are HEEEEEEERE")
                    
                       guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                       guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                       
                        //starting the order at the current key we get the snapshot which should represent the current key value of the last post in the previous section, if the post ID is not the currentKey or first key established then fetch the postID of the next post and so on until we reach the last key of the last post in the second pack of photos.
                    
                           let postId = snapshot.key
                           //let postId = categoryKey
                           if postId != self.currentKey {
                               self.fetchPost(withPostId: postId)
                           }

                    /*
                    allObjects.forEach({ (snapshot) in
                        let postId = snapshot.key
                        if postId != self.currentKey {
                            self.fetchPost(withPostId: postId)
                        }
                    })
                    */
                    
                       self.currentKey = first.key
                   })
               }
        
    }
    
    // helper function
    func fetchPost(withPostId postId: String) {
        
        //print("DEBUG: POSTID IS\(postId)")
        
        Database.fetchCategoryPosts(with: postId, completion: { (post) in

            self.posts.append(post)
            
            self.posts.sort(by: { (post1, post2) -> Bool in
                return post1.creationDate > post2.creationDate
            })
            self.collectionView?.reloadData()
        })
         
    }
    
    func configureTabBar() {
        
        // removing shadow from tab bar
        tabBarController?.tabBar.layer.shadowRadius = 0
        tabBarController?.tabBar.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        
        /*
        // adding shadow view to the tab bar
        tabBarController?.tabBar.isTranslucent = true
        tabBarController?.tabBar.barTintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        //tabBarController?.tabBar.layer.cornerRadius = 15
        tabBarController?.tabBar.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        tabBarController?.tabBar.layer.borderWidth = 1
        tabBarController?.tabBar.layer.masksToBounds = true
        tabBarController?.tabBar.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        tabBarController?.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        collectionView.addSubview(tabGradientView)
        tabGradientView.anchor(top: nil, left: collectionView.leftAnchor, bottom: collectionView.bottomAnchor, right: collectionView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
        */
    }
    
    func configureViewComponents() {
        //collectionView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        collectionView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        let tabBarHeight = CGFloat((tabBarController?.tabBar.frame.size.height)!)
        
        /*
        view.addSubview(shoppingCartButton)
        shoppingCartButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: tabBarHeight + 20, paddingRight: 20, width: 60, height: 60)
        
        shoppingCartButton.addSubview(beBoppShoppingButton)
        beBoppShoppingButton.anchor(top: shoppingCartButton.topAnchor, left: shoppingCartButton.leftAnchor, bottom: nil, right: nil, paddingTop: 9, paddingLeft: 6.5, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        */
        
    }
    
    @objc func handleShoppingCartView() {
        print("Handle shopping cart view")
        
             //guard let post = cell.categoryPost else { return }
             let checkoutVC = CheckoutVC()
             
             // sending this postId over to the comment view controller
        //checkoutVC.categoryPost = post
             navigationController?.pushViewController(checkoutVC, animated: true)
    }

    

    
    @objc func handleFeedRefresh() {
        // this is a screen pull down function to refresh you feed

        posts.removeAll(keepingCapacity: false)
        self.currentKey = nil
        //fetchPosts()
        fetchCategory(withCategory: selectedCategory!)
        collectionView?.reloadData()
    }
}

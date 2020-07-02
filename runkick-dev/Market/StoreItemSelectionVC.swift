//
//  StoreItemSelectionVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/20/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class StoreItemSelectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, StoreItemSelectionCellDelegate {
    
    
    lazy var addToCartLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        // add gesture recognizer
        label.text = "ADD TO CART"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        let messageTap = UITapGestureRecognizer(target: self, action: #selector(handleAddToCart))
        messageTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(messageTap)
        return label
    }()
    
    lazy var shadowBackground: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        let messageTapped = UITapGestureRecognizer(target: self, action: #selector(handleAddToCart))
        messageTapped.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(messageTapped)
        return view
    }()
    
    lazy var addToCarButtonBackground: GradientActionView = {
        let view = GradientActionView()
        let messageTapped = UITapGestureRecognizer(target: self, action: #selector(handleAddToCart))
        messageTapped.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(messageTapped)
        return view
    }()
    
    var shoppingCartButton = UIButton(type: UIButton.ButtonType.custom)
    
    
    var posts = [Category]() 
    //var categoryPost: Category?
        var categoryPost: Category!
    {
        
        didSet {  // Did set here means we are going to be setting the user for our header in the controller file UserProfileVC.
                   
                   // Configure edit profile button
                   fetchStoreItemData()
                 
                   //guard let profileImageUrl = user?.profileImageURL else { return }  // Unwrapping this safely. Use in other functions as well.
                   //profileImageView.loadImage(with: profileImageUrl)
               }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 250)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(StoreItemSelectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        configureNavigationBar()
        
        configureViewComponents()
        
        configureTabBar()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureTabBar()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
        let width = view.frame.width
        var height = width + 15
        height += 100
        
        return CGSize(width: width, height: height)
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StoreItemSelectionCell
        
        cell.delegate = self
        
        // Configure the cell
        //cell.categoryPost = posts[indexPath.item]
        
        
         let post = self.categoryPost
         cell.categoryPost = post
         

        
        return cell
    }
    
    func handleItemTapped(for cell: StoreItemSelectionCell) {
        print("tapped photo")
    }
    
    func fetchStoreItemData() {
        
        guard let storeId = categoryPost?.storeId else { return }
        print ("THIS IS THE STORE ID \(storeId)")
        
        // Set the user in header.
        
        //fetch specific item data under the selected item using the store id
        
        /*
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USERS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            
            guard let profileImageUrl = user.profileImageURL else { return }
            self.profileImageView.loadImage(with: profileImageUrl)
        }
        */
    }
    
    func configureNavigationBar() {
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
         
        let font = UIFont(name: "HelveticaNeue-Bold", size: 17)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)]

        guard let poppPrice = categoryPost?.poppPrice else { return }
        //navigationItem.title = "Category"
        navigationItem.title = convertToCurrency(poppPrice)
        
        navigationController?.navigationBar.tintColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        
        
        // custom notifications button
                
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
    
    func configureViewComponents() {
        
        view.addSubview(shadowBackground)
        shadowBackground.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 150, height: 45)
        shadowBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shadowBackground.layer.cornerRadius = 23
        
        shadowBackground.addSubview(addToCarButtonBackground)
        addToCarButtonBackground.anchor(top: shadowBackground.topAnchor, left: shadowBackground.leftAnchor, bottom: shadowBackground.bottomAnchor, right: shadowBackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 130, height: 45)
        addToCarButtonBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addToCarButtonBackground.layer.cornerRadius = 22
        
        addToCarButtonBackground.addSubview(addToCartLabel)
        addToCartLabel.anchor(top: addToCarButtonBackground.topAnchor, left: addToCarButtonBackground.leftAnchor, bottom: addToCarButtonBackground.bottomAnchor, right: addToCarButtonBackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func configureTabBar() {
        
        // removing shadow from tab bar
        tabBarController?.tabBar.layer.shadowRadius = 0
        tabBarController?.tabBar.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
    }
    
    @objc func handleAddToCart() {
        print("Handle add to cart here")
        
        // instead of using categoryPost I may have to use product struct and then go on..
        StripeCart.addItemToCart(item: categoryPost)
        
    }
    
    @objc func handleShoppingCartView() {
        print("Handle shopping cart view")
        
             //guard let post = cell.categoryPost else { return }
             let checkoutVC = CheckoutVC()
             
             // sending this postId over to the comment view controller
        //checkoutVC.categoryPost = post
             navigationController?.pushViewController(checkoutVC, animated: true)
    }
}

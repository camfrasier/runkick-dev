//
//  MarketplaceVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/19/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "MarketplaceCell"

class MarketplaceVC: UICollectionViewController {

    // MARK: - Properties
    
    
    
    

    let shoppingCartButton: UIButton = {
     let button = UIButton(type: UIButton.ButtonType.custom)
     button.setImage(UIImage(named: "actionButton"), for: .normal)
     //button.setImage(UIImage(named: "trueBlueCircle"), for: .normal)
     button.addTarget(self, action: #selector(handleShoppingCart), for: .touchUpInside)
     button.backgroundColor = .clear
     button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
     button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
     button.layer.shadowRadius = 5.0
     button.layer.shadowOffset = CGSize(width: 0, height: 3)
     button.alpha = 1
     return button
    }()
    
    lazy var simpleCartShadowBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.actionRed()
        let menuTap = UITapGestureRecognizer(target: self, action: #selector(handleShoppingCart))
        menuTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(menuTap)
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.55).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.alpha = 1
        return view
    }()
    
    let shoppingCartBackground: GradientActionView = {
        let view = GradientActionView()
        //view.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.55).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.isUserInteractionEnabled = true
        let shoppingCartTap = UITapGestureRecognizer(target: self, action: #selector(handleShoppingCart))
        shoppingCartTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(shoppingCartTap)
        view.alpha = 1
        return view
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
    
    let timelineBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
        view.alpha = 1
        return view
    }()
  
    var categories = [MarketCategory]()
    var filteredCategories = [MarketCategory]()
    var searchBar: UISearchBar!
    var inSearchMode = false
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        //extends the edges beyound the tab bar
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true
        */
        
        configureViewComponents()
        
        configureNavigationaBar()
        
        configureTabBar()
            
        collectionView.register(MarketplaceCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        fetchStores()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
           
        configureTabBar()
        configureNavigationaBar()
    }
    
    // MARK: - Selectors
    
    @objc func showSearchBar() {
        configureSearchBar()
    }
    
    // MARK: - API
    
    
    
    func fetchStores() {
        DataService.instance.REF_MARKETPLACE.observeSingleEvent(of: .value) { (snapshot) in
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.forEach({ (snapshot) in
                let categoryId = snapshot.key
                Database.fetchCategory(with: categoryId, completion: { (category) in
                    DispatchQueue.main.async {
                        
                        self.categories.append(category)
                        self.collectionView.reloadData()
                        //print(snapshot)
                    }
                })
            })
        }
    }
    
    // MARK: - Helper Functions
    
    func configureSearchBar() {
        
        // using the searchbar constructor
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search"
        searchBar.autocapitalizationType = .none
        searchBar.becomeFirstResponder()
        searchBar.tintColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        
        // SearchBar text
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor.red
        textFieldInsideUISearchBar?.font = textFieldInsideUISearchBar?.font?.withSize(22)
        
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            searchBar.searchTextField.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
            searchBar.searchTextField.layer.cornerRadius = 0
            searchBar.searchTextField.layer.masksToBounds = true
        } else {
            // Fallback on earlier versions
        }
            
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = searchBar
    }
    
    func configureSearchBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.rgb(red: 100, green: 100, blue: 100)
    }
    
    func configureViewComponents() {
        //collectionView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        collectionView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        //let tabBarHeight = CGFloat((tabBarController?.tabBar.frame.height)!)
        
        view.addSubview(simpleCartShadowBackground)
        simpleCartShadowBackground.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 20, width: 60, height: 60)
        simpleCartShadowBackground.layer.cornerRadius = 15
        
        simpleCartShadowBackground.addSubview(shoppingCartBackground)
        shoppingCartBackground.anchor(top: simpleCartShadowBackground.topAnchor, left: simpleCartShadowBackground.leftAnchor, bottom: simpleCartShadowBackground.bottomAnchor, right: simpleCartShadowBackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        shoppingCartBackground.layer.cornerRadius = 15
        
        shoppingCartBackground.addSubview(beBoppShoppingButton)
        beBoppShoppingButton.anchor(top: shoppingCartBackground.topAnchor, left: shoppingCartBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 9, paddingLeft: 6.5, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        // configure search bar button
        configureSearchBarButton()
        
    }
    
    func configureNavigationaBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        //navigationController?.navigationBar.barTintColor = UIColor(red: 187/255, green: 216/255, blue: 224/255, alpha: 1)
        //navigationController?.navigationBar.barTintColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

              //UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
        
              let font = UIFont(name: "HelveticaNeue-Bold", size: 17)!
              self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)]

        
        navigationController?.navigationBar.tintColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        navigationItem.title = "Marketplace"

        //let font = UIFont(name: "Helvetica", size: 17)!
        //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
        
        navigationController?.navigationBar.addSubview(timelineBarView)
        timelineBarView.anchor(top: navigationController?.navigationBar.bottomAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: nil, right: navigationController?.navigationBar.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
  
    }
    
    func configureTabBar() {
        // removing shadow from tab bar
         tabBarController?.tabBar.layer.shadowRadius = 0
        tabBarController?.tabBar.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
    }
    
    @objc func handleShoppingCart() {
        print("handle shopping cart")
    }
}

// MARK: - UISearchBarDelegate

extension MarketplaceVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        navigationItem.titleView = nil
        configureSearchBarButton()
        inSearchMode = false
        collectionView.reloadData()
    }
     
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // text printing out the text real time
        print(searchText)
        
        if searchText == "" || searchBar.text == nil {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            // whatever pokemon we are looking at look at there name and see if there name contains that search text, here $0 represnts any categories array
            filteredCategories = categories.filter({ $0.category?.range(of: searchText) != nil
                
                return ($0.category?.localizedCaseInsensitiveContains(searchText))!
            })
            collectionView.reloadData()

        }
    }
}


// MARK: - UICollectionViewDataSource/Delegate
 
extension MarketplaceVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //shorthand if statement.. if in searchmode is true, return filtered categories else return the original catergories count
        return inSearchMode ? filteredCategories.count : categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MarketplaceCell
        
        cell.categoryPost = inSearchMode ? filteredCategories[indexPath.row] : categories[indexPath.row]
        
        // where we define each one of our cells in our collection view
        //cell.categoryPost = categories[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //categories
        //let post = categories[indexPath.item]
        
        //guard let category = post.category else { return }
        
        
        
        // i need to send this category to the next view.. in order to determine which feed should be shown
        
        let categoryFeedVC = CategoryFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        categoryFeedVC.post = categories[indexPath.item]
        navigationController?.pushViewController(categoryFeedVC, animated: true)
        
        
        print("DEBUG: Here is the post value\(categoryFeedVC.post)")
        /*
         
         let feedVC = FeedVC(collectionViewLayout: UICollectionViewFlowLayout())
         
         feedVC.viewSinglePost = true
         
         feedVC.post = posts[indexPath.item]
         
         navigationController?.pushViewController(feedVC, animated: true)
         */
        
    }
}

// extension to create the marketplace cell size for squares
extension MarketplaceVC: UICollectionViewDelegateFlowLayout {
    
    // calling function to give space and insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 36) / 2
        //let width = (view.frame.width - 26) / 2
        return CGSize(width: width, height: width)
    }
    
}

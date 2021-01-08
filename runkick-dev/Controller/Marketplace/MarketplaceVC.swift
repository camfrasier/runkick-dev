//
//  MarketplaceVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/14/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "MarketplaceCell"
private let reuseTableIdentifier = "CategoryCell"

class MarketplaceVC: UITableViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Mark: - Properties
    
    var categories = [MarketCategory]()
    var filteredCategories = [MarketCategory]()
    var searchBar = UISearchBar()
    var inSearchMode = false
    var titleView: UIView!
    var collectionView: UICollectionView!
    var collectionViewEnabled = true
    
    var currentKey: String?
    var userCurrentKey: String?
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Eat"
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        label.font = UIFont(name: "PingFangTC-Semibold", size: 28)
        return label
    }()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure search bar
        configureSearchBar()

        // register cell classes
        tableView.register(CategoriesCell.self, forCellReuseIdentifier: reuseTableIdentifier)
        
        tableView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)

        // configure collection view
        configureCollectionView()
        
        // configure refresh control
        configureRefreshControl()
        
        //configureNavigationBar
        configureNavigationBar()
        
        configureTabBar()
        
        // fetch stores
        fetchStores()
    }
    
    // this function ensures the navigation bar is filled after transitioning to a regular nav bar
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           
        configureTabBar()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredCategories.count
        } else {
            return categories.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if categories.count > 20 {
            if indexPath.item == categories.count - 1 {
                fetchCategories()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       print("item selected")
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let categoryFeedVC = CategoryFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        categoryFeedVC.post = categories[indexPath.item]
        navigationController?.pushViewController(categoryFeedVC, animated: true)
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseTableIdentifier, for: indexPath) as! CategoriesCell
        
        cell.categoryPost = inSearchMode ? filteredCategories[indexPath.row] : categories[indexPath.row]
        
        return cell
    }
    
    
    // MARK: - UICollectionView
    
    func configureCollectionView() {
        
        // define the collection view characteristics
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white //.red
        
        collectionView.addSubview(titleLabel)
        titleLabel.anchor(top: collectionView.topAnchor, left: collectionView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        tableView.addSubview(collectionView)
        collectionView.register(MarketplaceCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        tableView.separatorColor = .clear
        
        //tableView.separatorInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //return UIEdgeInsets(top: 60, left: 16, bottom: 0, right: 16)
        return UIEdgeInsets(top: 60, left: 4, bottom: 0, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        /*
        //let width = (view.frame.width - 16) / 3
        let width = (view.frame.width - 24) / 2
        return CGSize(width: width, height: width)
        */
        
        let width = (view.frame.width - 12) / 2
        return CGSize(width: width, height: width - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if categories.count > 20 {
            if indexPath.item == categories.count - 1 {
                fetchStores()
            }
        }
        
    }
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        
        return CGSize(width: view.frame.width, height: 50)
    }
    */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MarketplaceCell
        
        cell.categoryPost = categories[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let categoryFeedVC = CategoryFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        categoryFeedVC.post = categories[indexPath.item]
        navigationController?.pushViewController(categoryFeedVC, animated: true)
        
        
        print("DEBUG: Here is the post value\(categoryFeedVC.post)")
    }
    

    
    // MARK: - Handlers
    
    func configureSearchBar() {
        
        //let navBarHeight = CGFloat((navigationController?.navigationBar.frame.size.height)!)

        
        searchBar.delegate = self
        
        titleView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
       // let frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        //let titleView = UIView(frame: frame)
        //searchBar.backgroundImage = UIImage()
        //searchBar.frame = frame
        titleView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        titleView.addSubview(searchBar)
        searchBar.anchor(top: titleView.topAnchor, left: titleView.leftAnchor, bottom: titleView.bottomAnchor, right: titleView.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.frame.width - 35, height: 40)
        
        navigationItem.titleView = titleView
        
        
        //navigationItem.titleView = searchBar
        
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        searchBar.autocapitalizationType = .none
        
        //searchBar.backgroundColor = .blue
        
        
        // SearchBar text
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        //textFieldInsideUISearchBar?.textColor = UIColor.red
        textFieldInsideUISearchBar?.font = textFieldInsideUISearchBar?.font?.withSize(18)
        
        /*
        if let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField,
               let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {

                   //Magnifying glass
                   glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
                   glassIconView.tintColor = .white
           }
        */
        
        //navigationItem.titleView = searchBar
        //searchBar.barTintColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        searchBar.isTranslucent = false
        searchBar.tintColor = UIColor.rgb(red: 0, green: 0, blue: 0) // changes the text
        searchBar.alpha = 1
        
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            //searchBar.searchTextField.backgroundColor = UIColor.rgb(red: 181, green: 201, blue: 215)
            searchBar.searchTextField.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
            searchBar.searchTextField.layer.cornerRadius = 0
            searchBar.searchTextField.layer.masksToBounds = true
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 12)!], for: .normal)
            
        } else {
            // Fallback on earlier versions
        }
        //searchBar.searchTextField.layer.borderColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1).cgColor
        //searchBar.searchTextField.layer.borderWidth = 0.25
        
        /*
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = searchBar
        */
        
        //navigationItem.titleView = nil
    }
    
    func configureNavigationBar() {
        
        //view.addSubview(navigationController!.navigationBar)
        
        //navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        //navigationController?.navigationBar.barTintColor = UIColor.walkzillaRed()
        
        // add or remove nav bar bottom border
        navigationController?.navigationBar.shadowImage = UIImage()
        let lineView = UIView(frame: CGRect(x: 0, y: 45, width: view.frame.width, height: 0.25))
        lineView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        /*
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
        
        let font = UIFont(name: "HelveticaNeue", size: 17)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)]
        navigationItem.title = "Search"
        */
        
        navigationController?.navigationBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
 
        configureSearchBarButton()
        
    }
    
    func configureTabBar() {
        // removing shadow from tab bar
         tabBarController?.tabBar.layer.shadowRadius = 0
        tabBarController?.tabBar.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        
        // use this to thin or remove tab bar top border
        tabBarController?.tabBar.shadowImage = UIImage()
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: -1))
        lineView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        tabBarController?.tabBar.addSubview(lineView)
        
        let thinLineView = UIView(frame: CGRect(x: 0, y: -1, width: view.frame.width, height: 0.25))
        thinLineView.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220)
        lineView.addSubview(thinLineView)
    }
    
    
    
    
    @objc func handleBackButton() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleReturnMap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handlePhotoButton() {
        print("handle photo and caption button")
        
        let selectImageVC = SelectImageVC(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: selectImageVC)
        navController.modalPresentationStyle = .fullScreen
        navController.navigationBar.tintColor = .black
        
        present(navController, animated: true, completion: nil)
    }
    
    // MARK: - UISearchBar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //searchBar.showsCancelButton = true
        
        //self.navigationItem.leftBarButtonItems = nil

        
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        } else {
            // Fallback on earlier versions
        }
        
        
        //fetchUsers()
        
        // hide collection view when we run this function
        //collectionView.isHidden = true
        //collectionViewEnabled = false
        
        //tableView.separatorColor = .clear
    }
    
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            // text printing out the text real time
            print(searchText)
            
            
            if searchText == "" || searchBar.text == nil {
                inSearchMode = false
                tableView.reloadData()
                view.endEditing(true)
            } else {
                inSearchMode = true
                // whatever pokemon we are looking at look at there name and see if there name contains that search text, here $0 represnts any categories array
                filteredCategories = categories.filter({ $0.category?.range(of: searchText) != nil
                    
                    return ($0.category?.localizedCaseInsensitiveContains(searchText))!
                })
                tableView.reloadData()

            }
            
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        
        searchBar.showsCancelButton = false
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        } else {
            // Fallback on earlier versions
        }
        
        inSearchMode = false
        
        searchBar.text = nil
        
        collectionViewEnabled = true
        collectionView.isHidden = false
        
        // added stuff
        navigationItem.titleView = nil
        configureSearchBarButton()
        
        tableView.separatorColor = .clear
        
        tableView.reloadData()
    }
    
    // MARK: - Handlers
    
    @objc func handleRefresh() {
        categories.removeAll(keepingCapacity: false)
        self.currentKey = nil
        fetchStores()
        collectionView?.reloadData()
    }
    
    func configureRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.tableView?.refreshControl = refreshControl
    }
    
    // MARK: - API
    /*
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
    */
    
    
    /*
    func fetchStores() {

        if userCurrentKey == nil {
            DataService.instance.REF_MARKETPLACE.queryLimited(toLast: 4).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let categoryId = snapshot.key
                    
                    Database.fetchCategory(with: categoryId, completion: { (category) in
                        self.categories.append(category)
                        self.collectionView.reloadData()
                    })
                })
                self.userCurrentKey = first.key
            }
        } else {
            DataService.instance.REF_MARKETPLACE.queryOrderedByKey().queryEnding(atValue: userCurrentKey).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let categoryId = snapshot.key
                    
                    if categoryId != self.userCurrentKey {
                        Database.fetchCategory(with: categoryId, completion: { (category) in
                            self.categories.append(category)
                            self.collectionView.reloadData()
                        })
                    }
                })
                self.userCurrentKey = first.key
            })
        }
    }
 */
    
    func fetchStores() {
        // function to fetch our images and place them in the collection view

        if currentKey == nil {
            
            // initial data pull
            DataService.instance.REF_MARKETPLACE.queryLimited(toLast: 21).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.tableView.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let categoryId = snapshot.key
                    
                    Database.fetchCategory(with: categoryId, completion: { (category) in
                        self.categories.append(category)
                        self.collectionView.reloadData()
                    })
                })
                self.currentKey = first.key
            })
        } else {
            // paginate here
            
            DataService.instance.REF_MARKETPLACE.queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let categoryId = snapshot.key
                    
                    if categoryId != self.currentKey {
                        Database.fetchCategory(with: categoryId, completion: { (category) in
                            self.categories.append(category)
                            self.collectionView.reloadData()
                        })
                    }
                })
                self.currentKey = first.key
                
            })
        }
    }
    
    func fetchCategories() {
        // function to fetch our images and place them in the collection view

        if currentKey == nil {
            
            // initial data pull
            DataService.instance.REF_MARKETPLACE.queryLimited(toLast: 21).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.tableView.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let categoryId = snapshot.key
                    
                    Database.fetchCategory(with: categoryId, completion: { (category) in
                        self.categories.append(category)
                        self.tableView.reloadData()
                    })
                })
                self.currentKey = first.key
            })
        } else {
            // paginate here
            
            DataService.instance.REF_MARKETPLACE.queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let categoryId = snapshot.key
                    
                    if categoryId != self.currentKey {
                        Database.fetchCategory(with: categoryId, completion: { (category) in
                            self.categories.append(category)
                            self.tableView.reloadData()
                        })
                    }
                })
                self.currentKey = first.key
                
            })
        }
    }
    
    func configureSearchBarButton() {
        // configuring titile button
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 320, height: 35)
        button.backgroundColor = .clear
       // button.setTitle("Categories", for: .normal)
       // button.titleLabel?.font =  UIFont(name: "PingFangTC-Semibold", size: 17)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
        navigationItem.titleView = button
        
        searchBar.showsCancelButton = true
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        //navigationItem.rightBarButtonItem?.tintColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        
                   let searchBarText = UIButton(type: UIButton.ButtonType.custom)
                       
                       searchBarText.frame = CGRect(x: 0, y: 0, width: 120, height: 33)
                       
                    searchBarText.setTitle("Search restaurants and healthy cuisines", for: .normal)
                    searchBarText.setTitleColor(UIColor.rgb(red: 80, green: 80, blue: 80), for: .normal)
                    searchBarText.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                       searchBarText.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
                       searchBarText.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
                       searchBarText.backgroundColor = .clear
        
        
                   let magnifyButton = UIButton(type: UIButton.ButtonType.system)
                       
                       magnifyButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                       
                       //using this code to show the true image without rendering color
                       magnifyButton.setImage(UIImage(named:"searchBar")?.withRenderingMode(.alwaysOriginal), for: .normal)
                       magnifyButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 15, height: 16 )
                       magnifyButton.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
        magnifyButton.tintColor = UIColor.rgb(red: 80, green: 80, blue: 80)
                       magnifyButton.backgroundColor = .clear
                        
               
               let searchText = UIBarButtonItem(customView: searchBarText)
            let searchButton = UIBarButtonItem(customView: magnifyButton)
        
               self.navigationItem.leftBarButtonItems = [searchButton, searchText]
        
    }
    
    @objc func showSearchBar() {
        
        
        // hide collectionView will in search mode
        //navigationItem.titleView = searchBar
        
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = nil
        
        //fetchCategories()
        tableView.reloadData()
        
        //fetchStores()
        collectionView.isHidden = true
        collectionViewEnabled = false
    
        configureSearchBar()
    }
    
    
    /*
    func fetchPosts() {
        // function to fetch our images and place them in the collection view

        if currentKey == nil {
            
            // initial data pull
            DataService.instance.REF_POSTS.queryLimited(toLast: 21).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.tableView.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    
                    Database.fetchPost(with: postId, completion: { (post) in
                        self.posts.append(post)
                        self.collectionView.reloadData()
                    })
                })
                self.currentKey = first.key
            })
        } else {
            // paginate here
            
            DataService.instance.REF_POSTS.queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    
                    if postId != self.currentKey {
                        Database.fetchPost(with: postId, completion: { (post) in
                            self.posts.append(post)
                            self.collectionView.reloadData()
                        })
                    }
                })
                self.currentKey = first.key
                
            })
        }
    }
 */
    
}



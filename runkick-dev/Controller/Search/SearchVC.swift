//
//  SearchVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/19/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "SeachUserCell"
private let reusePostCellIdentifier = "SearchPostCell"

class SearchVC: UIViewController, UISearchBarDelegate, SearchCellDelegate, UICollectionViewDelegate {

    
    
    // Mark: - Properties
    
    var users = [User]()
    var filteredUsers = [User]()
    var tableView: UITableView!
    var searchBar = UISearchBar()
    var inSearchMode = false
    var collectionView: UICollectionView!
    var collectionViewEnabled = true
    var posts = [Post]()
    var currentKey: String?
    var userCurrentKey: String?
    var titleView: UIView!
    
    
    lazy var searchFriendsBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        let rewardsTap = UITapGestureRecognizer(target: self, action: #selector(handleSearchFriends))
        rewardsTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(rewardsTap)
        view.alpha = 1
        return view
    }()
    
    lazy var searchGroupsBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        let rewardsTap = UITapGestureRecognizer(target: self, action: #selector(handleSearchGroups))
        rewardsTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(rewardsTap)
        view.alpha = 1
        return view
    }()
    
    let searchFriendsLabel: UILabel = {
        let label = UILabel()
        label.text = "Healthy Options"
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        return label
    }()
    
    let searchGroupsLabel: UILabel = {
        let label = UILabel()
        label.text = "Rewards"
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        return label
    }()
    
    lazy var friendsGroupsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.walkzillaYellow()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Search"
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        label.font = UIFont(name: "PingFangTC-Semibold", size: 28)
        return label
    }()
    
    lazy var destinationTextField: UITextField = {
        let tf = UITextField()
        //tf.placeholder = "Where to?"
        tf.attributedPlaceholder = NSAttributedString(string:"Search", attributes:[NSAttributedString.Key.foregroundColor: UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1)])
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.keyboardType = UIKeyboardType.default
        tf.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0).cgColor
        tf.layer.cornerRadius = 0 //25
        tf.clipsToBounds = true
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(HomeVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        view.isUserInteractionEnabled = true
        return tf
    }()
    
    lazy var cancelSearchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "simpleCancelIcon"), for: .normal)
        button.addTarget(self, action: #selector(handleCancelSearch), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    let searchLineViewVertical: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    /*
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        //cv.register(UserCarouselCell.self, forCellWithReuseIdentifier: reuseCarouselIdentifier)
        return cv
    }()
    */
    enum PostType: String {

        case userPost = "userPost"
        case checkIn = "checkIn"
    }
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureTableView()
        
        configureNavigationBar()
        
        destinationTextField.delegate = self
        
        
        // configure search bar
        configureSearchBar()
        
        fetchUsers()
        
        tableView.separatorStyle = .none
        /*
        
       //setupToHideKeyboardOnTapOnView()

        

        

        //configureCollectionView()
        
        
        

                 
        //configureTabBar()
        
        // fetch posts
        //fetchPosts()
        
        fetchUsers()
        
        // configure refresh control
        configureRefreshControl()
 
 */
    }
   
    
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        //configureNavigationBar()
        
        configureTabBar()
        
    }
    */
    override func viewWillAppear(_ animated: Bool) {
           
        configureTabBar()
        tableView?.reloadData()
    }
    
    // this function ensures the navigation bar is filled after transitioning to a regular nav bar
    /*
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.layoutSubviews()
    }
    */
    
    func handleFollowTapped(for cell: SearchUserCell) {
        print("something happens here when tapped follow / following")
    }
    func configureTableView() {
        
        tableView = UITableView()
        //tableView.rowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        //tableView.separatorColor = .clear
        
        // register cell classes
        tableView.register(SearchUserCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        
        // seperator insets.
        //tableView.separatorInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        
        // giving the top border a bit of buffer
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        tableView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        /*
         tableView = UITableView()
         tableView.rowHeight = 70
         tableView.delegate = self
         tableView.dataSource = self
         tableView.isScrollEnabled = true
         tableView.separatorColor = .clear

         tableView.register(GroupMessageCell.self, forCellReuseIdentifier: reuseIdentifier)
         
         
         view.addSubview(tableView)
         tableView.translatesAutoresizingMaskIntoConstraints = false
         tableView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
         tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
         */
        
    }
    
    func configureNavigationBar() {
        
        //view.addSubview(navigationController!.navigationBar)
        
        //navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    
        
        // add or remove nav bar bottom border
        navigationController?.navigationBar.shadowImage = UIImage()
        let lineView = UIView(frame: CGRect(x: 0, y: 45, width: view.frame.width, height: 0.25))
        lineView.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        
    }
    
    
    // MARK: - API
    
    func fetchUsers() {

        //self.tableView.refreshControl?.endRefreshing()
        
         self.tableView.refreshControl?.endRefreshing()
        
        if userCurrentKey == nil {
            DataService.instance.REF_USERS.queryLimited(toLast: 4).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                    
                allObjects.forEach({ (snapshot) in
                    let uid = snapshot.key
                    
                    Database.fetchUser(with: uid, completion: { (user) in
                        self.users.append(user)
                        self.tableView.reloadData()
                    })
                })
                self.userCurrentKey = first.key
            }
        } else {
            DataService.instance.REF_USERS.queryOrderedByKey().queryEnding(atValue: userCurrentKey).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let uid = snapshot.key
                    
                    if uid != self.userCurrentKey {
                        Database.fetchUser(with: uid, completion: { (user) in
                            self.users.append(user)
                            self.tableView.reloadData()
                        })
                    }
                })
                self.userCurrentKey = first.key
            })
        }
    }
  
    
    
    // MARK: - UICollectionView
    
    func configureCollectionView() {
        
        
        // define the collection view characteristics

        let layout = UICollectionViewFlowLayout()
        //layout.scrollDirection = .vertical

        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        

        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 0)

        tableView.addSubview(collectionView)
        collectionView.anchor(top: tableView.topAnchor, left: tableView.leftAnchor, bottom: tableView.bottomAnchor, right: tableView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        collectionView.register(SearchPostCell.self, forCellWithReuseIdentifier: reusePostCellIdentifier)
        

        
    }
    
    
    // MARK: - Handlers
    

    
    func configureSearchBar() {
        
        //let navBarHeight = CGFloat((navigationController?.navigationBar.frame.size.height)!)

        
        searchBar.delegate = self
        
        titleView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 10))
       // let frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        //let titleView = UIView(frame: frame)
        //searchBar.backgroundImage = UIImage()
        //searchBar.frame = frame
        titleView.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 245)
        titleView.layer.cornerRadius = 3
        
        titleView.addSubview(cancelSearchButton)
        cancelSearchButton.anchor(top: titleView.topAnchor, left: nil, bottom: nil, right: titleView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 15, height: 15)
        
        titleView.addSubview(destinationTextField)
        destinationTextField.anchor(top: titleView.topAnchor, left: titleView.leftAnchor, bottom: titleView.bottomAnchor, right: cancelSearchButton.leftAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 110, height: 40)
        
        titleView.addSubview(searchLineViewVertical)
        searchLineViewVertical.anchor(top: titleView.topAnchor, left: titleView.leftAnchor, bottom: titleView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: -5, paddingBottom: 0, paddingRight: 0, width: 0.5, height: 0)

        navigationItem.titleView = titleView
        
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
    
    @objc func handleSearchFriends() {
        
        print("transition to menu")

        
    }
    
    @objc func handleSearchGroups() {
        print("transition to rewards")

        
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
        //collectionView.isHidden = true
        
        //fetchUsers()
        
        // hide collection view when we run this function
        //collectionView.isHidden = true
        //collectionViewEnabled = false
        
        //tableView.separatorColor = .clear
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchText = searchText.lowercased()
        
        //let searchText = String(searchText.text!)
        
        
        if searchText.isEmpty || searchText == " " {
            inSearchMode = false
            tableView.reloadData()
        } else {
            
            inSearchMode = true
            
            // return fitlered users
            filteredUsers = users.filter({ (user) -> Bool in                // having and issue here <--
                
                // using the username to filter through
                //return user.username.contains(searchText)
                
                return user.username.localizedCaseInsensitiveContains(searchText)

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
        //collectionView.isHidden = false
        
        // added stuff
        navigationItem.titleView = nil
        //configureSearchBarButton()
        
        tableView.separatorColor = .clear
        
        tableView.reloadData()
    }
    
    // MARK: - Handlers
    
    @objc func handleRefresh() {
        users.removeAll(keepingCapacity: false)
        self.currentKey = nil
        fetchUsers()
        tableView?.reloadData()
        
        //fetchPosts()
        //collectionView.reloadData()
    }
    
    func configureRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.tableView?.refreshControl = refreshControl
    }
    
 
    
    func configureSearchBarButton() {
        
        searchBar.showsCancelButton = true
        
         // configuring title button
         let button =  UIButton(type: .custom)
         button.frame = CGRect(x: 0, y: 0, width: 320, height: 35)
         button.backgroundColor = .red
         button.setTitleColor(.black, for: .normal)
         button.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
         navigationItem.titleView = button
         
         
         
         
                    let searchBarText = UIButton(type: UIButton.ButtonType.custom)
                        
                        searchBarText.frame = CGRect(x: 10, y: 0, width: 120, height: 33)
                        
                     searchBarText.setTitle("Search", for: .normal)
                     searchBarText.setTitleColor(UIColor.rgb(red: 140, green: 140, blue: 140), for: .normal)
                     searchBarText.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                        searchBarText.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
                        //searchBarText.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
                        searchBarText.backgroundColor = .clear
         
         
                    let magnifyButton = UIButton(type: UIButton.ButtonType.system)
                        
                        magnifyButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                        
                        //using this code to show the true image without rendering color
                        magnifyButton.setImage(UIImage(named:"search_selected")?.withRenderingMode(.alwaysOriginal), for: .normal)
                        magnifyButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 25, height: 26 )
                        magnifyButton.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
         magnifyButton.tintColor = UIColor.rgb(red: 80, green: 80, blue: 80)
                        magnifyButton.backgroundColor = .clear
                         
                
                let searchText = UIBarButtonItem(customView: searchBarText)
             let searchButton = UIBarButtonItem(customView: magnifyButton)
         
                self.navigationItem.leftBarButtonItems = [searchButton, searchText]
        
        
        /*
        // configuring titile button
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 320, height: 35)
        button.backgroundColor = .clear
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font =  UIFont(name: "PingFangTC-Semibold", size: 17)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
        navigationItem.titleView = button
        
        searchBar.showsCancelButton = true
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        //navigationItem.rightBarButtonItem?.tintColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        
                   let searchBarButton = UIButton(type: UIButton.ButtonType.custom)
                       
                       searchBarButton.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
                       
                       //using this code to show the true image without rendering color
                       searchBarButton.setImage(UIImage(named:"searchBar")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
                       searchBarButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 20, height: 21 )
                       searchBarButton.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
                       searchBarButton.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
                       searchBarButton.backgroundColor = .clear
               
               let searchButton = UIBarButtonItem(customView: searchBarButton)
               self.navigationItem.leftBarButtonItems = [searchButton]
        */
        
    }
    
    @objc func showSearchBar() {
        
        
        // hide collectionView will in search mode
        //navigationItem.titleView = searchBar
        
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = nil
        
        //fetchUsers()
        //collectionView.isHidden = true
        collectionViewEnabled = false
    
        configureSearchBar()
    }
    
    func fetchPosts() {
        // function to fetch our images and place them in the collection view

        print("are we fetching posts")
        
        if currentKey == nil {
            
            // initial data pull
            DataService.instance.REF_POSTS.queryLimited(toLast: 21).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.tableView.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    
                    Database.fetchSearchPost(with: postId, completion: { (post) in
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
                        Database.fetchSearchPost(with: postId, completion: { (post) in
                            self.posts.append(post)
                            self.collectionView.reloadData()
                        })
                    }
                })
                self.currentKey = first.key
                
            })
        }
    }
    
    
 /*   override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
*/
    
}

extension SearchVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 8, left: 0, bottom: 1, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width : CGFloat
        let height : CGFloat

        if indexPath.item == 0 {
            width = view.frame.width
            height = 210
        } else {
            width = (view.frame.width) / 3
            height = width
        }
    
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if posts.count > 20 {
            if indexPath.item == posts.count - 1 {
                //fetchPosts()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("the number of post is \(posts.count)")
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusePostCellIdentifier, for: indexPath) as! SearchPostCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    //let userSpecificFeedVC = UserSpecificFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
       let userSpecificFeedVC = UserSpecificFeedVC()
        userSpecificFeedVC.viewSinglePost = true
        userSpecificFeedVC.post = posts[indexPath.item]
        
        navigationController?.pushViewController(userSpecificFeedVC, animated: true)
    }
    
}

extension SearchVC: UITableViewDataSource, UITableViewDelegate  {
    
    // MARK: - Table view data source
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 70
      }

    /*
      func numberOfSections(in tableView: UITableView) -> Int {
          return 1
      }
     */
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if inSearchMode {
              return filteredUsers.count
          } else {
              return users.count
          }
      }
      
      func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
          
          if users.count > 3 {
              if indexPath.item == users.count - 1 {
                  fetchUsers()
              }
          }
      }
      
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          var user: User!
          
          if inSearchMode {
              user = filteredUsers[indexPath.row]
          } else {
              user = users[indexPath.row]
          }
          
          // Create instance of user profile vc.
          let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
          
          // Set the user from search vc to the correct user that was clicked on.
          userProfileVC.user = user
          
          // send the user value with more info
          
          // Push view controller.
          navigationController?.pushViewController(userProfileVC, animated: true)
          
      }

      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchUserCell
          
          var user: User!
          
          if inSearchMode {
              user = filteredUsers[indexPath.row]
          } else {
              user = users[indexPath.row]
          }
          
          cell.user = user
          
          return cell
      }
    
}

extension SearchVC: UITextFieldDelegate {
    

    func textFieldDidBeginEditing(_ sender: UITextField) {

        
        //collectionView.isHidden = true
        
    
        if sender == destinationTextField {
  
            cancelSearchButton.alpha = 1
           
        }
    }
    

    //func textFieldEditingChanged(_ sender: UITextField, textDidChange searchText: String) {
    @objc func textFieldDidChange(_ searchText: UITextField) {

        
        print(searchText)

               //let searchText = searchText
        let searchText = String(searchText.text!)
        
        
            //let searchText = String(searchText.text!)
            
            
            if searchText.isEmpty || searchText == " " {
                inSearchMode = false
                tableView.reloadData()
            } else {
                
                inSearchMode = true
                
                // return fitlered users
                filteredUsers = users.filter({ (user) -> Bool in                // having and issue here <--
                    
                    // using the username to filter through
                    //return user.username.contains(searchText)
                    
                    return user.username.localizedCaseInsensitiveContains(searchText)

                })
                tableView.reloadData()
            }
    }
    
    @objc func handleCancelSearch() {
    /*
            if #available(iOS 13.0, *) {
                searchBar.searchTextField.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
            } else {
                // Fallback on earlier versions
            }
        */
            
            collectionViewEnabled = true
            //collectionView.isHidden = false
            
        cancelSearchButton.alpha = 0
            // added stuff
            //navigationItem.titleView = nil
            //configureSearchBarButton()

        //clears search view
        destinationTextField.text = nil
        inSearchMode = false
        
        // reloads search table view data
        tableView.reloadData()

        print("We reach this point so this should allow the keyboard to be cancelllllled")
        //view.endEditing(true)
        self.view.endEditing(true)
        destinationTextField.resignFirstResponder()
        
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
       // centerMapOnUserLocation()
        
        
        return true
    }
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    */
}



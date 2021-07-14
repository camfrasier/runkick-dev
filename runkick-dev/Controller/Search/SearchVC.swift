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
private let reuseGroupsCellIdentifier = "GroupsCell"
private let reuseGroupsIdentifier = "GroupMessageCell"

class SearchVC: UIViewController, UISearchBarDelegate, SearchCellDelegate, UICollectionViewDelegate {

    
    // MARK: - Group Properties
    
    var groups = [UserGroup]()
    var groupsTableView: UITableView!
    var filteredGroups = [UserGroup]()
    var groupsCurrentKey: String?
    var groupsTitleView: UIView!
    var createGroupVC = CreateGroupVC()
    
    // MARK: - My Group Properties
    
    var myGroupsCurrentKey: String?
    var filteredMyGroups = [UserGroup]()
    var myGroups = [UserGroup]()
    
    
    
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
    var showGroups = false
    var showMyGroups = false
    var showMyFriends = true
    
    
    
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
    
    lazy var searchMyGroupsBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        let rewardsTap = UITapGestureRecognizer(target: self, action: #selector(handleSearchMyGroups))
        rewardsTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(rewardsTap)
        view.alpha = 1
        return view
    }()
    

    
    let searchFriendsLabel: UILabel = {
        let label = UILabel()
        label.text = "Friends"
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        return label
    }()
    
    let searchGroupsLabel: UILabel = {
        let label = UILabel()
        label.text = "Groups"
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        return label
    }()
    
    let searchMyGroupsLabel: UILabel = {
        let label = UILabel()
        label.text = "My Groups"
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
        tf.tintColor = UIColor.walkzillaYellow()
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(HomeVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        view.isUserInteractionEnabled = true
        return tf
    }()
    
    lazy var cancelSearchBackground: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor.clear
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(handleCancelSearch))
        cancelTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(cancelTap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    lazy var myGroupsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.rgb(red: 180, green: 180, blue: 180)
        label.text = "My Groups"
        //let groupTap = UITapGestureRecognizer(target: self, action: #selector(handleGroupsTapped))
        //groupTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        //label.addGestureRecognizer(groupTap)
        return label
    } ()
    
    

    lazy var createGroupBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        let rewardsTap = UITapGestureRecognizer(target: self, action: #selector(handleCreateGroup))
        rewardsTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(rewardsTap)
        view.alpha = 1
        return view
    }()
    
    lazy var createGroupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "walkzillaCreateGroup"), for: .normal)
        button.tintColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        button.addTarget(self, action: #selector(handleCreateGroup), for: .touchUpInside)
        return button
    }()
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
    /*
    enum PostType: String {

        case userPost = "userPost"
        case checkIn = "checkIn"
    }
    */
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureFriendsGroupSearch()
        
        configureTableView()
        
        configureNavigationBar()
        
        destinationTextField.delegate = self
        
        
        // configure search bar
        configureSearchBar()
        
        fetchUsers()
        
        
        tableView.separatorStyle = .none
        
        // configure refresh control
        configureRefreshControl()
        

        configureGroupsTableView()
        fetchGroups()
        
        configureGroupsCollectionView()
        fetchMyGroups()
        
        
        tableView.isHidden = false
        groupsTableView.isHidden = true
        collectionView.isHidden = true
       
        
        
        /*
        
         
       //setupToHideKeyboardOnTapOnView()

        

        

        //configureCollectionView()
        
        
        

                 
        //configureTabBar()
        
        // fetch posts
        //fetchPosts()
        
        fetchUsers()
        

 
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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: friendsGroupsView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        tableView.backgroundColor = UIColor.walkzillaYellow()
        
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
    
    func configureGroupsTableView() {
        
        groupsTableView = UITableView()
        groupsTableView.rowHeight = 70
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        groupsTableView.isScrollEnabled = true
        groupsTableView.separatorColor = .clear

        groupsTableView.register(GroupMessageCell.self, forCellReuseIdentifier: reuseGroupsIdentifier)
        
        
        view.addSubview(groupsTableView)
        groupsTableView.translatesAutoresizingMaskIntoConstraints = false
        groupsTableView.backgroundColor = UIColor.walkzillaYellow()
        groupsTableView.anchor(top: friendsGroupsView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        

        
    }
    
    func configureGroupsCollectionView() {
        

        // define the collection view characteristics
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        

        
        collectionView.register(GroupsCell.self, forCellWithReuseIdentifier: reuseGroupsCellIdentifier)
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.anchor(top: friendsGroupsView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        tableView.separatorColor = .clear
    }
    
    
    func fetchGroups() {
        
        //guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        self.groupsTableView.refreshControl?.endRefreshing()

         if groupsCurrentKey == nil {
            
            // because I expect more per view i increased the toLast count to 8
            DataService.instance.REF_USER_GROUPS.queryLimited(toLast: 8).observeSingleEvent(of: .value) { (snapshot) in
                 
                 guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                 guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                 
                 allObjects.forEach({ (snapshot) in
                     let groupId = snapshot.key
                     
                    Database.fetchUserGroups(with: groupId, completion: { (group) in
                        self.groups.append(group)
                        self.groupsTableView.reloadData()
                    })
                 })
                 self.groupsCurrentKey = first.key
             }
         } else {
            DataService.instance.REF_USER_GROUPS.queryOrderedByKey().queryEnding(atValue: userCurrentKey).queryLimited(toLast: 9).observeSingleEvent(of: .value, with: { (snapshot) in
                 
                 guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                 guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                 
                 allObjects.forEach({ (snapshot) in
                     let groupId = snapshot.key
                     
                     if groupId != self.userCurrentKey {
                         Database.fetchUserGroups(with: groupId, completion: { (group) in
                             self.groups.append(group)
                             self.groupsTableView.reloadData()
                         })
                     }
                 })
                 self.groupsCurrentKey = first.key
             })
         }
     }
    
    func fetchMyGroups() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        //guard let observedUserId = uid else { return }
        
        self.collectionView.refreshControl?.endRefreshing()

        
        if self.myGroupsCurrentKey == nil {
            
        DataService.instance.REF_USERS.child(currentUserId).child("groups").queryLimited(toLast: 15).observeSingleEvent(of: .value, with: { (snapshot) in
        
        if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
            guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
       
        for snap in snapshots {
                
            let groupId = snap.key
            print("this should bring back all groups the user is apart of \(key)")

               Database.fetchUserGroups(with: groupId, completion: { (group) in
                   self.myGroups.append(group)
                   self.collectionView.reloadData()

            //self.userCurrentKey = first.key
                
                })
            }
            self.myGroupsCurrentKey = first.key
            }
        })
        } else {
            
            DataService.instance.REF_USERS.child(currentUserId).child("groups").queryLimited(toLast: 16).observeSingleEvent(of: .value, with: { (snapshot) in
                  
                  if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                     guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                 
                  for snap in snapshots {
                          
                      let groupId = snap.key
                      print("this should bring back all groups the user is apart of \(key)")
    
  
                         if groupId != self.myGroupsCurrentKey {
                             Database.fetchUserGroups(with: groupId, completion: { (group) in
                                 self.myGroups.append(group)
                                 self.collectionView.reloadData()
                             })
                         }
 
                      }
                    self.myGroupsCurrentKey = first.key
                      }
                  })
            
        }
     }
    
    // completion block function to run and after the group can be removed
    func firstTask(completion: (_ success: Bool) -> Void) {
        
            _ = self.navigationController?.popViewController(animated: true)
            completion(true)

        // Call completion, when finished, success or faliure
        
    }
    
    /*
    //handle group refresh
    @objc func handleGroupsRefresh() {
        groups.removeAll(keepingCapacity: false)
        self.userCurrentKey = nil
        fetchGroups()
        
        tableView?.reloadData()
    }
    */
    
    @objc func handleCreateGroup() {
        print("Create group here!")
        
        let createGroupVC = CreateGroupVC()

        let nav = self.navigationController
        DispatchQueue.main.async {
            
            self.view.window!.backgroundColor = UIColor.white
            nav?.view.layer.add(CATransition().popFromRight(), forKey: kCATransition)
            nav?.pushViewController(createGroupVC, animated: false)
        }
        
        /*
         //createGroupVC.modalPresentationStyle = .fullScreen
         //present(createGroupVC, animated: true, completion:nil)
         
         self.navigationController?.pushViewController(createGroupVC, animated: true)
         
         let notificationsVC = NotificationsVC()
         //navigationController?.pushViewController(notificationsVC, animated: true)
         
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

        self.tableView.refreshControl?.endRefreshing()

        if userCurrentKey == nil {
            DataService.instance.REF_USERS.queryLimited(toLast: 4).observeSingleEvent(of: .value) { (snapshot) in
                
                self.tableView.refreshControl?.endRefreshing()
                
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
  
    
    func configureFriendsGroupSearch() {
        
        view.addSubview(friendsGroupsView)
        friendsGroupsView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
        
        friendsGroupsView.addSubview(lineView)
        lineView.anchor(top: nil, left: friendsGroupsView.leftAnchor, bottom: friendsGroupsView.bottomAnchor, right: friendsGroupsView.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 0.75)
        
        friendsGroupsView.addSubview(indicatorView)
        indicatorView.anchor(top: nil, left: lineView.leftAnchor, bottom: lineView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -1, paddingRight: 0, width: 50, height: 4)
        
        friendsGroupsView.addSubview(searchFriendsBackground)
        searchFriendsBackground.anchor(top: nil, left: friendsGroupsView.leftAnchor, bottom: lineView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 25, paddingBottom: 10, paddingRight: 0, width: 80, height: 40)
        
        searchFriendsBackground.addSubview(searchFriendsLabel)
        searchFriendsLabel.anchor(top: nil, left: searchFriendsBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        searchFriendsLabel.centerYAnchor.constraint(equalTo: searchFriendsBackground.centerYAnchor).isActive = true
        
        friendsGroupsView.addSubview(searchGroupsBackground)
        searchGroupsBackground.anchor(top: nil, left: searchFriendsBackground.rightAnchor, bottom: lineView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 10, paddingRight: 0, width: 90, height: 40)
        
        searchGroupsBackground.addSubview(searchGroupsLabel)
        searchGroupsLabel.anchor(top: nil, left: searchGroupsBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        searchGroupsLabel.centerYAnchor.constraint(equalTo: searchGroupsBackground.centerYAnchor).isActive = true
        
        friendsGroupsView.addSubview(searchMyGroupsBackground)
        searchMyGroupsBackground.anchor(top: nil, left: searchGroupsBackground.rightAnchor, bottom: lineView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 30, paddingBottom: 10, paddingRight: 0, width: 90, height: 40)
        
        searchMyGroupsBackground.addSubview(searchMyGroupsLabel)
        searchMyGroupsLabel.anchor(top: nil, left: searchMyGroupsBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        searchMyGroupsLabel.centerYAnchor.constraint(equalTo: searchMyGroupsBackground.centerYAnchor).isActive = true
        
        friendsGroupsView.addSubview(createGroupBackground)
        createGroupBackground.anchor(top: nil, left: nil, bottom: lineView.topAnchor, right: friendsGroupsView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 12, paddingRight: 24, width: 35, height: 35)
        
        createGroupBackground.addSubview(createGroupButton)
        createGroupButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 28, height: 28)
        createGroupButton.centerXAnchor.constraint(equalTo: createGroupBackground.centerXAnchor).isActive = true
        createGroupButton.centerYAnchor.constraint(equalTo: createGroupBackground.centerYAnchor).isActive = true
        
       
    }
    
    
    // MARK: - UICollectionView
    
    /*
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
    */
    
    
    
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
        
        
        titleView.addSubview(cancelSearchBackground)
        cancelSearchBackground.anchor(top: titleView.topAnchor, left: nil, bottom: nil, right: titleView.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 35, height: 35)
        
        cancelSearchBackground.addSubview(cancelSearchButton)
        cancelSearchButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
        
        cancelSearchButton.centerXAnchor.constraint(equalTo: cancelSearchBackground.centerXAnchor).isActive = true
        cancelSearchButton.centerYAnchor.constraint(equalTo: cancelSearchBackground.centerYAnchor).isActive = true
        
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
        showGroups = false
        showMyGroups = false
        showMyFriends = true

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.indicatorView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        print("transition to friends search")
        tableView.isHidden = false
        groupsTableView.isHidden = true
        collectionView.isHidden = true

    }
    
    @objc func handleSearchGroups() {


        showGroups = true
        showMyGroups = false
        showMyFriends = false
        
        indicatorView.transform = CGAffineTransform(translationX: 1, y: 1)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            

            self.indicatorView.transform = CGAffineTransform(translationX: 85, y: 0)
        })
        
        
        
        print("transition to groups search")
       
        
        
        tableView.isHidden = true
        groupsTableView.isHidden = false
        collectionView.isHidden = true
        
        

        
    }
    
    @objc func handleSearchMyGroups() {
        print("Handle search my groups")
        
        showGroups = false
        showMyGroups = true
        showMyFriends = false
        
        /*
        indicatorView.transform = CGAffineTransform(translationX: 1, y: 1)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.indicatorView.transform = CGAffineTransform(translationX: 175, y: 0)
        })
        */
        
        print("transition to groups search")
        
        tableView.isHidden = true
        groupsTableView.isHidden = true
        collectionView.isHidden = false
        
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
        //users.removeAll(keepingCapacity: false)
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
    /*
    func fetchPosts() {
        // function to fetch our images and place them in the collection view

        print("are we fetching posts")
        
        if currentKey == nil {
            
            // initial data pull
            DataService.instance.REF_POSTS.queryLimited(toLast: 21).observeSingleEvent(of: .value, with: { (snapshot) in
                
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
*/
    
    
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
        
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = ((view.frame.width) / 3 ) - 10
        return CGSize(width: width - 5, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if myGroups.count > 14 {
            if indexPath.item == myGroups.count - 1 {
                fetchMyGroups()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredMyGroups.count
        } else {
            return myGroups.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseGroupsCellIdentifier, for: indexPath) as! GroupsCell
     
     var group: UserGroup!
     
     //group = groups[indexPath.row]
     
     //cell.group = group
        
        if inSearchMode {
            group = filteredMyGroups[indexPath.row]
        } else {
            group = myGroups[indexPath.row]
        }
        
        cell.group = group
         
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("you selected a cell from my groups")
    }
    
}

extension SearchVC: UITableViewDataSource, UITableViewDelegate  {
    
    // MARK: - Table view data source
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == groupsTableView {
            return 70
        }
          return 70
      }

    /*
      func numberOfSections(in tableView: UITableView) -> Int {
          return 1
      }
     */
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == groupsTableView {
            if inSearchMode {
                return filteredGroups.count
            } else {
                return groups.count
            }
        }
        
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
        
        if tableView == groupsTableView {
            print("This is where user should be allowed to join an existing friends group or create one")
            tableView.deselectRow(at: indexPath, animated: true)

            let groupProfilVC = GroupProfileVC()
            groupProfilVC.group = groups[indexPath.item]
            //navigationController?.pushViewController(groupProfilVC, animated: true)
            
            
            let nav = self.navigationController
            DispatchQueue.main.async {
                
                self.view.window!.backgroundColor = UIColor.white
                nav?.view.layer.add(CATransition().popFromRight(), forKey: kCATransition)
                nav?.pushViewController(groupProfilVC, animated: false)
            }
            
            

        } else {
          
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
        
      }

      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == groupsTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseGroupsIdentifier, for: indexPath) as! GroupMessageCell
            
            var group: UserGroup!
            
            if inSearchMode {
                group = filteredGroups[indexPath.row]
            } else {
                group = groups[indexPath.row]
            }
            
            cell.group = group
            
            return cell
        }
        
        
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
  
            cancelSearchBackground.alpha = 1
            cancelSearchButton.alpha = 1
           
        }
    }
    

    //func textFieldEditingChanged(_ sender: UITextField, textDidChange searchText: String) {
    @objc func textFieldDidChange(_ searchText: UITextField) {

        if showGroups == true {
            
            print("SHOW GROUPS IS SET TO TRUE")
            
            let searchText = String(searchText.text!)
        
            //let searchText = String(searchText.text!)
            
            
            if searchText.isEmpty || searchText == " " {
                inSearchMode = false
                groupsTableView.reloadData()
            } else {
                
                inSearchMode = true
                
                // return fitlered users
                filteredGroups = groups.filter({ (group) -> Bool in                // having and issue here <--
                    
                    return group.groupName.localizedCaseInsensitiveContains(searchText)
                })
                groupsTableView.reloadData()
            }
        }
        
        if showMyGroups == true {
            
            print("SHOW MY USER GROUPS IS SET TO TRUE")
            
            let searchText = String(searchText.text!)
           
            
            if searchText.isEmpty || searchText == " " {
                inSearchMode = false
                collectionView.reloadData()
            } else {
                
                inSearchMode = true
                
                // return fitlered users
                filteredMyGroups = myGroups.filter({ (group) -> Bool in                // having and issue here <--
                    
                    return group.groupName.localizedCaseInsensitiveContains(searchText)
                })
                collectionView.reloadData()
            }
            
        }
        
        if showMyFriends == true {
        print(searchText)
            
            print("SHOW MY FRIENDS SET TO TRUE")

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
        
    }
    
    @objc func handleCancelSearch() {
    /*
            if #available(iOS 13.0, *) {
                searchBar.searchTextField.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
            } else {
                // Fallback on earlier versions
            }
        */
            
        if showGroups == true {
        
        collectionViewEnabled = true
        
        
        cancelSearchBackground.alpha = 0
            cancelSearchButton.alpha = 0
            // added stuff
            //navigationItem.titleView = nil
            //configureSearchBarButton()

        //clears search view
        destinationTextField.text = nil
        inSearchMode = false
        
        // reloads search table view data
        groupsTableView.reloadData()

        print("We reach this point so this should allow the keyboard to be cancelllllled")
        //view.endEditing(true)
        self.view.endEditing(true)
        destinationTextField.resignFirstResponder()
            
        }
        
        if showMyGroups == true {
            collectionViewEnabled = true
            
            cancelSearchBackground.alpha = 0
            cancelSearchButton.alpha = 0
   
            //clears search view
            destinationTextField.text = nil
            inSearchMode = false
            
            // reloads search table view data
            collectionView.reloadData()

            print("We reach this point so this should allow the keyboard to be cancelllllled")
            //view.endEditing(true)
            self.view.endEditing(true)
            destinationTextField.resignFirstResponder()
                   
        }
        
        if showMyFriends == true {
            
            collectionViewEnabled = true
            //collectionView.isHidden = false
            
        cancelSearchBackground.alpha = 0
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


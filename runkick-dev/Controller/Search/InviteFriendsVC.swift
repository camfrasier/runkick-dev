//
//  InviteFriendsVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 10/27/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "InviteFriendsCell"

class InviteFriendsVC: UITableViewController, UISearchBarDelegate {
    
    // Mark: - Properties
    
    var users = [User]()
    var filteredUsers = [User]()
    var searchBar = UISearchBar()
    var inSearchMode = false
    var collectionView: UICollectionView!
    var collectionViewEnabled = true
    var posts = [Post]()
    var currentKey: String?
    var userCurrentKey: String?
    var titleView: UIView!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure search bar
        configureSearchBar()

        // register cell classes
        tableView.register(InviteFriendsCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // seperator insets.
        //tableView.separatorInset = UIEdgeInsets(top: 50, left: 20, bottom: 0, right: 0)
        
        tableView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        // configure refresh control
        //configureRefreshControl()
        
        //configureNavigationBar
        configureNavigationBar()
        
        configureTabBar()
        
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        //configureNavigationBar()
        
        configureTabBar()
        
    }
    
    // this function ensures the navigation bar is filled after transitioning to a regular nav bar
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.layoutSubviews()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredUsers.count
        } else {
            return users.count
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if users.count > 3 {
            if indexPath.item == users.count - 1 {
                fetchUsers()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! InviteFriendsCell
        
        var user: User!
        
        if inSearchMode {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        
        cell.user = user
        
        return cell
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
        searchBar.anchor(top: titleView.topAnchor, left: titleView.leftAnchor, bottom: titleView.bottomAnchor, right: titleView.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 20, width: view.frame.width - 35, height: 40)
        
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
        lineView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

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

        
        // added stuff
        navigationItem.titleView = nil
        configureSearchBarButton()
        
        tableView.separatorColor = .clear
        
        tableView.reloadData()
    }
    
    // MARK: - Handlers
    
    @objc func handleRefresh() {
        posts.removeAll(keepingCapacity: false)
        self.currentKey = nil
    }
    
    func configureRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.tableView?.refreshControl = refreshControl
    }
    
    // MARK: - API
    
    func fetchUsers() {

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
    
    func configureSearchBarButton() {
        
        
         // configuring title button
         let button =  UIButton(type: .custom)
         button.frame = CGRect(x: 0, y: 0, width: 320, height: 35)
         button.backgroundColor = .clear
         button.setTitleColor(.black, for: .normal)
         button.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
         navigationItem.titleView = button
         
         searchBar.showsCancelButton = true
         
         
                    let searchBarText = UIButton(type: UIButton.ButtonType.custom)
                        
                        searchBarText.frame = CGRect(x: 0, y: 0, width: 120, height: 33)
                        
                     searchBarText.setTitle("SEARCH FRIENDS TO INVITE", for: .normal)
                     searchBarText.setTitleColor(UIColor.rgb(red: 80, green: 80, blue: 80), for: .normal)
                     searchBarText.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                        searchBarText.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
                        //searchBarText.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
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

        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = nil
        
        //fetchUsers()
        configureSearchBar()
    }
}


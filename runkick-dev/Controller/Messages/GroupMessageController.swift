//
//  GroupMessageController.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 10/12/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "GroupMessageCell"

class GroupMessageController: UIViewController, UISearchBarDelegate, GroupMessageControllerDelegate {
  
    
    // MARK: - Properties
    var groups = [UserGroup]()
    var tableView: UITableView!
    var filteredGroups = [UserGroup]()
    var userCurrentKey: String?
    var inSearchMode = false
    var searchBar = UISearchBar()
    var titleView: UIView!
    var createGroupVC = CreateGroupVC()
    var delegate: MenuControllerDelegate?
    
    
    var headerView: UIView = UIView.init(frame: CGRect.init(x: 1, y: 50, width: 276, height: 50))
    var labelView: UILabel = UILabel.init(frame: CGRect.init(x: 4, y: 35, width: 276, height: 38))
    
    /*
    lazy var userSpecificGroupsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Your Groups", for: .normal)
        button.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        //button.titleLabel?.font =  UIFont(name: "HelveticaNeue-CondensedBold", size: 14)
        button.setTitleColor(UIColor.rgb(red: 80, green: 80, blue: 80), for: .normal)
        button.addTarget(self, action: #selector(yourGroupsTapped), for: .touchUpInside)
        return button
    } ()
    */
    /*
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Groups"
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        label.font = UIFont(name: "PingFangTC-Semibold", size: 24)
        return label
    }()
    */

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()

            
        configureTableView()

        createGroupVC.delegate = self
        
        configureViewComponents()
        
        configureNavigationBar()
        
        configureTabBar()
        
        fetchGroups()
        
        
        
        // configure refresh control
        configureRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           
        configureTabBar()
        tableView?.reloadData()
    }
    
    func configureTableView()  {
  
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
        //self.tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        
        
        // adjust the header settings
        headerView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //labelView.text = "hello"
        labelView.text = "Groups"
        labelView.textColor = UIColor.rgb(red: 90, green: 90, blue: 90)
        labelView.font = UIFont(name: "PingFangTC-Semibold", size: 28)
        
        headerView.addSubview(labelView)
        labelView.anchor(top: headerView.topAnchor, left: headerView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.tableView.tableHeaderView = headerView


  
    }
 
    // MARK: - Handlers
    
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
    
    func fetchGroups() {
        
        //guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        self.tableView.refreshControl?.endRefreshing()

         if userCurrentKey == nil {
            
            // because I expect more per view i increased the toLast count to 8
            DataService.instance.REF_USER_GROUPS.queryLimited(toLast: 8).observeSingleEvent(of: .value) { (snapshot) in
                 
                
                
                 guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                 guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                 
                 allObjects.forEach({ (snapshot) in
                     let groupId = snapshot.key
                     
                    Database.fetchUserGroups(with: groupId, completion: { (group) in
                        self.groups.append(group)
                        self.tableView.reloadData()
                    })
                 })
                 self.userCurrentKey = first.key
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
                             self.tableView.reloadData()
                         })
                     }
                 })
                 self.userCurrentKey = first.key
             })
         }
     }
    
     
    func configureViewComponents() {
        
        
        /*
        headerView.addSubview(userSpecificGroupsButton)
        userSpecificGroupsButton.anchor(top: headerView.topAnchor, left: nil, bottom: nil, right: headerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 120, height: 40)
        userSpecificGroupsButton.layer.cornerRadius = 20
        userSpecificGroupsButton.centerXAnchor.constraint(equalTo: userSpecificGroupsButton.centerXAnchor).isActive = true
        userSpecificGroupsButton.layer.borderColor = UIColor.rgb(red: 120, green: 120, blue: 120).cgColor
        userSpecificGroupsButton.layer.borderWidth = 0.5
    */
    }
    
    
    func configureTabBar() {
        
        // removing shadow from tab bar
        tabBarController?.tabBar.layer.shadowRadius = 0
        tabBarController?.tabBar.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
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
            filteredGroups = groups.filter({ (group) -> Bool in                // having and issue here <--
                
                return group.groupName.localizedCaseInsensitiveContains(searchText)
            })
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        //configureLeftBarButton()
        
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
         searchBar.anchor(top: titleView.topAnchor, left: titleView.leftAnchor, bottom: titleView.bottomAnchor, right: titleView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: view.frame.width - 65, height: 40)
         
         navigationItem.titleView = titleView
        
        searchBar.placeholder = "Search Groups"
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        searchBar.autocapitalizationType = .none
        
        
        // SearchBar text
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor.red
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
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func presentInviteFriendsVC() {
        
        print("we should present the invite friends VC here")
        
        let inviteFriendsVC = InviteFriendsVC()
        //inviteFriendsVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(inviteFriendsVC, animated: true)
    }
    
    func handleInviteFriendsToggle(shouldDismiss: Bool) {
         print("we should present the invite friends VC here")
               
               let inviteFriendsVC = InviteFriendsVC()
               self.navigationController?.pushViewController(inviteFriendsVC, animated: true)
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
                        
                     searchBarText.setTitle("Search user groups", for: .normal)
                     searchBarText.setTitleColor(UIColor.rgb(red: 80, green: 80, blue: 80), for: .normal)
                     searchBarText.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                        searchBarText.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
                        //searchBarText.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
                        searchBarText.backgroundColor = .clear
         
         
                    let magnifyButton = UIButton(type: UIButton.ButtonType.system)
                        
                        magnifyButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                        
                        //using this code to show the true image without rendering color
                        magnifyButton.setImage(UIImage(named:"searchBar")?.withRenderingMode(.alwaysOriginal), for: .normal)
                        magnifyButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 15, height: 16 )
                        //magnifyButton.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
                        magnifyButton.addTarget(self, action: #selector(presentInviteFriendsVC), for: .touchUpInside)
                        magnifyButton.tintColor = UIColor.rgb(red: 80, green: 80, blue: 80)
                        magnifyButton.backgroundColor = .clear
                         
                
                let searchText = UIBarButtonItem(customView: searchBarText)
             let searchButton = UIBarButtonItem(customView: magnifyButton)
         
        self.navigationItem.leftBarButtonItems = [searchButton, searchText]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleCreateGroup))
        
    }
    
    func configureRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.tableView?.refreshControl = refreshControl
    }
    
    // MARK: - Handlers
    
    /*
    @objc func yourGroupsTapped() {
         
        // dismiss after calling delegate
        //_ = self.navigationController?.popViewController(animated: true)
        
        print("do something here")
        
        let userGroupVC = UserGroupVC()

        userGroupVC.modalPresentationStyle = .fullScreen
        present(userGroupVC, animated: true, completion: nil)
        
        //navigationController?.pushViewController(userGroupVC, animated: true)
        
        
        /*
        firstTask { (success) -> Void in
            if success {
                
            delegate?.handleMenuToggle(shouldToggle: true)
            }
        }
        */
    }
    */
    
    // completion block function to run and after the group can be removed
    func firstTask(completion: (_ success: Bool) -> Void) {
        
            _ = self.navigationController?.popViewController(animated: true)
            completion(true)

        // Call completion, when finished, success or faliure
        
    }
    
    @objc func handleRefresh() {
        groups.removeAll(keepingCapacity: false)
        self.userCurrentKey = nil
        fetchGroups()
        
        tableView?.reloadData()
    }
    

    
    
    @objc func showSearchBar() {
        // hide collectionView will in search mode
        
        //navigationItem.titleView = searchBar
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = nil

        fetchGroups()

        configureSearchBar()
    }
    
    
    @objc func handleCreateGroup() {
        print("Create group here!")
        
        let createGroupVC = CreateGroupVC()
        //createGroupVC.modalPresentationStyle = .fullScreen
        //present(createGroupVC, animated: true, completion:nil)
        
        self.navigationController?.pushViewController(createGroupVC, animated: true)
    }
}

extension GroupMessageController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 5
        if inSearchMode {
            return filteredGroups.count
        } else {
            return groups.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GroupMessageCell
        
        var group: UserGroup!
        
        if inSearchMode {
            group = filteredGroups[indexPath.row]
        } else {
            group = groups[indexPath.row]
        }
        
        cell.group = group
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if groups.count > 7 {
            if indexPath.item == groups.count - 1 {
                fetchGroups()
            }
        }

    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("This is where user should be allowed to join an existing friends group or create one")
        tableView.deselectRow(at: indexPath, animated: true)

        let groupProfilVC = GroupProfileVC()
        groupProfilVC.group = groups[indexPath.item]
        navigationController?.pushViewController(groupProfilVC, animated: true)

    }
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))

        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Groups"
        label.font = UIFont(name: "PingFangTC-Semibold", size: 24)
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)

        headerView.addSubview(label)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    */
}


/*
// MARK: - GroupMessageControllerDelegate

extension GroupMessageController: GroupMessageControllerDelegate {
    func handleInviteFriendsToggle(shouldDismiss: Bool) {
        
        if shouldDismiss {
            
        print("Does this group message value show up!")
        let inviteFriendsVC = InviteFriendsVC()
        self.navigationController?.pushViewController(inviteFriendsVC, animated: true)
        }
    }
   
}

*/

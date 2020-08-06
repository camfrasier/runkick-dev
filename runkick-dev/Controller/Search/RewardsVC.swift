//
//  RewardsVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/3/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "RewardsCell"

class RewardsVC: UITableViewController, UISearchBarDelegate {
    
    // Mark: - Properties
    
    var rewards = [Rewards]()
    var filteredRewards = [Rewards]()
    var userCurrentKey: String?
    var inSearchMode = false
    var searchBar = UISearchBar()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // register cell classes
        tableView.register(RewardsCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // seperator insets.
        //tableView.separatorInset = UIEdgeInsets(top: 50, left: 20, bottom: 0, right: 0)
    
        tableView.backgroundColor = UIColor.rgb(red: 254, green: 254, blue: 255)
        
        configureNavigationBar()
        
        configureTabBar()
        
        // fetch rewards
        fetchRewards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           
        configureTabBar()
        configureNavigationBar()
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
            return filteredRewards.count
        } else {
            return rewards.count
        }
        
        
        //return rewards.count
        //return 1

    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if rewards.count > 3 {
            if indexPath.item == rewards.count - 1 {
                fetchRewards()
            }
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("You've selected an item")
        tableView.deselectRow(at: indexPath, animated: true)
        
        
         /*
        var reward: Rewards!
        
        if inSearchMode {
            reward = filteredRewards[indexPath.row]
        } else {
            reward = rewards[indexPath.row]
        }
        
        // Create instance of user profile vc.
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        // Set the user from search vc to the correct user that was clicked on.
        userProfileVC.user = user
        // Push view controller.
        navigationController?.pushViewController(userProfileVC, animated: true)
        */
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RewardsCell
                
        var reward: Rewards!
        
        //reward = rewards[indexPath.row]
        
        if inSearchMode {
            reward = filteredRewards[indexPath.row]
        } else {
            reward = rewards[indexPath.row]
        }
        
        cell.reward = reward
        
        return cell
    }
    
    func configureNavigationBar() {

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
        
        let font = UIFont(name: "HelveticaNeue-Bold", size: 17)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)]
        navigationItem.title = "Rewards"
        
        navigationController?.navigationBar.tintColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        
        
        configureSearchBarButton()
    }
    
    func fetchRewards() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }

         if userCurrentKey == nil {
            
            DataService.instance.REF_USER_REWARDS.child(currentUserId).queryLimited(toLast: 4).observeSingleEvent(of: .value) { (snapshot) in
                 
                 guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                 guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                 
                 allObjects.forEach({ (snapshot) in
                     let storeId = snapshot.key
                     
                    Database.fetchRewards(with: storeId) { (reward) in
                        self.rewards.append(reward)
                        self.tableView.reloadData()
                    }
                 })
                 self.userCurrentKey = first.key
             }
         } else {
            DataService.instance.REF_USERS.child(currentUserId).queryOrderedByKey().queryEnding(atValue: userCurrentKey).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                 
                 guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                 guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                 
                 allObjects.forEach({ (snapshot) in
                     let storeId = snapshot.key
                     
                     if storeId != self.userCurrentKey {
                         Database.fetchRewards(with: storeId, completion: { (reward) in
                             self.rewards.append(reward)
                             self.tableView.reloadData()
                         })
                     }
                 })
                 self.userCurrentKey = first.key
             })
         }
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
            filteredRewards = rewards.filter({ (reward) -> Bool in                // having and issue here <--
                
                return reward.title.localizedCaseInsensitiveContains(searchText)
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

        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search"
        searchBar.becomeFirstResponder()
        searchBar.autocapitalizationType = .none
        
        
        if let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField,
               let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {

                   //Magnifying glass
                   glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
                   glassIconView.tintColor = .white
           }
    
        
        // SearchBar text
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor.red
        textFieldInsideUISearchBar?.font = textFieldInsideUISearchBar?.font?.withSize(22)
    
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
        //searchBar.searchTextField.layer.borderColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1).cgColor
        //searchBar.searchTextField.layer.borderWidth = 0.25
        
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = searchBar
    }
    
    func configureSearchBarButton() {
        // configuring titile button
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 320, height: 35)
        button.backgroundColor = .clear
        button.setTitle("Rewards", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
        navigationItem.titleView = button
        
        
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        //navigationItem.rightBarButtonItem?.tintColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        
                   let searchBarButton = UIButton(type: UIButton.ButtonType.custom)
                       
                       searchBarButton.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
                       
                       //using this code to show the true image without rendering color
                       searchBarButton.setImage(UIImage(named:"searchBar")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
                       searchBarButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 22, height: 23 )
                       searchBarButton.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
                       searchBarButton.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
                       searchBarButton.backgroundColor = .clear
               
               let searchButton = UIBarButtonItem(customView: searchBarButton)
               self.navigationItem.rightBarButtonItems = [searchButton]
        
    }
    
    @objc func showSearchBar() {
        // hide collectionView will in search mode
        
        fetchRewards()

        //self.navigationItem.rightBarButtonItems = nil
    
        configureSearchBar()
    }

    
}

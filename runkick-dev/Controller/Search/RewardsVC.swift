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
    var userCurrentKey: String?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // register cell classes
        tableView.register(RewardsCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // seperator insets.
        //tableView.separatorInset = UIEdgeInsets(top: 50, left: 20, bottom: 0, right: 0)
    
        tableView.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 250)
        
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
        
        return rewards.count
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
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RewardsCell
                
        var reward: Rewards!
        
        reward = rewards[indexPath.row]
        
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

    
}

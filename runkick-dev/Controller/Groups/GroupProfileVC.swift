//
//  GroupProfileVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 11/5/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "groupProfileCell"
//private let headerIdentifier = "groupProfileHeader"
private let statisticsIdentifier = "statisticsIdentifier"


class GroupProfileVC: UIViewController {

    // Mark: - Properties
    
    var tableView: UITableView!
    var groups = [UserGroup]()
    var groupIdentifier: String?
    var userCurrentKey: String?
    var users = [User]()
    var userLeaders = [User]()
    //var group: UserGroup?
    
    var group: UserGroup? {
        didSet {
            guard let photoImageUrl = group?.profileImageURL else { return }
            groupProfileImageView.loadImage(with: photoImageUrl)
            
            guard let groupname = group?.groupName else { return }
            self.groupnameLabel.text = groupname
            
            guard let groupId = group?.groupId else { return }
            groupIdentifier = groupId

        }
    }
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(GroupDetailCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    let groupProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        iv.image = UIImage(named: "userProfileSilhouetteWhite")
        return iv
    } ()
    
    let groupnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        return label
    } ()
    
    let groupMemberTitleLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.font = UIFont(name: "PingFangTC-Semibold", size: 16)
        label.text = "Members"
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        return label
    } ()
    
    let groupLeadersLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.font = UIFont(name: "PingFangTC-Semibold", size: 16)
        label.text = "Leaderboard"
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        return label
    } ()
    
    // i would like this label to aventually be able to pinpoint your hometown on apple maps with photos
    let groupTagline: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.rgb(red: 60, green: 60, blue: 60)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        //label.textAlignment = .left
        label.text = "I'm so, I'm so re-born.."
        return label
    } ()
    
    lazy var editGroupProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        button.layer.borderColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        button.layer.borderWidth = 0.25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        //button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    } ()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        collectionView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        
        view.addSubview(headerView)
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 155)
        
        headerView.addSubview(groupMemberTitleLabel)
        groupMemberTitleLabel.anchor(top: nil, left: headerView.leftAnchor, bottom: headerView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 155, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        configureViewComponents()
        
        fetchGroupMembers()
        
        //fetchLeaderBoard()
        
        configureTableView()

    }
    
    /*
    func setUserStats(for header: GroupProfileHeader) {
        print("handle set user stats")
    }
    
    func handleMemberDetailView(for header: GroupProfileHeader) {
        print("handle member detail view")
        
        // here you click on the top group memebers box and see their specific stats
    }
    
    func handleRequestInvite(for header: GroupProfileHeader) {
        print("handle request invite")
    }
    */
    
    func configureViewComponents() {
        
       // configure view components here
        
        let profileCircleDimension: CGFloat = 95
        view.addSubview(groupProfileImageView)
        groupProfileImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: profileCircleDimension, height: profileCircleDimension)
        groupProfileImageView.layer.cornerRadius = profileCircleDimension / 2

    }

    
    func configureTableView() {

        tableView = UITableView()
        //tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.separatorColor = .clear
        
        // disables the scrolling feature for the table view
        
        tableView.register(GroupStatisticsCell.self, forCellReuseIdentifier: statisticsIdentifier)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: collectionView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        tableView.backgroundColor = UIColor.rgb(red: 200, green: 200, blue: 200)
        
        view.addSubview(groupLeadersLabel)
        groupLeadersLabel.anchor(top: collectionView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func fetchGroupMembers() {
        
        guard let groupId = groupIdentifier else { return }
        
        DataService.instance.REF_USER_GROUPS.child(groupId).child("members").queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
              guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                
            for snap in snapshots {
                 
                let value = snap.value as! String
                    //print("this snap represents one group member uid\(value)")
                
                Database.fetchUser(with: value, completion: { (user) in
                    self.users.append(user)
                    self.collectionView.reloadData()
                })

                }
                self.userCurrentKey = first.key
            } else {
                
                DataService.instance.REF_USER_GROUPS.child(groupId).child("members").queryLimited(toLast: 11).observeSingleEvent(of: .value, with: { (snapshot) in
                                
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                               
                    for snap in snapshots {
                            let value = snap.value as! String

                                if groupId != self.userCurrentKey {
                                            Database.fetchUser(with: value, completion: { (user) in
                                               self.users.append(user)
                                               self.collectionView.reloadData()
                                           })
                                    }
                                }
                        self.userCurrentKey = first.key
                    }
                })
   
            }
            
        })
    }
    
    func fetchLeaderBoard() {
        
             guard let groupId = groupIdentifier else { return }
             
             DataService.instance.REF_USER_GROUPS.child(groupId).child("members").observeSingleEvent(of: .value, with: { (snapshot) in
                 
                 if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                     
                 for snap in snapshots {
                      
                     let value = snap.value as! String
                         //print("this snap represents one group member uid\(value)")
                     
                     Database.fetchUser(with: value, completion: { (user) in    // i need to fetch user then the user statisitcs, make sure the username or photo gets transfered and use that data
                         self.userLeaders.append(user)
                        
                        print("This should be a user value \(user)")
                        self.userLeaders.sort { (user1, user2) -> Bool in
                            return user1.lastname > user2.lastname
                        }
                         self.tableView.reloadData()
                     })

                    }
                 }
                 
             })
        
    }
    

}

extension GroupProfileVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        //return 1
        return 1
    }
    
    // this is a bit smoother to use with pagination, because it loads while your scrolling or when the cell is coming into view
   func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        if users.count > 9 {
            if indexPath.item == users.count - 1 {
                fetchGroupMembers()
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // sets the vertical spacing between photos
        //return 4
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = 85

        return CGSize(width: width, height: width)
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 140)
    }
    */
    
    
    
    
    // Mark: - UICollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 50
        users.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GroupDetailCell
        
        cell.user = users[indexPath.item]

        //cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("you selected this view")
    }
    
    
}


extension GroupProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        userLeaders.count
        //return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: statisticsIdentifier, for: indexPath) as! GroupStatisticsCell
        
        var leader: User!

        leader = userLeaders[indexPath.row]
        
        cell.user = leader
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        fetchLeaderBoard()
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("This is where user should be allowed to join")

    }
}

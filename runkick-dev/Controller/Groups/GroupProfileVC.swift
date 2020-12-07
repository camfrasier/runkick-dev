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
    var userLeaderCurrentKey: String?
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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    let groupProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    } ()
    
    let groupnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.font = UIFont(name: "PingFangTC-Semibold", size: 22)
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
    
    let distanceHeaderLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.font = UIFont(name: "PingFangTC-Semibold", size: 14)
        label.text = "Distance"
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        return label
    } ()
    
    
    let stepCountHeaderLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.font = UIFont(name: "PingFangTC-Semibold", size: 14)
        label.text = "Steps"
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

    lazy var chatroomContainer: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        let chatTapped = UITapGestureRecognizer(target: self, action: #selector(handleChatRoom))
        chatTapped.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(chatTapped)
        return view
    }()
    
    lazy var chatRoomLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        label.text = "Chatroom"
        let chatTapped = UITapGestureRecognizer(target: self, action: #selector(handleChatRoom))
        chatTapped.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(chatTapped)
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 255, green: 0, blue: 0)
        collectionView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        /*
        tableView.addSubview(headerView)
        headerView.anchor(top: tableView.topAnchor, left: tableView.leftAnchor, bottom: nil, right: tableView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 270)
        headerView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        */
        /*
        view.addSubview(headerView)
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 270)
        headerView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        
        headerView.addSubview(groupMemberTitleLabel)
        groupMemberTitleLabel.anchor(top: nil, left: headerView.leftAnchor, bottom: headerView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
 

         */
        
        collectionView.delegate = self
        collectionView.dataSource = self
       
        fetchGroupMembers()
        
        configureTableView()
        
        fetchLeaderBoard()

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


    
    func configureTableView() {
        
        //tableView = UITableView()
        tableView = UITableView(frame: .zero, style: .grouped)
        //tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.separatorColor = .clear
   
        // disables the scrolling feature for the table view
        
        tableView.register(GroupStatisticsCell.self, forCellReuseIdentifier: statisticsIdentifier)
        
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //tableView.anchor(top: collectionView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //tableView.separatorInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)

        
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
    
    @objc func handleChatRoom() {
        print("open chat room here!!!")
        
        //let chatroomVC = ChatroomVC()
        let chatroomVC = ChatroomVC(collectionViewLayout: UICollectionViewFlowLayout())
        chatroomVC.groupId = groupIdentifier
        navigationController?.pushViewController(chatroomVC, animated: true)
        //chatroomVC.modalPresentationStyle = .fullScreen
        //present(chatroomVC, animated: true, completion:nil)
        
        
    }

    
    func fetchLeaderBoard() {
        let group = DispatchGroup()
             guard let groupId = groupIdentifier else { return }
             
             DataService.instance.REF_USER_GROUPS.child(groupId).child("members").observeSingleEvent(of: .value, with: { (snapshot) in
                 
                 if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                    
                 for snap in snapshots {
                    group.enter()
                     let uid = snap.value as! String
                         print("this snap represents one group member uid \(uid)")
                        
                    Database.fetchLeaderboardUser(with: uid) { (user) in
                        self.userLeaders.append(user)
                        print("This should be the user info \(user)")
                        
                        self.userLeaders.sort(by: { (user1, user2) -> Bool in
                            return user1.distance > user2.distance
                         })
                        
                        group.leave()
                    }
                    
                        

                    }
                    group.notify(queue: DispatchQueue.main) {
                         self.tableView.reloadData()
                        print("This should only be called after the for loop is complete")
                    

                    }
                 }
             })
        }
  /*
    func fetchActivity(withTripId tripId: String) {
          
        Database.fetchActivity(with: tripId) { (post) in
            
            self.activities.append(post)
            
            self.activities.sort(by: { (activity1, activity2) -> Bool in
                return activity1.creationDate > activity2.creationDate
            })
            self.tableView?.reloadData()
        }
    }
   */
    
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
        return 70

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        userLeaders.count
        //return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: statisticsIdentifier, for: indexPath) as! GroupStatisticsCell
        
        //var leader: User!

        //leader =
        
        cell.user = userLeaders[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
            // be carerul not to reload here. will only keep a set amount of spots
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("This is where user should be allowed to join")

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let sectionHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 420))

            /*
            let sectionText = UILabel()
            sectionText.frame = CGRect.init(x: 5, y: 5, width: sectionHeader.frame.width-10, height: sectionHeader.frame.height-10)
            sectionText.text = "Custom Text"
            sectionText.font = .systemFont(ofSize: 14, weight: .bold) // my custom font
            sectionText.textColor = .red // my custom colour
            */
        
            //sectionHeader.addSubview(sectionText)
        sectionHeader.addSubview(headerView)
        headerView.anchor(top: sectionHeader.topAnchor, left: sectionHeader.leftAnchor, bottom: nil, right: sectionHeader.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 420)
        headerView.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 245)
        
        headerView.addSubview(groupProfileImageView)
        groupProfileImageView.anchor(top: headerView.topAnchor, left: headerView.leftAnchor, bottom: nil, right: headerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 220)
        
        headerView.addSubview(groupnameLabel)
        groupnameLabel.anchor(top: groupProfileImageView.bottomAnchor, left: headerView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        headerView.addSubview(collectionView)
        collectionView.anchor(top: groupProfileImageView.bottomAnchor, left: headerView.leftAnchor, bottom: nil, right: headerView.rightAnchor, paddingTop: 80, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 75)
        
        headerView.addSubview(groupMemberTitleLabel)
        groupMemberTitleLabel.anchor(top: nil, left: headerView.leftAnchor, bottom: collectionView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
        
        headerView.addSubview(groupLeadersLabel)
        groupLeadersLabel.anchor(top: nil, left: headerView.leftAnchor, bottom: headerView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
        
        
        headerView.addSubview(distanceHeaderLabel)
        distanceHeaderLabel.anchor(top: nil, left: headerView.leftAnchor, bottom: headerView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 175, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
        
        headerView.addSubview(stepCountHeaderLabel)
        stepCountHeaderLabel.anchor(top: nil, left: distanceHeaderLabel.rightAnchor, bottom: headerView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
        
        headerView.addSubview(chatroomContainer)
        chatroomContainer.anchor(top: nil, left: nil, bottom: collectionView.topAnchor, right: headerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 20, width: 100, height: 40)
        chatroomContainer.layer.cornerRadius = 15
        
        chatroomContainer.addSubview(chatRoomLabel)
        chatRoomLabel.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        chatRoomLabel.centerXAnchor.constraint(equalTo: chatroomContainer.centerXAnchor).isActive = true
        chatRoomLabel.centerYAnchor.constraint(equalTo: chatroomContainer.centerYAnchor).isActive = true
        
            return sectionHeader
        }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 420 // my custom height
        }
    

}



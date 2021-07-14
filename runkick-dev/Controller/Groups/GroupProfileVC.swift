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
            
            // fetching group creator profile
            
            fetchGroupLeader(groupId: groupId)
            
            configureNavigationBar(title: self.groupnameLabel.text ?? "")
            


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
    
    lazy var dailyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Daily", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 80, green: 80, blue: 80), for: .normal)
        button.backgroundColor = UIColor.walkzillaYellow()
        button.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 13)
        button.addTarget(self, action: #selector(handleDailyStatistics), for: .touchUpInside)
        return button
    } ()
    
    lazy var weeklyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Weekly", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 80, green: 80, blue: 80), for: .normal)
        button.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        button.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 13)
        button.addTarget(self, action: #selector(handleWeeklyStatistics), for: .touchUpInside)
        return button
    } ()
    
    
    let memberCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Members: 3"
        label.textColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        return label
    }()
    
    let founderLabel: UILabel = {
        let label = UILabel()
        label.text = "Founder: camfrasier"
        label.textColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        return label
    }()
    
    let goalLabel: UILabel = {
        let label = UILabel()
        label.text = "Goal: 10 check-ins"
        label.textColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        return label
    }()
    
    lazy var homepageBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        let rewardsTap = UITapGestureRecognizer(target: self, action: #selector(handleHomeroom))
        rewardsTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(rewardsTap)
        view.alpha = 1
        return view
    }()
    
    lazy var chatroomBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        let rewardsTap = UITapGestureRecognizer(target: self, action: #selector(handleChatroom))
        rewardsTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(rewardsTap)
        view.alpha = 1
        return view
    }()
    
    lazy var inviteBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        let inviteTap = UITapGestureRecognizer(target: self, action: #selector(handleInvite))
        inviteTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(inviteTap)
        view.alpha = 1
        return view
    }()
    
    let homeroomLabel: UILabel = {
        let label = UILabel()
        label.text = "Members"
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        return label
    }()
    
    let chatroomLabel: UILabel = {
        let label = UILabel()
        label.text = "Chatroom"
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        return label
    }()
    
    let inviteLabel: UILabel = {
        let label = UILabel()
        label.text = "Invite"
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        return label
    }()
    
    lazy var groupHighlightsBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.35)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var lineViewLower: UIView = {
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
    
    lazy var groupsChatroomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    let groupLeaderImageView: CustomImageView = {
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
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.text = "Leaderboard"
        return label
    } ()
    
    let distanceHeaderLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.text = "Distance"
        return label
    } ()
    
    
    let stepCountHeaderLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.text = "Steps"
        return label
    } ()
    
    let averagePaceHeaderLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.text = "CheckIns"
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

    /*
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
*/

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 255, green: 0, blue: 0)
        collectionView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        configureGroupChatroomView()
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        configureNavigationBar(title: self.groupnameLabel.text ?? "")
        
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
        
    

        
        tableView.anchor(top: groupsChatroomView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //tableView.addSubview(collectionView)
        //collectionView.anchor(top: tableView.bottomAnchor, left: tableView.leftAnchor, bottom: nil, right: tableView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 75)
        
        //tableView.separatorInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.walkzillaYellow()

        
    }
    
    func configureNavigationBar(title: String) {
        
        //view.addSubview(navigationController!.navigationBar)

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

        // add or remove nav bar    bottom border
        navigationController?.navigationBar.shadowImage = UIImage()

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
        
        let font = UIFont(name: "ArialRoundedMTBold", size: 17)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1)]
        
        print("this is the title I want \(title)")
        navigationItem.title = title
        
        navigationController?.navigationBar.tintColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        
    }
    
    func configureGroupChatroomView() {
        
        view.addSubview(groupProfileImageView)
         groupProfileImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 240)
        
        
        groupProfileImageView.addSubview(groupLeaderImageView)
        groupLeaderImageView.anchor(top: groupProfileImageView.topAnchor, left: groupProfileImageView.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        groupLeaderImageView.layer.borderWidth = 1
        groupLeaderImageView.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        groupLeaderImageView.layer.cornerRadius = 40 / 2
        
        groupProfileImageView.addSubview(groupHighlightsBackground)
        groupHighlightsBackground.anchor(top: nil, left: groupProfileImageView.leftAnchor, bottom: groupProfileImageView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: 170, height: 90)
        groupHighlightsBackground.layer.cornerRadius = 8
        
        
        groupHighlightsBackground.addSubview(founderLabel)
        founderLabel.anchor(top: groupHighlightsBackground.topAnchor, left: groupHighlightsBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        groupHighlightsBackground.addSubview(memberCountLabel)
        memberCountLabel.anchor(top: founderLabel.bottomAnchor, left: founderLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        groupHighlightsBackground.addSubview(goalLabel)
        goalLabel.anchor(top: memberCountLabel.bottomAnchor, left: founderLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        view.addSubview(groupsChatroomView)
        groupsChatroomView.anchor(top: groupProfileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
        
        groupsChatroomView.addSubview(lineView)
        lineView.anchor(top: nil, left: groupsChatroomView.leftAnchor, bottom: groupsChatroomView.bottomAnchor, right: groupsChatroomView.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 0.75)
        
        groupsChatroomView.addSubview(indicatorView)
        indicatorView.anchor(top: nil, left: lineView.leftAnchor, bottom: lineView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -1, paddingRight: 0, width: 50, height: 4)
        
        groupsChatroomView.addSubview(homepageBackground)
        homepageBackground.anchor(top: nil, left: groupsChatroomView.leftAnchor, bottom: lineView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 25, paddingBottom: 10, paddingRight: 0, width: 80, height: 40)
        
        homepageBackground.addSubview(homeroomLabel)
        homeroomLabel.anchor(top: nil, left: homepageBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        homeroomLabel.centerYAnchor.constraint(equalTo: homepageBackground.centerYAnchor).isActive = true
        
        
        groupsChatroomView.addSubview(inviteBackground)
        inviteBackground.anchor(top: nil, left: homepageBackground.rightAnchor, bottom: lineView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 10, paddingRight: 0, width: 90, height: 40)
        
        inviteBackground.addSubview(inviteLabel)
        inviteLabel.anchor(top: nil, left: inviteBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        inviteLabel.centerYAnchor.constraint(equalTo: inviteBackground.centerYAnchor).isActive = true
        
        
        groupsChatroomView.addSubview(chatroomBackground)
        chatroomBackground.anchor(top: nil, left: nil, bottom: lineView.topAnchor, right: groupsChatroomView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 25, width: 90, height: 40)
        
        chatroomBackground.addSubview(chatroomLabel)
        chatroomLabel.anchor(top: nil, left: nil, bottom: nil, right: chatroomBackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        chatroomLabel.centerYAnchor.constraint(equalTo: chatroomBackground.centerYAnchor).isActive = true
       
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
    
    func fetchGroupLeader(groupId: String) {
        
        
        DataService.instance.REF_USER_GROUPS.child(groupId).child("groupOwnerId").observeSingleEvent(of: .value, with: { (snapshot) in

            let groupOwner = snapshot.value as! String
            
            DataService.instance.REF_USERS.child(groupOwner).child("profileImageURL").observeSingleEvent(of: .value, with: { (snapshot) in
                let imageUrl = snapshot.value as? String
                
                print("a group url for this group is \(imageUrl)")
                
                guard let photoImageUrl = imageUrl else { return }
                self.groupLeaderImageView.loadImage(with: photoImageUrl)
                
            })
            
        })
    }
    
    
    @objc func handleChatroom() {
        print("open chat room here!!!")
        
        //let chatroomVC = ChatroomVC()
        let chatroomVC = ChatroomVC(collectionViewLayout: UICollectionViewFlowLayout())
        chatroomVC.groupId = groupIdentifier
        navigationController?.pushViewController(chatroomVC, animated: true)
        //chatroomVC.modalPresentationStyle = .fullScreen
        //present(chatroomVC, animated: true, completion:nil)
        
        
    }
    
    @objc func handleHomeroom() {
        print("handle homeroom")
    }
    
    @objc func handleInvite() {
        print("handle invite")
    }
    
    @objc func handleDailyStatistics() {
        print("handle daily")
        
        weeklyButton.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        weeklyButton.layer.borderColor = UIColor.rgb(red: 180, green: 180, blue: 180).cgColor
        weeklyButton.layer.borderWidth = 0.5
        
        dailyButton.backgroundColor = UIColor.walkzillaYellow()
        dailyButton.layer.borderWidth = 0
    }
    
    @objc func handleWeeklyStatistics() {
        print("handle weekly")
        
        weeklyButton.backgroundColor = UIColor.walkzillaYellow()
        weeklyButton.layer.borderWidth = 0
        
        
        dailyButton.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        dailyButton.layer.borderColor = UIColor.rgb(red: 180, green: 180, blue: 180).cgColor
        dailyButton.layer.borderWidth = 0.5
        
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

        let width = 80
 
        return CGSize(width: width, height: width + 18)
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
        return 30

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
        
        print("This is where user analytics can be viewed. analytics page profile")
    
    tableView.deselectRow(at: indexPath, animated: true)

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
        headerView.anchor(top: sectionHeader.topAnchor, left: sectionHeader.leftAnchor, bottom: nil, right: sectionHeader.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 220)
        headerView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        headerView.addSubview(collectionView)
        collectionView.anchor(top: headerView.topAnchor, left: headerView.leftAnchor, bottom: nil, right: headerView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 105)
        
       // headerView.addSubview(groupProfileImageView)
       // groupProfileImageView.anchor(top: collectionView.bottomAnchor, left: headerView.leftAnchor, bottom: nil, right: headerView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 240)
        
        //headerView.addSubview(groupnameLabel)
        //groupnameLabel.anchor(top: groupProfileImageView.bottomAnchor, left: headerView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        

        
        //headerView.addSubview(groupMemberTitleLabel)
        //groupMemberTitleLabel.anchor(top: nil, left: headerView.leftAnchor, bottom: collectionView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
        
        headerView.addSubview(dailyButton)
        dailyButton.anchor(top: collectionView.bottomAnchor, left: headerView.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 100, height: 40)
        dailyButton.layer.cornerRadius = 20

        
        headerView.addSubview(weeklyButton)
        weeklyButton.anchor(top: dailyButton.topAnchor, left: dailyButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 100, height: 40)
        weeklyButton.layer.cornerRadius = 20
        weeklyButton.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        weeklyButton.layer.borderColor = UIColor.rgb(red: 180, green: 180, blue: 180).cgColor
        weeklyButton.layer.borderWidth = 0.5
        
        
        
        headerView.addSubview(groupLeadersLabel)
        groupLeadersLabel.anchor(top: collectionView.bottomAnchor, left: headerView.leftAnchor, bottom: nil, right: nil, paddingTop: 71, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        headerView.addSubview(distanceHeaderLabel)
        distanceHeaderLabel.anchor(top: groupLeadersLabel.topAnchor, left: headerView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 165, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        headerView.addSubview(stepCountHeaderLabel)
        stepCountHeaderLabel.anchor(top: groupLeadersLabel.topAnchor, left: distanceHeaderLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 21, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        headerView.addSubview(averagePaceHeaderLabel)
        averagePaceHeaderLabel.anchor(top: groupLeadersLabel.topAnchor, left: stepCountHeaderLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 38, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        headerView.addSubview(lineViewLower)
        lineViewLower.anchor(top: nil, left: headerView.leftAnchor, bottom: headerView.bottomAnchor, right: headerView.rightAnchor, paddingTop: 0, paddingLeft: 32, paddingBottom: 0, paddingRight: 30, width: 0, height: 0.75)
        
        /*
        headerView.addSubview(chatroomContainer)
        chatroomContainer.anchor(top: nil, left: nil, bottom: collectionView.topAnchor, right: headerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 20, width: 100, height: 40)
        chatroomContainer.layer.cornerRadius = 18
        headerView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        chatroomContainer.addSubview(chatRoomLabel)
        chatRoomLabel.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        chatRoomLabel.centerXAnchor.constraint(equalTo: chatroomContainer.centerXAnchor).isActive = true
        chatRoomLabel.centerYAnchor.constraint(equalTo: chatroomContainer.centerYAnchor).isActive = true
        */
            return sectionHeader
        }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 220 // my custom height
        }
    

}



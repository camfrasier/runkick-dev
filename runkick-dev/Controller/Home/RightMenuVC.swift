//
//  RightMenuVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 4/18/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "RightMenuOptionCell"
private let reuseGroupsCellIdentifier = "GroupsCell"

class RightMenuVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var activities = [Activity]()
    var activity: Activity?
    var currentKey: String?
    
    var tableView: UITableView!
    var delegate: HomeControllerDelegate?
    var searchBar = UISearchBar()
    var inSearchMode = false
    //var homeVC: HomeVC?
    
    var collectionView: UICollectionView!
     

    let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return view
    }()
    
    let menuSubView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 181, green: 201, blue: 215)

        return view
    }()
    
    let gradientView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        return view
    }()
    
    let searchBarBlackLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        return view
    }()
    
    let hoziontalSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        return view
    }()
    
    lazy var groupsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.rgb(red: 180, green: 180, blue: 180)
        label.text = "Groups"
        let groupTap = UITapGestureRecognizer(target: self, action: #selector(handleGroupsTapped))
        groupTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(groupTap)
        return label
    } ()
    /*
    lazy var messageInboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "simpleMarineCircleSendText"), for: .normal)
        button.addTarget(self, action: #selector(handleMessagesTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        button.layer.borderWidth = 3
        button.alpha = 1
        button.backgroundColor = .clear
        return button
    }()
    */
    lazy var activityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        //label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.textColor = UIColor.statusBarGreenDeep()
        label.text = "Activity"
        let activityTap = UITapGestureRecognizer(target: self, action: #selector(handleActivityTapped))
        activityTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(activityTap)
        return label
    } ()
    
    let separatorViewGradient: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.airBnBNew().cgColor
        return view
    }()
    
    lazy var rightTabView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 245).cgColor
        let groupTap = UITapGestureRecognizer(target: self, action: #selector(handleGroupsTapped))
        groupTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(groupTap)
        return view
    }()
    
    lazy var leftTabView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        let activityTap = UITapGestureRecognizer(target: self, action: #selector(handleActivityTapped))
        activityTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(activityTap)
        return view
    }()
    
    
    let searchBarContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        view.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    let searchBarBoarder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        return view
    }()
    
    /*
    lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 122, green: 206, blue: 33)

        /*
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        //attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        */
        
        // add gesture recognizer
        //let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        followTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        
        return label
    } ()
    
    lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 122, green: 206, blue: 33)
        
        /*
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        //attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        */
        
        // add gesture recognizer
        //let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        followTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    } ()
    
    lazy var postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 122, green: 206, blue: 33)
        
        //let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        //attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)]))
        //label.attributedText = attributedText
        
        //let postTap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        postTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(postTap)
        return label
    } ()
    */
    
    let avatarBackgroundButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setImage(UIImage(named: "trueBlueCirclePlus"), for: .normal)
        //button.addTarget(self, action: #selector(handleAnalyticsTapped), for: .touchUpInside)
        button.backgroundColor = UIColor.rgb(red: 122, green: 206, blue: 53)
        button.layer.cornerRadius = 50 / 2
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.alpha = 1
        return button
    }()
    
    let beBoppAvatarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "beBoppIconHeadBand"), for: .normal)
        //button.addTarget(self, action: #selector(handleAnalyticsTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.alpha = 1
        return button
       }()
    

    let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 3
        view.alpha = 1
        return view
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        
        
        fetchActivityPosts()
        
        //fetchCurrentUserData()
        
        //setUserStats()
        
        configureTableView()
        
        // configure collection view
        configureCollectionView()
        
        //configureViewComponents()

        // adjust the corner radius of the slide menu view
        let myControlLayer: CALayer = self.view.layer
        myControlLayer.masksToBounds = true
        myControlLayer.cornerRadius = 10
        
        //view.addSubview(indicatorView)
        //indicatorView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 60, height: 7)
        //indicatorView.centerX(inView: view)
        

        // configure refresh control
        let refreshFeedControl = UIRefreshControl()
        refreshFeedControl.addTarget(self, action: #selector(handleFeedRefresh), for: .valueChanged)
        tableView?.refreshControl = refreshFeedControl
        

        
        // configure the listener for when the keyboard shows up
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // configure the listener for when the keyboard goes down
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
            

    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            // the UI responder finds the exact diminsions of the keyboard frame for us. We can utilze this for other diminsions
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            print(keyboardFrame)
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height - 50 : -60
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {
                // calling this function will help perform the smooth animation
                self.view.layoutIfNeeded()
                
            }) { (completed) in
                
            }
            
            
            //bottomConstraint?.constant = -keyboardFrame.height
        }
        
    }

/*
    func fetchActivityPosts() {
        
        print("fetch activity function called")
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        // fetching posts with pagination and only observing x amount of post at a time
        
        if currentKey == nil {
            DataService.instance.REF_ACTIVITY.child(currentUid).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.tableView?.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let tripId = snapshot.key
                    self.fetchActivity(withTripId: tripId)
                    print("DEBUG: SNAPSHOT \(snapshot)")
                    })
                self.currentKey = first.key
            
        })
        } else {
            DataService.instance.REF_ACTIVITY.child(currentUid).queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 6).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let tripId = snapshot.key
                    if tripId != self.currentKey {
                        self.fetchActivity(withTripId: tripId)
                        print("DEBUG: SNAPSHOT AFTER SCROLL \(snapshot)")
                    }
                })
                self.currentKey = first.key
                })
        }
    }
*/
    
    func configureSearchBar() {
        
        //let navBarHeight = CGFloat((navigationController?.navigationBar.frame.size.height)!)

        
        searchBar.delegate = self
        //navigationItem.titleView = searchBar
        
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        //searchBar.becomeFirstResponder()  // this command displays the search bar as soon as the view presents
        searchBar.autocapitalizationType = .none
        //searchBar.frame.origin.y = 0
        
        
        // SearchBar text
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor.red
        textFieldInsideUISearchBar?.font = textFieldInsideUISearchBar?.font?.withSize(19)
        
        searchBar.isTranslucent = false
        searchBar.tintColor = UIColor.rgb(red: 0, green: 0, blue: 0) // changes the text
        searchBar.alpha = 1
        
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            //searchBar.searchTextField.backgroundColor = UIColor.rgb(red: 181, green: 201, blue: 215)
            searchBar.searchTextField.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 245)
            searchBar.searchTextField.layer.cornerRadius = 17
            searchBar.searchTextField.layer.masksToBounds = true
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 12)!], for: .normal)
            
    
        } else {
            // Fallback on earlier versions
        }
     
        
        searchBarContainer.addSubview(searchBar)
        searchBar.anchor(top: searchBarContainer.topAnchor, left: searchBarContainer.leftAnchor, bottom: searchBarContainer.bottomAnchor, right: searchBarContainer.rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        
        
        searchBar.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        searchBar.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        searchBar.layer.borderWidth = 2

        
    }
    
    func fetchActivityPosts() {
        
        print("fetch activity function called")
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        // fetching posts with pagination and only observing x amount of post at a time
        
        if currentKey == nil {
            DataService.instance.REF_ACTIVITY.child(currentUid).queryLimited(toLast: 1).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.tableView?.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let tripId = snapshot.key
                    self.fetchActivity(withTripId: tripId)
                    print("DEBUG: SNAPSHOT \(snapshot)")
                    })
                self.currentKey = first.key
            
        })
        }
    }
    
    func fetchActivity(withTripId tripId: String) {
          
        Database.fetchActivity(with: tripId) { (post) in
            
            self.activities.append(post)
            
            self.activities.sort(by: { (activity1, activity2) -> Bool in
                return activity1.creationDate > activity2.creationDate
            })
            self.tableView?.reloadData()
        }
    }
    
    @objc func handleFeedRefresh() {
        // this is a screen pull down function to refresh you feed
        activities.removeAll(keepingCapacity: false)
        self.currentKey = nil
        fetchActivityPosts()
        
        tableView?.reloadData()
        
        // would like to reload 
        let rightMenuCell = RightMenuOptionCell()
        rightMenuCell.animateDistanceCircle()
    }
    
    @objc func handleGroupsTapped() {
        //delegate?.handleGridViewTapped(for: self)
        
        configureSearchBar()
        /*
        //separatorViewGradient.transform = CGAffineTransform(translationX: 1, y: 1)
        collectionView.isHidden = false
        searchBarContainer.isHidden = false
        
        
        groupsLabel.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        activityLabel.textColor = UIColor.rgb(red: 180, green: 180, blue: 180)
        leftTabView.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 245)
        rightTabView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        */
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.collectionView.isHidden = false
            self.searchBarContainer.isHidden = false
            
            self.groupsLabel.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
            self.activityLabel.textColor = UIColor.rgb(red: 180, green: 180, blue: 180)
            self.leftTabView.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 245)
            self.rightTabView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
            
            self.separatorViewGradient.transform = CGAffineTransform(translationX: self.view.frame.width / 2, y: 0)
        })
    }
    
    @objc func handleActivityTapped() {
        //delegate?.handleActivityTapped(for: self)
        
        /*
        collectionView.isHidden = true
        searchBarContainer.isHidden = true
        
        activityLabel.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        groupsLabel.textColor = UIColor.rgb(red: 180, green: 180, blue: 180)
        leftTabView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        rightTabView.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 245)
        */
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.separatorViewGradient.transform = CGAffineTransform(translationX: 0, y: 0)
            
            self.collectionView.isHidden = true
            self.searchBarContainer.isHidden = true
            
            //self.activityLabel.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
            self.activityLabel.textColor = UIColor.statusBarGreenDeep()
            self.groupsLabel.textColor = UIColor.rgb(red: 180, green: 180, blue: 180)
            self.leftTabView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
            self.rightTabView.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 245)
        })
        
        
        view.endEditing(true)
    }
    
    func handleDissmissKeyboard() {
        view.endEditing(true)
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        // register right menu table view
        tableView.register(RightMenuOptionCell.self, forCellReuseIdentifier: reuseIdentifier)
        //tableView.backgroundColor = UIColor(red: 181/255, green: 201/255, blue: 215/255, alpha: 1)
        tableView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
        tableView.rowHeight = 450
        
        // disables the scrolling feature for the table view
        tableView.isScrollEnabled = true

        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
  
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 45, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        view.addSubview(gradientView)
        gradientView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        gradientView.addSubview(leftTabView)
        leftTabView.anchor(top: gradientView.topAnchor, left: gradientView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width / 2, height: 50)
        
        gradientView.addSubview(rightTabView)
        rightTabView.anchor(top: gradientView.topAnchor, left: nil, bottom: nil, right: gradientView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width / 2, height: 50)
        
        leftTabView.addSubview(activityLabel)
        activityLabel.anchor(top: leftTabView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        activityLabel.centerXAnchor.constraint(equalTo: leftTabView.centerXAnchor).isActive = true
        
        rightTabView.addSubview(groupsLabel)
        groupsLabel.anchor(top: rightTabView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        groupsLabel.centerXAnchor.constraint(equalTo: rightTabView.centerXAnchor).isActive = true
        
        //gradientView.addSubview(separatorViewGradient)
        //separatorViewGradient.anchor(top: nil, left: view.leftAnchor, bottom: gradientView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 75, paddingBottom: 1, paddingRight: 0, width: (view.frame.width / 8), height: 3)
        
        //gradientView.addSubview(hoziontalSeparatorView)
        //hoziontalSeparatorView.anchor(top: gradientView.topAnchor, left: gradientView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: view.frame.width / 2, paddingBottom: 0, paddingRight: 0, width: 0.25, height: 80)
        //hoziontalSeparatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //gradientView.addSubview(separatorView)
        //separatorView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 79, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
        


        

        
        /*
        //view.addSubview(tableSuperView)
        tableView.addSubview(tableSuperView)
        
        tableSuperView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 407, paddingLeft: 0, paddingBottom: 0, paddingRight: 340, width: 0, height: 0)
        
        tableSuperView.addSubview(postLabel)
        postLabel.anchor(top: tableSuperView.topAnchor, left: nil, bottom: nil, right: tableSuperView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)
        
        tableSuperView.addSubview(followersLabel)
        followersLabel.anchor(top: postLabel.topAnchor, left: postLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 55, paddingLeft: 0, paddingBottom: 0, paddingRight: 2, width: 0, height: 0)
        
        tableSuperView.addSubview(followingLabel)
        followingLabel.anchor(top: followersLabel.topAnchor, left: followersLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 55, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        */
        
    }
    
    // MARK: - UICollectionView
       
       func configureCollectionView() {
           
           // define the collection view characteristics
           
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .vertical
           
           //let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - (tabBarController?.tabBar.frame.height)! - (navigationController?.navigationBar.frame.height)!)
           //let frame = CGRect(x: 0, y: 115, width: view.frame.width, height: view.frame.height - 270)
        let frame = CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height - 50)

        
           collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
           collectionView.delegate = self
           collectionView.dataSource = self
           collectionView.alwaysBounceVertical = true
           collectionView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
            collectionView.isHidden = true
        searchBarContainer.isHidden = true
        
           view.addSubview(collectionView)
           collectionView.register(GroupsCell.self, forCellWithReuseIdentifier: reuseGroupsCellIdentifier)
        
       view.addSubview(searchBarContainer)
        //searchBarContainer.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 45, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
        searchBarContainer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        

        
        
        searchBarContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[container]-0-|", options: [], metrics: nil, views: ["container": searchBarContainer]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[container(60)]", options: [], metrics: nil, views: ["container": searchBarContainer]))
        
        // create the bottom constraint here in order to mutate or move it along with the keyboard
        // adjusting the constant value manipulates the bottom anchor
        bottomConstraint = NSLayoutConstraint(item: searchBarContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -60)
        view.addConstraint(bottomConstraint!)
        
        //view.addSubview(searchBarBlackLine)
        //searchBarBlackLine.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 110, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
        
       
                   
           tableView.separatorColor = .clear
           
           //tableView.separatorInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
           
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 1
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 2
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           
           return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           //let width = (view.frame.width - 16) / 3
           let width = (view.frame.width - 8) / 3
           return CGSize(width: width, height: width)
       }
       
       /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
           return CGSize(width: view.frame.width, height: 200)
       }*/
       
       func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
           /*
           if posts.count > 20 {
               if indexPath.item == posts.count - 1 {
                   fetchPosts()
               }
           }
            */
       }
       
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           //return posts.count
        return 9
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseGroupsCellIdentifier, for: indexPath) as! GroupsCell
           /*
           cell.post = posts[indexPath.item]
           */
           return cell
       }
       
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("you selected a cell")
           /*
           let feedVC = FeedVC(collectionViewLayout: UICollectionViewFlowLayout())
           
           feedVC.viewSinglePost = true
           
           feedVC.post = posts[indexPath.item]
           
           navigationController?.pushViewController(feedVC, animated: true)
            */
       }
       
    
    /*
    
    func fetchCurrentUserData() {
        
        // Set the user in header.
        // May need this later for pulling user running values
    
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USERS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            
            guard let profileImageUrl = user.profileImageURL else { return }
            //self.profileImageView.loadImage(with: profileImageUrl)
        
            guard let username = user.username else { return }
            guard let firstname = user.firstname else { return }
            
            //self.usernameLabel.text = username
            //self.firstnameLabel.text = firstname
        }
    }
    
    func setUserStats() {

        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var numberOfFollwers: Int!
        var numberOfFollowing: Int!
        var numberOfPosts: Int!
        
        // get number of followers
        DataService.instance.REF_FOLLOWER.child(uid).observe(.value) { (snapshot) in // Observe doesn't just do it one time. It updates in REALTIME in Firebase.
            
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                numberOfFollwers = snapshot.count
            } else {
                numberOfFollwers = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollwers!)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
            //attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)]))
            
            self.followersLabel.attributedText = attributedText
        }
        
        // get number of following
        DataService.instance.REF_FOLLOWING.child(uid).observe(.value) { (snapshot) in
            
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                numberOfFollowing = snapshot.count
            } else {
                numberOfFollowing = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollowing!)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
            //attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)]))
            
            self.followingLabel.attributedText = attributedText
        }
        
        // get number of posts
        DataService.instance.REF_USER_POSTS.child(uid).observe(.value) { (snapshot) in
            
            if let snapshot = snapshot.value as? Dictionary<String, AnyObject> {
                numberOfPosts = snapshot.count
            } else {
                numberOfPosts = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfPosts!)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 19)])
            //attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)]))
            
            self.postLabel.attributedText = attributedText
        }
    }
    
    func configureViewComponents() {
           
           view.addSubview(titleView)
           titleView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60)

           //titleView.layer.shadowColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 0.50).cgColor
           //titleView.layer.shadowOffset = CGSize(width: 0, height: 2)
           //titleView.layer.shadowRadius = 3.0
           //titleView.layer.shadowOpacity = 0.80
           
           titleView.addSubview(separatorView)
           separatorView.anchor(top: nil, left: titleView.leftAnchor, bottom: titleView.bottomAnchor, right: titleView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
           
        /*
        let backgroundDimension: CGFloat = 60
        titleView.addSubview(avatarBackgroundButton)
        avatarBackgroundButton.anchor(top: titleView.topAnchor, left: titleView.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: backgroundDimension, height: backgroundDimension)
        avatarBackgroundButton.layer.cornerRadius = backgroundDimension / 2
        */
        
        //avatarBackgroundButton.addSubview(beBoppAvatarButton)
        //beBoppAvatarButton.anchor(top: avatarBackgroundButton.topAnchor, left: avatarBackgroundButton.leftAnchor, bottom: nil, right: nil, paddingTop: 7, paddingLeft: 5.5, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        
        //tableView.addSubview(tableSuperView)
        //tableSuperView.anchor(top: tableView.topAnchor, left: nil, bottom: nil, right: tableView.rightAnchor, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 100, width: 50, height: 50)

        
        /*
           let stackView = UIStackView(arrangedSubviews: [followersLabel, followingLabel, postLabel])
           stackView.axis = .horizontal
           stackView.distribution = .equalSpacing
           stackView.alignment = .center
           titleView.addSubview(stackView)
        stackView.anchor(top: avatarBackgroundButton.topAnchor, left: avatarBackgroundButton.rightAnchor, bottom: nil, right: titleView.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        */
       }
    
    // MARK: - Handlers (We want to delegate these actions to the controller).
    
    @objc func handleFollowersTapped() {
        print("handle followers tapped")
    }
    
    @objc func handleFollowingTapped() {
        print("handle following tapped")
    }
    
    @objc func handlePostTapped() {
        print("handle posts tapped")
    }
    
    @objc func handleAnalyticsTapped() {
        print("handle analytics tapped")
    }
 */
}

    
extension RightMenuVC: UITableViewDelegate, UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         //return 1
         activities.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RightMenuOptionCell
         
         //cell.delegate = self
         cell.activity = activities[indexPath.row]
           
    
         /*
         // the below will allow us to bring back a value based on the option pressed
         let rightMenuOption = RightMenuOption(rawValue: indexPath.row)
         cell.descriptionLabel.text = rightMenuOption?.description
         cell.iconImageView.image = rightMenuOption?.image
         cell.iconImageView2.image = rightMenuOption?.image2
         */
         return cell
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         //let rightMenuOption = RightMenuOption(rawValue: indexPath.row)
         //delegate?.handleRightMenuToggle(shouldDismiss: true, rightMenuOption: rightMenuOption)
         
         print("THIS IS SELECTED")
         tableView.deselectRow(at: indexPath, animated: true)
     }
     
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
             if activities.count > 4 {
             if indexPath.item == activities.count - 1 {
                 fetchActivityPosts()
             }
         }
     }
    
    
/*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
        activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RightMenuOptionCell
        
        //cell.delegate = self
        cell.activity = activities[indexPath.row]
          
   
        /*
        // the below will allow us to bring back a value based on the option pressed
        let rightMenuOption = RightMenuOption(rawValue: indexPath.row)
        cell.descriptionLabel.text = rightMenuOption?.description
        cell.iconImageView.image = rightMenuOption?.image
        cell.iconImageView2.image = rightMenuOption?.image2
        */
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let rightMenuOption = RightMenuOption(rawValue: indexPath.row)
        //delegate?.handleRightMenuToggle(shouldDismiss: true, rightMenuOption: rightMenuOption)
        
        print("THIS IS SELECTED")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if activities.count > 4 {
            if indexPath.item == activities.count - 1 {
                fetchActivityPosts()
            }
        }
    }
*/

}

// MARK: - UISearchBarDelegate

extension RightMenuVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        handleDissmissKeyboard()
        print("cancel button clicked here")
   
        /*
       // configureSearchBarButton()
        inSearchMode = false
        
        searchBar.text = nil
        navigationItem.titleView = nil
        
        collectionView.reloadData()
        
        configureSearchBarButton()
        */
    }
    
     
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("did beginning editing here")
        
        // text printing out the text real time
        print(searchText)
        /*
        if searchText == "" || searchBar.text == nil {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            // whatever pokemon we are looking at look at there name and see if there name contains that search text, here $0 represnts any categories array
            filteredCategories = categories.filter({ $0.category?.range(of: searchText) != nil
                
                return ($0.category?.localizedCaseInsensitiveContains(searchText))!
            })
            collectionView.reloadData()

        }
 */
    }
    
}


//
//  FeedVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/19/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel

private let reuseIdentifier = "Cell"
private let reuseCheckInIdentifier = "CheckInCell"
private let reuseCarouselIdentifier = "CarouselCell"
private let reuseScrollIdentifier = "ScrollViewCell"


class FeedVC: UIViewController, FeedCellDelegate, UIScrollViewDelegate {
    
    /*
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    */
    
    // MARK: - Properties
    var homeVC: HomeVC!
    var circleVC: CircleVC!
    var posts = [Post]() // This need to be a variable so we can mutate it.
    //var logoData = [Logos]()
    //var logos: Logos?
    var viewSinglePost = false
    var post: Post?
    var currentKey: String?
    var userCurrentKey: String?
    var userProfileController: UserProfileVC?
    var value: String?
    var users = [User]()
    var tableView: UITableView!
  
    
    
    /*
    fileprivate let collectionViewHorizontal: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        //cv.register(UserCarouselCell.self, forCellWithReuseIdentifier: reuseCarouselIdentifier)
        return cv
    }()
    */
    
    fileprivate let collectionViewVertical: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        //cv.register(UserCarouselCell.self, forCellWithReuseIdentifier: reuseCarouselIdentifier)
        return cv
    }()
    
    lazy var collectionViewHorizontal: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize = .zero
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.contentInset = .zero
        return cv
    }()
    
    let headerView: UIView = {
        let view = UIView()
        //view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    let lineView: UIView = {
        let view = UIView()
        //view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore"
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        label.font = UIFont(name: "PingFangTC-Semibold", size: 28)
        return label
    }()
    
    // here we are using the class photo feed view in order to pull up the photo we need from the subclass
    let photoFeedView: PhotoFeedView = {
        let view = PhotoFeedView()
        //view.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "userProfileIcon")
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(handleProfileSelected))
        profileTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(profileTap)
        return iv
    }()
    
    let photoCommentButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "actionButton"), for: .normal)
        //button.setImage(UIImage(named: "trueBlueCirclePlus"), for: .normal)
        button.addTarget(self, action: #selector(handlePhotoButton), for: .touchUpInside)
        button.backgroundColor = .clear
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.alpha = 1
        return button
    }()
    
    let beBoppActionButton: UIButton = {
           let button = UIButton(type: .custom)
           button.setImage(UIImage(named: "beBoppAddPhotoIcon"), for: .normal)
           button.addTarget(self, action: #selector(handlePhotoButton), for: .touchUpInside)
           button.backgroundColor = .clear
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
           button.alpha = 1
           return button
       }()
    /*
    let photoCommentBackground: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.55).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.isUserInteractionEnabled = true
        let photoCommentTap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoButton))
        photoCommentTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(photoCommentTap)
        view.alpha = 1
        return view
    }()
    */
    
    lazy var photoCommentShadowBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.actionRed()
        let menuTap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoButton))
        menuTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(menuTap)
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.55).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.alpha = 1
        return view
    }()
    
    let photoCommentBackground: GradientActionView = {
        let view = GradientActionView()
        //view.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.55).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.isUserInteractionEnabled = true
        let shoppingCartTap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoButton))
        shoppingCartTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(shoppingCartTap)
        view.alpha = 1
        return view
    }()
    
    
    let tabGradientView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        //view.layer.shadowColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 0.98).cgColor
        //view.layer.shadowColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 0.50).cgColor
        //view.layer.shadowOffset = CGSize(width: 0, height: 2)
        //view.layer.shadowRadius = 18.0
        //view.layer.shadowOpacity = 0.80
        //view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.alpha = 1
        return view
    }()
    
    let timelineBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
        view.alpha = 1
        return view
    }()
    
    lazy var feedTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.text = "Explore"
        label.textAlignment = .left
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        return label
    } ()
    
    
    let stackIndicatorBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.95)
        view.layer.cornerRadius = 3
        view.alpha = 0.95
        return view
    } ()
    
    lazy var notificationsLabel: UILabel = {
        let label = UILabel()
        //label.layer.backgroundColor = UIColor.rgb(red: 220, green: 30, blue: 30).cgColor
        label.backgroundColor = .clear
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "Notifications"
        label.textAlignment = .center
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.95)
        
        // add gesture recognizer to label
        let notificationsTap = UITapGestureRecognizer(target: self, action: #selector(handleNotificationView))
        notificationsTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(notificationsTap)
        label.alpha = 0.95
        return label
    } ()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        //label.layer.backgroundColor = UIColor.rgb(red: 220, green: 30, blue: 30).cgColor
        label.backgroundColor = .clear
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "Messages"
        label.textAlignment = .center
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.95)
        
        // add gesture recognizer to label
        let messagesTap = UITapGestureRecognizer(target: self, action: #selector(handleMessageInboxView))
        messagesTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(messagesTap)
        label.alpha = 0.95
        return label
    } ()
    
    
    enum PostType: String {

        case userPost = "userPost"
        case checkIn = "checkIn"
    }
    

    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // adding blur effect with this function at alpha 0 initially
        configureViewComponents()
        
        fetchProfileData()
        
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        /*
        //extends the edges beyound the tab bar
        edgesForExtendedLayout = .top
        extendedLayoutIncludesOpaqueBars = true
        */

        // uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //self.collectionView = collectionViewHorizontal
        //collectionViewHorizontal.delegate = self
        //collectionViewHorizontal.dataSource = self
        
        
        //collectionViewHorizontal.register(UserCarouselCell.self, forCellWithReuseIdentifier: reuseCarouselIdentifier)
        collectionViewHorizontal.register(UserCarouselCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseCarouselIdentifier)
        
        
        configureNavigationBar()
        
        // register cell classes
        
        collectionViewVertical.delegate = self
        collectionViewVertical.dataSource = self
        collectionViewVertical.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionViewVertical.register(CheckInCell.self, forCellWithReuseIdentifier: reuseCheckInIdentifier)
      

        
        // configure refresh control
        let refreshFeedControl = UIRefreshControl()
        refreshFeedControl.addTarget(self, action: #selector(handleFeedRefresh), for: .valueChanged)
        collectionViewVertical.refreshControl = refreshFeedControl
        
        //collectionView.addSubview(feedTitleLabel)
        //feedTitleLabel.anchor(top: collectionView.topAnchor, left: collectionView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        /*
        view.addSubview(headerView)
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 90)
            headerView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        view.addSubview(lineView)
        lineView.anchor(top: nil, left: headerView.leftAnchor, bottom: headerView.bottomAnchor, right: headerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        lineView.backgroundColor = UIColor.rgb(red: 210, green: 210, blue: 210)
        
        headerView.addSubview(collectionViewHorizontal)
        collectionViewHorizontal.anchor(top: headerView.topAnchor, left: headerView.leftAnchor, bottom: nil, right: headerView.rightAnchor, paddingTop: -10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: headerView.frame.width, height: 90)
        collectionViewHorizontal.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        */
        
        view.addSubview(collectionViewVertical)
        collectionViewVertical.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        collectionViewVertical.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        

        
        /*
        headerView.frame = CGRect(x: 0, y: 0, width: collectionViewVertical.frame.width, height: collectionViewVertical.frame.height)
        view.addSubview(headerView)
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        headerView.backgroundColor = UIColor.rgb(red: 255, green: 0, blue: 0)
        */
        
        configureFeedViewElements()
        
        //configureNotificationComponents()
        
        //setUserFCMTocken()
        
        // fetch posts if we are not viewing a single post
        if !viewSinglePost {
            fetchPosts()
            fetchUsers()
        }
        
        updateUserFeeds()
        
        configureTabBar()
        
        if let flowLayout = collectionViewVertical.collectionViewLayout as? UICollectionViewFlowLayout {
            //flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        }
        
     
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // adding shadow view to the tab bar
        
        //tabBarController?.tabBar.isTranslucent = false
        
        /*
        tabBarController?.tabBar.layer.cornerRadius = 15
        tabBarController?.tabBar.layer.masksToBounds = true
        tabBarController?.tabBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        tabBarController?.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
           
        configureTabBar()
        //configureNavigationBar()
    }
    

    // this function ensures the navigation bar is filled after transitioning to a regular nav bar
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.layoutSubviews()
    }
    
    
    // MARK: UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width
        var height = bounds.size.height
        
        /*
           let postUrl = posts[indexPath.item].imageUrl
           let postId = posts[indexPath.item].postId


        let url = URL(string: postUrl!)!
               
           Database.fetchDimensions(with: url) { (photoImage) in
               let imageWidth = photoImage.size.width
               let imageHeight = photoImage.size.height
               
               
               
               if imageWidth > imageHeight {
                    
                    print("The image width is \(imageWidth) and the image height is \(imageHeight) and the postId is \(postId)")

                   
               } else {
                   
                   print("The image width is \(imageWidth) and the image height is \(imageHeight) and the postId is \(postId)")
               }
           }
        */
        
        if collectionView == self.collectionViewHorizontal {
            let width = 70

            return CGSize(width: width, height: width + 15)
        }
        
        
        if viewSinglePost {
            if let post = self.post {
                    
                if let captionText = posts[indexPath.item].caption {
                                  
                    let rect = NSString(string: captionText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
                
                    return CGSize(width: width, height: (height - 200) + rect.height)
                }
            }
  
        } else {
            

            let postType = posts[indexPath.item].type

               if postType == "checkIn" {

                          if let captionText = posts[indexPath.item].type {
                 
                                  print("the post type is \(postType) and we got here")
                              let rect = NSString(string: captionText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
                
                                print("the height value that is added for \(captionText) should be\(rect.height)")
                                //return CGSize(width: view.frame.width, height: (view.frame.height - 90) + rect.height)
                            return CGSize(width: width, height: height - 60)
                              }

               } else {
                
                let photoStyle = posts[indexPath.item].photoStyle
       
            if photoStyle == "landscape" {
                    
            print("Photo is landscape")
            // if statement safely unwraps status text
            if let captionText = posts[indexPath.item].caption {
                

                let rect = NSString(string: captionText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
   
                    return CGSize(width: width, height: (height - 300) + rect.height)
            
                    }
                } else {
                    
                print("Photo is portrait")
                
                if let captionText = posts[indexPath.item].caption {
                        

                        let rect = NSString(string: captionText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
      
                    return CGSize(width: width, height: (height - 200) + rect.height)
                }
            }
            }
             
        }
           
        return CGSize(width: width, height: height - 250)
        
        
    }

 /*
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewHorizontal {
            if users.count > 9 {
                if indexPath.item == users.count - 1 {
                    fetchUsers()
                    
                    print("We have actually reach the horizontal collection view")
                }
            }
        }
        
        print("We have actually can't reach the collection view horizontal")
        
        if posts.count > 4 {
            if indexPath.item == posts.count - 1 {
                fetchPosts()
            }
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionViewHorizontal {
            
            return users.count
            
        }
        
        // this logic will allow us to click on our profile and recieve just that picture that was selected and use the FeedVC code
        if viewSinglePost {
            return 1
        } else {
            return posts.count
        }
            
        
    }
    
    // creates a space between top cell and cell view... right before scrolling is enabled.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //return CGSize(width: view.frame.width, height: 10)
        return CGSize(width: view.frame.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // sets the vertical spacing between posts
        
        if collectionView == self.collectionViewHorizontal {
            return 2
        }
        return 0
    }
    
    // calling function to give space and insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        if collectionView == self.collectionViewHorizontal {
            return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        }
        
        //return UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        return UIEdgeInsets(top: 55, left: 0, bottom: 0, right: 0)
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("DEBUG: THE CHECKIN FUNCTION WAS HIT")

    if collectionView == self.collectionViewHorizontal {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCarouselIdentifier, for: indexPath) as! UserCarouselCell
            
            cellA.user = users[indexPath.item]

            //cell.delegate = self
            print("Do we reach this point")
            return cellA
   }
        
        
        
        let post = posts[indexPath.item]
        
        //let type = PostType.init(rawValue: post.type)
       let type = PostType.init(rawValue: post.type)
        
        switch type {
            
        case .checkIn:
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCheckInIdentifier, for: indexPath) as! CheckInCell
            
            // running through the checkin function to make sure we relaod, however on a second reload it won't work because it will be true
            
            //let checkInCell = CheckInCell()
            //checkInCell.setToTrue(false)
            //print("Setting the did load funtions")
        
            cell.delegate = self
            cell.post = posts[indexPath.item]

            //value = cell.post?.postId
            //print("THE VALUE IS EQUAL TO")
            

            
            return cell
            
        case .userPost:
            print("DEBUG: show the normal upload cell")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
            
            cell.delegate = self
            
            // delegate to view long press post
            cell.altDelegate = self
            
            if viewSinglePost {
                if let post = self.post {
                    cell.post = post
                }
            } else {
                cell.post = posts[indexPath.item]

            }
            
            handleHastagTapped(forCell: cell)
            
            handleUsernameLabelTapped(forCell: cell)
            
            handleMentionedTapped(forCell: cell)
            
            return cell

        case .none:
    
            return UICollectionViewCell()
            
        }
        
        /*
        // if caption section is not empty then the post is more than likely a check in
        
        if (posts[indexPath.item].caption == nil) {
            
            print("DEBUG: show the normal upload cell")
            // else post as a check in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCheckInIdentifier, for: indexPath) as! CheckInCell
            
            cell.delegate = self
            
            cell.post = posts[indexPath.item]
            
            return cell
            
        } else {
            
            print("DEBUG: show the normal upload cell")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
            
            cell.delegate = self
            
            // delegate to view long press post
            cell.altDelegate = self
            
            if viewSinglePost {
                if let post = self.post {
                    cell.post = post
                }
            } else {
                cell.post = posts[indexPath.item]

            }
            
            handleHastagTapped(forCell: cell)
            
            handleUsernameLabelTapped(forCell: cell)
            
            handleMentionedTapped(forCell: cell)
            
            return cell

        }
        */
      
       
    }
    */
    
   
    func fetchUsers() {

        if userCurrentKey == nil {
            DataService.instance.REF_USERS.queryLimited(toLast: 4).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let uid = snapshot.key
                    
                    Database.fetchUser(with: uid, completion: { (user) in
                        self.users.append(user)
                        self.collectionViewHorizontal.reloadData()
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
                            self.collectionViewHorizontal.reloadData()
                        })
                    }
                })
                self.userCurrentKey = first.key
            })
        }
    }
    
    func configureViewComponents() {
        
        
        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            
            if let window:UIWindow = applicationDelegate.window {
                
                window.addSubview(visualEffectView)
                visualEffectView.anchor(top: window.topAnchor, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
                visualEffectView.alpha = 0
                
                let gesture = UITapGestureRecognizer(target: self, action: #selector(handleBlurDismiss))
                visualEffectView.addGestureRecognizer(gesture)
            }
        }
        
        //collectionView.addSubview(titleLabel)
        //titleLabel.anchor(top: collectionView.topAnchor, left: collectionView.leftAnchor, bottom: nil, right: nil, paddingTop: -10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    

    func configureNotificationComponents() {

        let stackView = UIStackView(arrangedSubviews: [messageLabel, stackIndicatorBar, notificationsLabel])
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 14
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackIndicatorBar.anchor(top: stackView.topAnchor, left: nil, bottom: stackView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 3, height: 0)
        stackIndicatorBar.layer.cornerRadius = 1
        
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 110, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        //stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.isUserInteractionEnabled = true
        
        navigationController?.navigationBar.topItem?.titleView = stackView
        //navigationController?.navigationBar.addSubview(stackView)
        
        
        /*
        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            
            if let window:UIWindow = applicationDelegate.window {
                
                let stackView = UIStackView(arrangedSubviews: [messageLabel, notificationsLabel])
                
                stackView.axis = .horizontal
                stackView.distribution = .equalSpacing
                stackView.alignment = .center
                stackView.spacing = 16
                stackView.translatesAutoresizingMaskIntoConstraints = false
                
                window.addSubview(stackView)
                stackView.anchor(top: window.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
                stackView.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                stackView.backgroundColor = .lightGray
  
            }
        }
        */
    }
    
    @objc func handleBlurDismiss() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.visualEffectView.alpha = 0
            self.photoFeedView.alpha = 0
            self.photoFeedView.transform = CGAffineTransform(scaleX: 1.75, y: 1.75)
        }) { (_) in
            self.photoFeedView.removeFromSuperview()
        }
        
    }
    
    @objc func handleProfileSelected() {
        print("DEBUG: Profile view selected")
        
        let profileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        //profileVC.modalPresentationStyle = .fullScreen
        //present(profileVC, animated: true, completion:nil)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func fetchProfileData() {
        
        // Set the user in header.
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USERS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            
            guard let profileImageUrl = user.profileImageURL else { return }
            self.profileImageView.loadImage(with: profileImageUrl)
        }
    }
    
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pan = scrollView.panGestureRecognizer
        let velocity = pan.velocity(in: scrollView).y
        if velocity < -5 {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            //self.navigationController?.setToolbarHidden(true, animated: true)
         
            
        } else if velocity > 5 {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            //self.navigationController?.setToolbarHidden(false, animated: true)
        }
    }
*/
    
    func configureNavigationBar() {
        /*
        //make navigation bar clear
         //navigationController?.navigationBar.isHidden = true
         self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
         self.navigationController?.navigationBar.shadowImage = UIImage()
         self.navigationController?.navigationBar.isTranslucent = true
        */
        
        
        // add or remove nav bar bottom border
        navigationController?.navigationBar.shadowImage = UIImage()
        let lineView = UIView(frame: CGRect(x: 0, y: 45, width: view.frame.width, height: 0.25))
        lineView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
         
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //navigationController?.navigationBar.barTintColor = UIColor.walkzillaRed()
        
        let font = UIFont(name: "PingFangTC-Semibold", size: 17)!
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 0, green: 0, blue: 0)]
        navigationItem.title = ""
        
        
        /*
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
            navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 0, green: 0, blue: 0), NSAttributedString.Key.backgroundColor: UIColor.clear, NSAttributedString.Key.font: UIFont(name: "PingFangTC-Semibold", size: 24)!]
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
         */
        
        //navigationItem.title = "Explore"
            
        // custom profile image view of current user
        
        
            /*
            profileImageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            profileImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 32, height: 32 )
            profileImageView.backgroundColor = .clear
            profileImageView.layer.cornerRadius = 32 / 2

            let profileView = UIBarButtonItem(customView: profileImageView)
            self.navigationItem.leftBarButtonItems = [profileView]
            */
        
            
        
        
        /*
        navigationController?.navigationBar.isTranslucent = false
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // if you want subsequent views to never user large titles automatically
        //navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

        //UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
         
        //let font = UIFont(name: "HelveticaNeue-Bold", size: 17)!
        //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)]


        //navigationController?.navigationBar.tintColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        navigationController?.navigationBar.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1),NSAttributedString.Key.font: UIFont(name: "Arial-Med", size: 24) ?? UIFont.boldSystemFont(ofSize: 28)]
        
        navigationItem.title = "Feed"
    
        
        navigationController?.navigationBar.addSubview(timelineBarView)
        timelineBarView.anchor(top: navigationController?.navigationBar.bottomAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: nil, right: navigationController?.navigationBar.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
        
        /*
        // adding logo to navigation bar
        let logo = UIImage(named: "waywalkLogoBlack")
        let imageView = UIImageView(image: logo)
        
        imageView.contentMode = .scaleAspectFit
        navigationController?.navigationBar.topItem?.titleView = imageView
        */
        
        
        
        
       
        
        
        //let notifcationImage = UIImage(named: "simpleBlueBell-25x25")
            
        //let notificationButton = UIBarButtonItem(image: notifcationImage, style: .plain, target: self, action: #selector(handleNotificationView))
        
        //self.navigationItem.rightBarButtonItems = [notificationButton]
        //self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 9/255, green: 171/255, blue: 231/255, alpha: 1)
        
        
        
        // can add a boolean statement here for notifications buttons to be included
        
        let customFeedTitle = UIButton(type: UIButton.ButtonType.custom)
        customFeedTitle.frame = CGRect(x: 0, y: 15, width: 40, height: 30)
        
        //let leftBarFont = UIFont(name: "HelveticaNeue-Bold", size: 25)!
        //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: leftBarFont, NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
                   
        customFeedTitle.setTitle("Notifications", for: .normal)
        customFeedTitle.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        customFeedTitle.setTitleColor(UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1), for: .normal)
        
        
            
        customFeedTitle.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //customSearchTitle.addTarget(self, action: #selector(handleSearchFriends), for: .touchUpInside)
        
        customFeedTitle.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        let barFeedButton = UIBarButtonItem(customView: customFeedTitle)
        //self.navigationItem.leftBarButtonItems = [barFeedButton]

        
        */
        
        // custom notifications button
         
        
        
        /*
                   let adminStorePostButton = UIButton(type: UIButton.ButtonType.system)
                       
                       adminStorePostButton.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
                       
                       //using this code to show the true image without rendering color
                       adminStorePostButton.setImage(UIImage(named:"roundedSqaureThin")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        adminStorePostButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 23, height: 23 )
        adminStorePostButton.addTarget(self, action: #selector(handleNotificationView), for: .touchUpInside)
                       adminStorePostButton.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
                       adminStorePostButton.backgroundColor = .clear
               
               let adminFeedButton = UIBarButtonItem(customView: adminStorePostButton)
               self.navigationItem.rightBarButtonItems = [adminFeedButton]
 
        */
 
        
 
        
        /*
        // custom back button
         
         let profileViewButton = UIButton(type: UIButton.ButtonType.custom)
         
         profileViewButton.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
         
         //using this code to show the true image without rendering color
         profileViewButton.setImage(UIImage(named:"profileImageIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
         profileViewButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 24, height: 25 )
        profileViewButton.addTarget(self, action: #selector(handleProfileSelected), for: .touchUpInside)
         profileViewButton.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
         profileViewButton.backgroundColor = .clear
             
         let profileButton = UIBarButtonItem(customView: profileViewButton)
         self.navigationItem.leftBarButtonItems = [profileButton]
        
        */
 
        
    }
    
    @objc func handleBackButton() {
           _ = self.navigationController?.popViewController(animated: true)
       }
    
    @objc func handleSearchFriends() {
        
        let searchVC = SearchVC()

        searchVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(searchVC, animated: true)
        //present(notificationsVC, animated: true, completion:nil)
        
    }
    
    @objc func handleNotificationView() {
        
        let notificationsVC = NotificationsVC()

        notificationsVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(notificationsVC, animated: true)
        //present(notificationsVC, animated: true, completion:nil)
    }
    
    @objc func handleMessageInboxView() {
        
        let messagesVC = MessagesController()

        messagesVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(messagesVC, animated: true)
    }
    
    func configureFeedViewElements() {
        
        //let circleViewDimension = 50
        
        
        //view.addSubview(backgroundPhotoIconButton)
        //backgroundPhotoIconButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 15, width: CGFloat(circleViewDimension), height: CGFloat(circleViewDimension))
        //backgroundPhotoIconButton.layer.cornerRadius = CGFloat(circleViewDimension / 2)
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USERS.child(currentUserId).child("isStoreadmin").observe(.value) { (snapshot) in
        let isStoreadmin = snapshot.value as! Bool
        
        print(snapshot.value as! Bool)
            
            if isStoreadmin == true {
                
                // if user is a super user do nothing else  display the buttong on the feed view.
                
            } else {
                
                // this was the code to show photo comment, button but adding to tab bar now.
                
                /*
                let tabBarHeight = CGFloat((self.tabBarController?.tabBar.frame.size.height)!)
                
                self.view.addSubview(self.photoCommentShadowBackground)
                self.photoCommentShadowBackground.anchor(top: nil, left: nil, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 20, width: 60, height: 60)
                self.photoCommentShadowBackground.layer.cornerRadius = 15
                
                self.photoCommentShadowBackground.addSubview(self.photoCommentBackground)
                self.photoCommentBackground.anchor(top: self.photoCommentShadowBackground.topAnchor, left: self.photoCommentShadowBackground.leftAnchor, bottom: self.photoCommentShadowBackground.bottomAnchor, right: self.photoCommentShadowBackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
                self.photoCommentBackground.layer.cornerRadius = 15
                
                self.photoCommentBackground.addSubview(self.beBoppActionButton)
                self.beBoppActionButton.anchor(top: self.photoCommentBackground.topAnchor, left: self.photoCommentBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 7, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
                
                */
                
            }
        }

    }
    
    
    
    // MARK: - API
    
    func updateUserFeeds() {
        
        // function that allows all followed user post to show up in their feed, retroactively
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // reach into the user-following database to determine which users are following other users
        DataService.instance.REF_FOLLOWING.child(currentUid).observe(.childAdded) { (snapshot) in
            
            let followingUserId = snapshot.key
            
            DataService.instance.REF_USER_POSTS.child(followingUserId).observe(.childAdded, with: { (snapshot) in
                
                let postId = snapshot.key
                
                DataService.instance.REF_FEED.child(currentUid).updateChildValues([postId: 1])
            })
        }
        
        DataService.instance.REF_USER_POSTS.child(currentUid).observe(.childAdded) { (snapshot) in
            
            let postId = snapshot.key
            
            DataService.instance.REF_FEED.child(currentUid).updateChildValues([postId: 1])
        }
    }
    
    //func setUserFCMTocken() {
    func setUserFCMToken() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let fcmToken = Messaging.messaging().fcmToken else { return }
        
        let values = ["fcmToken": fcmToken]
        
        DataService.instance.REF_USERS.child(currentUid).updateChildValues(values)
    }
    
    func fetchPosts() {
        print("HOW MANY TIMES IS THIS CALLED")
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        // fetching posts with pagination and only observing x amount of post at a time
        
        if currentKey == nil {
            DataService.instance.REF_FEED.child(currentUid).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.collectionViewVertical.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                
                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    
                    print("we know what type to look fooooor \(postId)")
                    self.fetchPost(withPostId: postId)
                    
                })
                self.currentKey = first.key
            })
        } else {
            DataService.instance.REF_FEED.child(currentUid).queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 6).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    if postId != self.currentKey {
                        self.fetchPost(withPostId: postId)
                    }
                })
                self.currentKey = first.key
            })
        }
    }
    
    // helper function
    func fetchPost(withPostId postId: String) {

        Database.fetchPost(with: postId) { (post) in
            
            self.posts.append(post)
            
            self.posts.sort(by: { (post1, post2) -> Bool in
                return post1.creationDate > post2.creationDate
            })
            self.collectionViewVertical.reloadData()
        }
    }
    
    // MARK: - FeedCellDelegate Protocol
    
    // follow the IG tutorial from Udemy lesson #35
    
    func handleUsernameTapped(for cell: FeedCell) {
        
        guard let post = cell.post else { return } // accessing post value from the post value in the FeedCell
       
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        userProfileVC.user = post.user
        
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    func handleFollowFollowingTapped(for cell: FeedCell) {
        
        guard let post = cell.post else { return }
    
            if cell.followFollowingLabel.text == "follow" {
                cell.followFollowingLabel.text = "following"
                cell.followFollowingLabel.font = UIFont.systemFont(ofSize: 16)
                print("The user just tapped to follow this profile")
                post.follow()
            } else {
                cell.followFollowingLabel.text = "follow"
                cell.followFollowingLabel.font = UIFont.boldSystemFont(ofSize: 16)
                post.unfollow()
                print("This user just unfollowed this profile")
            }
    }
    
    func handleOptionTapped(for cell: FeedCell) {
        
        // if user is super user or if user is the current user ... allow all of these options..
        
        guard let post = cell.post else { return }
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USERS.child(currentUserId).child("isStoreadmin").observe(.value) { (snapshot) in
        let isStoreadmin = snapshot.value as! Bool
        
        print(snapshot.value as! Bool)
        
            if post.ownerUid == currentUserId || isStoreadmin == true {    // this is the profile screen for users
            
                print("DEBUG: The user is either the user who owns the post or a super user")
                
                let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
                
                alertController.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { (_) in
                    
                    // this function can be found under the post class
                    post.deletePost(post.ownerUid)
                    
                    // if we are in our reguar feed mode
                    if !self.viewSinglePost {
                        self.handleFeedRefresh()
                    } else {
                        if let userProfileController = self.userProfileController {
                            _ = self.navigationController?.popViewController(animated: true)
                            userProfileController.handleRefresh()
                        }
                    }
                }))
                
                alertController.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { (_) in
                    
                    let uploadPostController = UploadPostVC()
                    let navigationController = UINavigationController(rootViewController: uploadPostController)
                    uploadPostController.postToEdit = post
                    uploadPostController.uploadAction = UploadPostVC.UploadAction(index: 1)
                    self.present(navigationController, animated: true, completion: nil)
                    
                }))
                
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            
            
            }
        }
        
    
        
        
        /*
        if post.ownerUid == Auth.auth().currentUser?.uid {
            
            let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { (_) in
                
                post.deletePost()
                
                // if we are in our reguar feed mode
                if !self.viewSinglePost {
                    self.handleFeedRefresh()
                } else {
                    if let userProfileController = self.userProfileController {
                        _ = self.navigationController?.popViewController(animated: true)
                        userProfileController.handleRefresh()
                    }
                }
            }))
            
            alertController.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { (_) in
                
                let uploadPostController = UploadPostVC()
                let navigationController = UINavigationController(rootViewController: uploadPostController)
                uploadPostController.postToEdit = post
                uploadPostController.uploadAction = UploadPostVC.UploadAction(index: 1)
                self.present(navigationController, animated: true, completion: nil)
                
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
        */
    }
    
    func handlePhotoTapped(for cell: FeedCell) {
        
        print("This will be a photo display eventually")
        /*
        guard let post = cell.post else { return }
        let commentVC = CommentVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        // sending this postId over to the comment view controller
        commentVC.post = post
        navigationController?.pushViewController(commentVC, animated: true)
        */
    }
    
    func handleLikeTapped(for cell: FeedCell, isDoubleTap: Bool) {
        
        guard let post = cell.post else { return }
        
        
        cell.newLikeButton.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
                   
                   UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                       
                    cell.newLikeButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                       
                   }) { (_) in
                    cell.newLikeButton.transform = .identity
        }
    
        if post.didLike {
            // handle unlike post
            if !isDoubleTap {
                post.adjustLikes(addLike: false, completion: { (likes) in
                    cell.likesLabel.text = "\(likes)"
                    //cell.newLikeButton.setImage(UIImage(named: "heartOutline"), for: .normal)
                      //cell.newLikeButton.setImage(UIImage(named: "heartOutline"), for: .normal)
                    cell.newLikeButton.backgroundColor = UIColor.clear
                    cell.newLikeButton.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255), for: .normal)
                    cell.newLikeButton.alpha = 1
                })
            }
      
        } else {
            // handle like post
            post.adjustLikes(addLike: true, completion: { (likes) in
                cell.likesLabel.text = "\(likes)"
                //cell.newLikeButton.setImage(UIImage(named: "heartOutlineSelected"), for: .normal)
                cell.newLikeButton.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
                cell.newLikeButton.setTitleColor(UIColor.rgb(red: 0, green: 0, blue: 0), for: .normal)
                cell.newLikeButton.alpha = 1
                
            })
        }
    }
    
    func handleShowLikes(for cell: FeedCell) {
        guard let post = cell.post else { return }
        guard let postId = post.postId else { return }
        
        let followLikeVC = FollowLikeVC()
        followLikeVC.viewingMode = FollowLikeVC.ViewingMode(index: 2)
        followLikeVC.postId = postId
        navigationController?.pushViewController(followLikeVC, animated: true)
    }
    
    func handleConfigureLikeButton(for cell: FeedCell) {
        
        guard let post = cell.post else { return }
        guard let postId = post.postId else { return }
        
        // guard statements are placed under individual func so it can be considered optional
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USER_LIKES.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            
            // check if post id exists in user-like structure
                       if snapshot.hasChild(postId) {
                           post.didLike = true
                           //cell.newLikeButton.setImage(UIImage(named: "heartOutlineSelected"), for: .normal)
                        cell.newLikeButton.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
                        cell.newLikeButton.setTitleColor(UIColor.rgb(red: 0, green: 0, blue: 0), for: .normal)
                            cell.newLikeButton.alpha = 1
                       } else {
                           post.didLike = false
                           //cell.newLikeButton.setImage(UIImage(named: "heartOutline"), for: .normal)
                        cell.newLikeButton.backgroundColor = UIColor.clear
                        cell.newLikeButton.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255), for: .normal)
                        cell.newLikeButton.alpha = 1
                       }
            
            /*
            if snapshot.hasChild(postId) {
                
                print("HERE IS THE POST ID\(postId)")
                // setting this to true maintains the liked status after a refresh gesture
                // this may work for maintaining the status of store admin and setting the userVariable LoginVC
                post.didLike = true
                cell.newLikeButton.setImage(UIImage(named: "heartOutlineSelected"), for: .normal)
                cell.newLikeButton.alpha = 0.80
            }
            */
        }
    }
    
    func handleCommentTapped(for cell: FeedCell) {
        
        cell.newComment.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
                   
                   UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                       
                    cell.newComment.transform = CGAffineTransform(scaleX: 1, y: 1)
                       
                   }) { (_) in
                    cell.newComment.transform = .identity
        }
        
        print("comment button tapped")
        guard let post = cell.post else { return }
        let commentVC = CommentVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        // sending this postId over to the comment view controller
        commentVC.post = post
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
    // MARK: - Handlers
    
    @objc func handleFeedRefresh() {
                
        // this is a screen pull down function to refresh you feed
        
        posts.removeAll(keepingCapacity: false)

        self.currentKey = nil
        fetchPosts()
        
        let feedCell = FeedCell()
        feedCell.configureLikeButton()
        
        collectionViewVertical.reloadData()
        

    }
    
    @objc func handleShowMessages() {
        let messagesController = MessagesController()
        navigationController?.pushViewController(messagesController, animated: true)
        
    }
    
    @objc func handlePhotoButton() {
        print("handle photo and caption button")
        
        let selectImageVC = SelectImageVC(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: selectImageVC)
        navController.modalPresentationStyle = .fullScreen
        //navController.navigationBar.tintColor = .black
        
        present(navController, animated: true, completion: nil)
    }
    
    func handleHastagTapped(forCell cell: FeedCell) {
        cell.captionLabel.handleHashtagTap { (hashtag) in
            let hashtagController = HashtagController(collectionViewLayout: UICollectionViewFlowLayout())
            hashtagController.hashtag = hashtag
            self.navigationController?.pushViewController(hashtagController, animated: true)
        }
    }
    
    func handleMentionedTapped(forCell cell: FeedCell) {
        cell.captionLabel.handleMentionTap { (username) in
            self.getMentionedUser(withUsername: username)
        }
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
    
    func handleUsernameLabelTapped(forCell cell: FeedCell) {
        
        guard let user = cell.post?.user else { return }
        guard let username = user.username else { return }
        
        // look for username as pattern
        let customType = ActiveType.custom(pattern: "^\(username)\\b")
        
        cell.captionLabel.handleCustomTap(for: customType) { (_) in
            
            let userProfilerController = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
            userProfilerController.user = user
            self.navigationController?.pushViewController(userProfilerController, animated: true)
        }
    }
    
}

// calling the function to present the photo view
extension FeedVC: AltFeedCellDelegate {
    func presentPhotoFeedView(withFeedCell post: Post) {
    
        
        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            
            if let window:UIWindow = applicationDelegate.window {

                window.addSubview(photoFeedView)
                // need this to be able to dismiss the photo feed view
                photoFeedView.delegate = self
                
                
                // this is saying which ever feed post you passed into this feed cell, we will display that same post and it's post elements here
                photoFeedView.post = post
                
                
                //photoFeedView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: window.frame.width - 50, height: 525)
                
                //window.anchor(top: window.topAnchor, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)
                //window.layer.cornerRadius = 15
                
                photoFeedView.anchor(top: window.topAnchor, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: window.frame.width, height: window.frame.width)
                //photoFeedView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                photoFeedView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                //photoFeedView.layer.cornerRadius = 0
                photoFeedView.clipsToBounds = true
                //photoFeedView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -14).isActive = true
                
                // should start with a zoomed out and animate into a zoomed in effect
                photoFeedView.transform = CGAffineTransform(scaleX: 0.15, y: 0.15)
                photoFeedView.alpha = 0
                
                UIView.animate(withDuration: 0.5) {
                    self.visualEffectView.alpha = 1
                    self.photoFeedView.alpha = 1
                    self.photoFeedView.transform = .identity
                    
                }
                
            }
        }
   
        
    }
}


extension FeedVC: PhotoFeedViewDelegate {
    func dismissPhotoFeedView(withFeed post: Post?) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.photoFeedView.alpha = 0
            self.photoFeedView.transform = CGAffineTransform(scaleX: 5, y: 5)
        }) { (_) in
            self.photoFeedView.removeFromSuperview()
        }
    }
}

extension FeedVC: CheckInCellDelegate {
    func handleUsernameTapped(for cell: CheckInCell) {
        print("username tapped")
    }
    
    func handleOptionTapped(for cell: CheckInCell) {
        
        
        // if user is super user or if user is the current user ... allow all of these options..
        
        guard let post = cell.post else { return }
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USERS.child(currentUserId).child("isStoreadmin").observe(.value) { (snapshot) in
        let isStoreadmin = snapshot.value as! Bool
        
        print(snapshot.value as! Bool)
        
            if post.ownerUid == currentUserId || isStoreadmin == true {    // this is the profile screen for users
            
                print("DEBUG: The user is either the user who owns the post or a super user")
                
                let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
                
                alertController.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { (_) in
                    
                    // this function can be found under the post class
                    post.deleteCheckInPost(post.ownerUid)
                    
                    // if we are in our reguar feed mode
                    if !self.viewSinglePost {
                        self.handleFeedRefresh()
                    } else {
                        if let userProfileController = self.userProfileController {
                            _ = self.navigationController?.popViewController(animated: true)
                            userProfileController.handleRefresh()
                        }
                    }
                }))
                /*
                alertController.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { (_) in
                    
                    let uploadPostController = UploadPostVC()
                    let navigationController = UINavigationController(rootViewController: uploadPostController)
                    uploadPostController.postToEdit = post
                    uploadPostController.uploadAction = UploadPostVC.UploadAction(index: 1)
                    self.present(navigationController, animated: true, completion: nil)
                    
                }))
                */
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            
            
            }
        }
        
    }
    
    func handleFollowFollowingTapped(for cell: CheckInCell) {
        print("username tapped")
    }
    
    func handleLikeTapped(for cell: CheckInCell, isDoubleTap: Bool) {
        print("username tapped")
    }
    
    func handlePhotoTapped(for cell: CheckInCell) {
        print("username tapped")
    }
    
    func handleCommentTapped(for cell: CheckInCell) {
        print("username tapped")
    }
    
    func handleConfigureLikeButton(for cell: CheckInCell) {
        print("username tapped")
    }
    
    func handleShowLikes(for cell: CheckInCell) {
        print("username tapped")
    }
    

}

extension FeedVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
      func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         
         if collectionView == collectionViewHorizontal {
             if users.count > 9 {
                 if indexPath.item == users.count - 1 {
                     fetchUsers()
                     
                     print("We have actually reach the horizontal collection view")
                 }
             }
         }
         
         print("We have actually can't reach the collection view horizontal")
         
         if posts.count > 4 {
             if indexPath.item == posts.count - 1 {
                 fetchPosts()
                //self.navigationController?.setNavigationBarHidden(true, animated: true)
             }
         }
     }

     func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 1
     }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         
         if collectionView == self.collectionViewHorizontal {
             
             return users.count
             
         }
         
         // this logic will allow us to click on our profile and recieve just that picture that was selected and use the FeedVC code
         if viewSinglePost {
             return 1
         } else {
             return posts.count
         }
             
         
     }
     
    /*
     // creates a space between top cell and cell view... right before scrolling is enabled.
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
         //return CGSize(width: view.frame.width, height: 10)
         return CGSize(width: view.frame.width, height: 0)
     }
     */
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         // sets the vertical spacing between posts
         
         if collectionView == self.collectionViewHorizontal {
             return 2
         }
         return 10
     }
     
     // calling function to give space and insets
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

         if collectionView == self.collectionViewHorizontal {
             return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
         }
         
         //return UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
         return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
     }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {

        case UICollectionView.elementKindSectionHeader:

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeadView", for: indexPath)

            headerView.backgroundColor = UIColor.blue;
            return headerView

        default:

            fatalError("Unexpected element kind")
        }
    }
     

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         print("DEBUG: THE CHECKIN FUNCTION WAS HIT")

     if collectionView == self.collectionViewHorizontal {
             let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCarouselIdentifier, for: indexPath) as! UserCarouselCell
             
             cellA.user = users[indexPath.item]

             //cell.delegate = self
             print("Do we reach this point")
             return cellA
    }
         
         
         
         let post = posts[indexPath.item]
         
         //let type = PostType.init(rawValue: post.type)
        let type = PostType.init(rawValue: post.type)
         
         switch type {
             
         case .checkIn:
             
             
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCheckInIdentifier, for: indexPath) as! CheckInCell
             
             // running through the checkin function to make sure we relaod, however on a second reload it won't work because it will be true
             
             //let checkInCell = CheckInCell()
             //checkInCell.setToTrue(false)
             //print("Setting the did load funtions")
         
             cell.delegate = self
             cell.post = posts[indexPath.item]

             //value = cell.post?.postId
             //print("THE VALUE IS EQUAL TO")
             

             
             return cell
             
         case .userPost:
             print("DEBUG: show the normal upload cell")
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
             
             cell.delegate = self
             
             // delegate to view long press post
             cell.altDelegate = self
             
             if viewSinglePost {
                 if let post = self.post {
                     cell.post = post
                 }
             } else {
                 cell.post = posts[indexPath.item]
                 
                /*
                let dimensionUrl = cell.post?.imageUrl
 
                let url = URL(string: dimensionUrl!)
                
                URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    
                    // Handle our error
                    if let error = error {
                        print("Failed to load image with error", error.localizedDescription)
                    }
                    
                    // Image data.
                    guard let imageData = data else { return }
                    
                    
                    // Set image using image data.
                    let photoImage = UIImage(data: imageData)
                    
                    let imageWidth = photoImage?.size.width
                    let imageHeight = photoImage?.size.height
                    print("this is the photo width \(imageWidth) and this is the height \(imageHeight)")
                    
                    // Create key and value for image cache.
                    //imageCache[url!.absoluteString] = photoImage
                    
                    // Set our image.
                    DispatchQueue.main.async {
                        //self.image = photoImage
                        
                        //print("This is the phot heigjt \(photoImage?.size.height)")
                    }
                    }.resume()
                */
             }
             
             handleHastagTapped(forCell: cell)
             
             handleUsernameLabelTapped(forCell: cell)
             
             handleMentionedTapped(forCell: cell)
             
             return cell

         case .none:
     
             return UICollectionViewCell()
             
         }
    }

     
}




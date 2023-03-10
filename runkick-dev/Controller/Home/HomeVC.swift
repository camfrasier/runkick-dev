//
//  HomeVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/4/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreMotion
import RevealingSplashView
import Firebase
import Contacts
import UserNotifications



class HomeVC: UIViewController, Alertable {
    
    let reuseIdentifier = "SearchStoreCell"
    
    // MARK: - Map Properties
    
    
    var mapView: MKMapView!
    var manager: CLLocationManager?
    var regionRadius: CLLocationDistance = 750
    var route: MKRoute!
    var selectedItemPlacemark: MKPlacemark? = nil
    var selectedAnnotation: MKPointAnnotation?
    var tempCustomAnnotation: CKAnnotationView?
    //var accuracyRangeCircle: MKCircle?
    var rtPolyline: MKPolyline?
    var totalDistance = 0.0
    var totalSteps = 0
    
    var locationList: [CLLocation] = []
    //private let locationManager = LocationManager.shared
    var seconds = 0
    var newTimer: Timer?
    var recordedDistance = Measurement(value: 0, unit: UnitLength.meters)
    var run: Run!
    
    
    var oldSource: MKMapItem?
    var savedSource: MKMapItem?
    var savedDestination: MKMapItem?
    var removeSource: MKMapItem?
    var coordinate: CLLocationCoordinate2D?
    var matchingItems: [MKMapItem] = [MKMapItem]()
    var originCoordinate = CLLocationCoordinate2D()
    var destinCoordinate = CLLocationCoordinate2D()
    var pathDestination = CLLocationCoordinate2D()
    var selectedMapAnnotation: MKMapItem?
    
    // ui view properties
    var expansionState: ExpansionState!
    var tableView = UITableView()
    var frame: UITableView!

    // file reference properties
    var rootRef: DatabaseReference!
    var posts = [StoreAnnotation]()
    var stores = [Store]()
    var storeDetailView: StoreDetailView!
    var filteredStores = [Store]()
    //var user: User?
    
    // boolean properties
    
    var saveSegmentVisible = Bool()
    var hasCompletedLoading = false
    var inSearchMode = false
    var directionsEnabled = false
    //var splashViewRevealed = false
    var isStoreDetailViewVisible = Bool()
    var isSearchTableViewVisible = Bool()
    var initialCheckpointSelected = false
    var isMenuExpanded = Bool()
    var isRightMenuExpanded = Bool()
    //var isLoginViewExpanded = Bool()
    var loginPopUpExpanded = Bool()
    var isNotificationsExpanded = Bool()
    var didSetUserOrigin = Bool()
    var didSetPolylineOrigin = false
    var secondSegmentSelected = Bool()
    var startTripPressed = false
    var checkpointReached = false
    
    
    
    
    
    //var isStoreViewAtOrigin = Bool()
    //var storeViewCalled = Bool()
    
    // placeholder properties
    var i = Int( )
    var monVal = 1
    var count = Int()
    var keyHolder = String()
    var tripHolder = String()
    
    var finalSegmentId: String!
    var searchBar = UISearchBar()
    var storeCurrentKey: String?
    
    let customMenuButton = UIButton(type: UIButton.ButtonType.custom)
    let customMenuButtonArrow = UIButton(type: UIButton.ButtonType.custom)
    let customProfileButton = UIButton(type: UIButton.ButtonType.custom)
    
    //let revealingSplashView = RevealingSplashView(iconImage:UIImage(named: "waywalkGothicTextWhite")!,iconInitialSize: CGSize(width: 160, height: 150), backgroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1))
    
    let blackView = UIView()
    let rightMenuBV = UIView()
    let storeDetailBV = UIView()
    let loginViewBV = UIView()
    
    let menuVC = MenuVC()
    let rightMenuVC = RightMenuVC()
    let userSettingsVC = UserSettingsVC()
    let storeCell = StoreCell()
    let searchStoreCell = SearchStoreCell()
    let notificationsVC = NotificationsVC()
    let groupMessageController = GroupMessageController()
    let loginVC = LoginVC()
    //var user: User?
    
    
    
    let stopColor = UIColor.rgb(red: 255, green: 0, blue: 0)
    let startColor = UIColor.rgb(red: 0, green: 255, blue: 0)
    
    // values for the pedometer data.. will probably create a class for these values
    var numberOfSteps: Int!
    
    var distance: Double!
    var averagePace: Double!
    var pace: Double!
    // pedometer object
    var pedometer = CMPedometer()
    
    // these two properties will allow you to compute elapsed time
    var timer = Timer()
    let timerInterval = 1.0
    var timeElapsed: TimeInterval = 0.0
    var childByAutoKey: String!
    var didCreateFolder = false
    var logoNum = 1

    
    enum ExpansionState {
        case NotExpanded
        case PartiallyExpanded
        case FullyExpanded
    }
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return cv
    }()
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    } ()
    
    let statusTitle: UILabel = {
        let label = UILabel()
        label.text = "Status: None"
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 17)
        label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.backgroundColor = .white
        return label
    }()
    
    let stepsLabel: UILabel = {
        let label = UILabel()
        label.text = "Steps: None"
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 17)
        label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.backgroundColor = .white
        return label
    }()
    
    let paceLabel: UILabel = {
        let label = UILabel()
        label.text = "Pace: None"
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 17)
        label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let averagePaceLabel: UILabel = {
        let label = UILabel()
        label.text = "Avg Pace: None"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 17)
        label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.backgroundColor = .white
        return label
    }()
    
    let pedoDistanceLabel: UILabel = {
        let label = UILabel()
        //label.text = "Distance: None"
        label.text = "0.00"
        label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 130)
        label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.alpha = 0
        return label
    }()
    
    let milesLabel: UILabel = {
        let label = UILabel()
        //label.text = "Distance: None"
        label.text = "MILES"
        label.font = UIFont(name: "AvenirNextCondensed-BoldItalic", size: 24)
        label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.alpha = 0
        return label
    }()
    
    /*
    let activityLabel: UILabel = {
        let label = UILabel()
        //label.text = "Distance: None"
        label.text = "Recent Activity"
        //label.font = UIFont(name: "Avenir-Black", size: 15)
        label.font = UIFont(name: "ArialRoundedMTBold", size: 12)
        label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    */
    
    let notificationBolt: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "sideBoltIcon"), for: .normal)
        button.addTarget(self, action: #selector(expansionStateCheckRight), for: .touchUpInside)
        button.tintColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        button.alpha = 1
        return button
    }()
    

    
    /*
    lazy var screenshotMapView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    */
    let pointsBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        //view.layer.cornerRadius = 2
        view.layer.cornerRadius = 13
        view.alpha = 1
        return view
    }()
    let pointsLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "17,520", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)])
        attributedText.append(NSAttributedString(string: " points", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)]))
        label.attributedText = attributedText
        
        return label
    }()
    
    lazy var destinationTextField: UITextField = {
        let tf = UITextField()
        //tf.placeholder = "Where to?"
        tf.attributedPlaceholder = NSAttributedString(string:"Where to Zilla?", attributes:[NSAttributedString.Key.foregroundColor: UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1)])
        tf.font = UIFont.boldSystemFont(ofSize: 17)
        //tf.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        tf.keyboardType = UIKeyboardType.default
        tf.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0).cgColor
        tf.layer.cornerRadius = 0 //25
        tf.clipsToBounds = true
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(HomeVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        view.isUserInteractionEnabled = true
        return tf
    }()
    
    let destTextFieldBlurView: UIView = {
        let view = UIView()
        //view.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
        view.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        view.layer.borderWidth = 1.75
        view.layer.cornerRadius = 22
        view.layer.shadowOpacity = 95 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.25).cgColor
        view.layer.shadowRadius = 4.0
        view.layer.shadowOffset = CGSize(width: 1, height: 2)
        view.isUserInteractionEnabled = true
        view.alpha = 1
        return view
    }()
    
    lazy var userActivityButtonBackground: UIView = {
        let view = UIView()
        
        view.layer.shadowOpacity = 95 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.25).cgColor
        view.layer.shadowRadius = 4.0
        view.layer.shadowOffset = CGSize(width: 1, height: 2)
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
 
        view.backgroundColor = UIColor.walkzillaYellow()
        view.translatesAutoresizingMaskIntoConstraints = false
        let rewardsTap = UITapGestureRecognizer(target: self, action: #selector(handleUserActivity))
        rewardsTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(rewardsTap)
        view.alpha = 1
        return view
    }()
    
    let activityLabelBackground: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.20).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return view
    }()
    
    let activityLabel: UILabel = {
        let label = UILabel()
        label.text = "Activity"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 9)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        //label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()

    /*
    let userActivityLabel: UILabel = {
        let label = UILabel()
        //label.text = "Distance: None"
        label.text = "Activity Profile"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    */
    //actionBoltIcon
    
    lazy var userActivityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "walkzillaActivity"), for: .normal)
        button.addTarget(self, action: #selector(handleUserActivity), for: .touchUpInside)
        button.tintColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        return button
    }()
    
    let searchImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.image = UIImage(named: "simpleSearchIcon-30x30")
        //iv.layer.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1).cgColor
        iv.image = iv.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        iv.tintColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        return iv
    } ()
    
    let searchBarSubView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(red: 122/255, green: 219/255, blue: 34/255, alpha: 1)
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        view.alpha = 0
        return view
    }()
    
    let messagesLabelBackground: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.20).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return view
    }()
    
    let messagesLabel: UILabel = {
        let label = UILabel()
        label.text = "Messages"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 9)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        //label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()
    
    lazy var cancelSearchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cancelButtonHeavy"), for: .normal)
        button.addTarget(self, action: #selector(handleCancelSearch), for: .touchUpInside)
        //button.backgroundColor = .clear
        //button.layer.cornerRadius = 74 / 2
        /*
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 0.30).cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        */
        //button.layer.cornerRadius = 25
        button.alpha = 0
        return button
    }()

    
    let searchLabel: UILabel = {
        let label = UILabel()
        label.text = "Search"
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 10)
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()
    

    let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 2
        view.alpha = 1
        return view
    }()
    
    
    let navigatorSubView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return view
    }()
    
    let topBarColorView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.75).cgColor
        view.layer.borderColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.75).cgColor
        view.layer.borderWidth = 0.15
        return view
    }()
    
    let searchTableView: UIView = {
        let view = UIView()
        //view.layer.cornerRadius = 15
        // to ajdust the color of the background search table
        view.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        view.alpha = 1
        return view
    }()
    
    let loginView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        view.alpha = 1
        return view
    }()
    /*
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login!", for: .normal)
        button.layer.backgroundColor = UIColor.rgb(red: 26, green: 172, blue: 239).cgColor
        button.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        button.layer.borderWidth = 2
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleUserLogin), for: .touchUpInside)
        return button
    } ()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SignUp", for: .normal)
        button.layer.backgroundColor = UIColor.rgb(red: 26, green: 172, blue: 239).cgColor
        button.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        button.layer.borderWidth = 2
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleUserSignUp), for: .touchUpInside)
        return button
    } ()
    */
    let separatorShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 0/255, blue: 0/255, alpha: 1)
        return view
    }()
    
    
    
    /*
    let simpleMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "menuSliderBtn"), for: .normal)
        button.addTarget(self, action: #selector(expansionStateCheck), for: .touchUpInside)
        button.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        button.alpha = 1
        button.backgroundColor = .clear
        return button
    }()
    */
    
    let simpleMenuButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setImage(UIImage(named: "simpleArrowLimer"), for: .normal)
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.addTarget(self, action: #selector(expansionStateCheck), for: .touchUpInside)
        button.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        button.backgroundColor = .clear
        //button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        //button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.55).cgColor
        //button.layer.shadowRadius = 5.0
        //button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.alpha = 1
        return button
    }()
    
    lazy var simpleMenuBackground: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        //view.backgroundColor = UIColor.walkzillaYellow()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        view.backgroundColor = .clear
        let menuTap = UITapGestureRecognizer(target: self, action: #selector(expansionStateCheck))
        menuTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(menuTap)
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 0.30).cgColor
        view.layer.shadowRadius = 7.0
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.alpha = 1
        return view
    }()
    

    

    
    
    let simpleRightMenuButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "actionButton"), for: .normal)
        button.addTarget(self, action: #selector(expansionStateCheckRight), for: .touchUpInside)
        button.tintColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.45)
        button.backgroundColor = .clear
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.55).cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.alpha = 1
        return button
    }()

    
    
    lazy var notificationBoltBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.walkzillaYellow()
        let menuTap = UITapGestureRecognizer(target: self, action: #selector(expansionStateCheckGroups))
        menuTap.numberOfTapsRequired = 1
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(menuTap)
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.20).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.alpha = 1
        return view
    }()
    
    lazy var groupsButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setImage(UIImage(named: "whitePlus"), for: .normal)
        button.setImage(UIImage(named: "analytics_icon_simple"), for: .normal)
        button.addTarget(self, action: #selector(expansionStateCheckGroups), for: .touchUpInside)
        button.backgroundColor = .clear
        //button.tintColor = UIColor.walkzillaRed()
        button.tintColor = UIColor.black
        /*
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.65).cgColor
        button.layer.shadowRadius = 8.0
        button.layer.shadowOffset = CGSize(width: 5, height: -5)
        */
        button.alpha = 1
        return button
    }()
    
    lazy var simpleActionBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        let menuTap = UITapGestureRecognizer(target: self, action: #selector(expansionStateCheckRight))
        menuTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(menuTap)
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.alpha = 1
        return view
    }()
    
    
    lazy var beBoppActionButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setImage(UIImage(named: "whitePlus"), for: .normal)
        button.setImage(UIImage(named: "simpleAnalyticsBar"), for: .normal)
        button.addTarget(self, action: #selector(expansionStateCheckRight), for: .touchUpInside)
        button.backgroundColor = .clear
        //button.tintColor = UIColor.walkzillaRed()
        button.tintColor = UIColor.black
        /*
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.65).cgColor
        button.layer.shadowRadius = 8.0
        button.layer.shadowOffset = CGSize(width: 5, height: -5)
        */
        button.alpha = 1
        return button
    }()
    
    lazy var simpleRightMenuBackground: GradientActionView = {
        let view = GradientActionView()
        //view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        //view.backgroundColor = UIColor.actionRed()
        //view.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        //view.layer.borderWidth = 4
        let menuTap = UITapGestureRecognizer(target: self, action: #selector(expansionStateCheckRight))
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
    
    
    
    lazy var rewardsBackgroundSubView: UIView = {
        let view = UIView()
        view.backgroundColor = .airBnBRed()
        let rewardsTap = UITapGestureRecognizer(target: self, action: #selector(handleHomeRewards))
        rewardsTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(rewardsTap)
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.55).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.alpha = 1
        return view
    }()
    
    lazy var rewardsBackground: GradientDiagonalView = {
        let view = GradientDiagonalView()
        //view.backgroundColor = .clear
        let rewardsTap = UITapGestureRecognizer(target: self, action: #selector(handleHomeRewards))
        rewardsTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(rewardsTap)
        view.alpha = 1
        return view
    }()
    
    
    let homeRewardsButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setImage(UIImage(named: "rewardsGiftsIcon"), for: .normal)
        //button.setImage(UIImage(named: "rewardsBox"), for: .normal)
        button.setImage(UIImage(named: "messenger-plane-white"), for: .normal)
        button.addTarget(self, action: #selector(handleHomeRewards), for: .touchUpInside)
        button.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        button.alpha = 1
        button.backgroundColor = .clear
        return button
    }()
    
    
    lazy var startStopPedometerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Pedometer", for: .normal)
        button.addTarget(self, action: #selector(handleStartStopPedometer), for: .touchUpInside)
        button.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        button.alpha = 1
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.rgb(red: 0, green: 0, blue: 0).cgColor
        return button
    }()
     
    

    
    lazy var centerMapBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.20).cgColor
        view.layer.shadowRadius = 6.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        let centerMapTap = UITapGestureRecognizer(target: self, action: #selector(handleCenterMapBtnPressed))
        centerMapTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(centerMapTap)
        view.alpha = 0
        return view
    }()
    
    let centerMapButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "walkZillaCentreMap"), for: .normal)
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.20).cgColor
        button.layer.shadowRadius = 6.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        //button.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        button.addTarget(self, action: #selector(handleCenterMapBtnPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var settingsButtonBackground: UIView = {
        let view = UIView()
        
       // view.backgroundColor = UIColor.walkzillaYellow()
        view.backgroundColor = UIColor.black
        //view.layer.borderWidth = 1
        //view.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        //view.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.20).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        let settingsTap = UITapGestureRecognizer(target: self, action: #selector(expansionStateCheck))
        settingsTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(settingsTap)
        view.alpha = 0.40
        return view
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(named: "menu"), for: .normal)
        //button.setImage(UIImage(named: "simple-gear-white"), for: .normal)
        button.addTarget(self, action: #selector(expansionStateCheck), for: .touchUpInside)
        return button
    }()
    
    lazy var simpleProfileBackground: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.40).cgColor
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(handleProfileView))
        profileTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(profileTap)
        return view
    }()
    
    
    let simpleProfileButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "profileCircle"), for: .normal)
        button.addTarget(self, action: #selector(handleProfileView), for: .touchUpInside)
        return button
    }()
    
    lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 0.50
        iv.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        iv.image = UIImage(named: "userProfileSilhouetteWhite")
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(handleProfileView))
        profileTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(profileTap)
        return iv
    }()
    /*
    lazy var centerMapBackground: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.40).cgColor
        let rewardsTap = UITapGestureRecognizer(target: self, action: #selector(handleMessages))
        rewardsTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(rewardsTap)
        return view
    }()
    
    let centerMapButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        //button.setImage(UIImage(named: "whiteRewardsIcon2"), for: .normal)
        button.setImage(UIImage(named: "message-bubble"), for: .normal)
        button.addTarget(self, action: #selector(handleMessages), for: .touchUpInside)
        return button
    }()
    */
    
    
    /*
    lazy var toggleSaveRemoveSegmentView: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save Segment", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            button.titleLabel?.textAlignment = .center
            button.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255), for: .normal)
            button.addTarget(self, action: #selector(handleSaveRemoveSegment), for: .touchUpInside)
            //button.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        button.backgroundColor = UIColor.rgb(red: 240, green: 92, blue: 103)
            button.alpha = 1
            return button
        } ()
    */
    lazy var saveRemovePathLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        // add gesture recognizer
        label.text = "Save Path"
        //label.font = UIFont.boldSystemFont(ofSize: 17)
        label.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        let buttonTap = UITapGestureRecognizer(target: self, action: #selector(handleSaveRemoveSegment))
        buttonTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(buttonTap)
        return label
    }()
    
    lazy var toggleSaveRemoveSegmentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.walkzillaYellow()
        /*
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        */
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        let buttonTap = UITapGestureRecognizer(target: self, action: #selector(handleSaveRemoveSegment))
        buttonTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(buttonTap)
        view.alpha = 1
        return view
    }()
    /*
    lazy var saveRemoveSegmentBackground: GradientDiagonalView = {
        let view = GradientDiagonalView()
        let buttonTap = UITapGestureRecognizer(target: self, action: #selector(handleSaveRemoveSegment))
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        buttonTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(buttonTap)
        view.alpha = 1
        return view
    }()
    */
       /*
       lazy var removeSegmentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove Path", for: .normal)
        button.addTarget(self, action: #selector(handleRemovedSaveSegment), for: .touchUpInside)
        button.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        button.layer.borderColor = UIColor.rgb(red: 0, green: 0, blue: 0).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .red
        button.alpha = 1
        return button
       } ()
    */
    /*
    let analyticsButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "simpleAnalyticsLimer"), for: .normal)
        //button.setImage(UIImage(named: "trueBlueCircleAnalytics"), for: .normal)
        //button.setImage(UIImage(named: "circleOrangeAnalyticsWhiteLineEdit"), for: .normal)
        button.addTarget(self, action: #selector(handleAnalytics), for: .touchUpInside)
        button.backgroundColor = .clear
        button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.55).cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.alpha = 1
        return button
       }()
    */
    let analyticsBackground: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.55).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.isUserInteractionEnabled = true
        let analyticsTap = UITapGestureRecognizer(target: self, action: #selector(handleAnalytics))
        analyticsTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(analyticsTap)
        view.alpha = 1
        return view
    }()
       
    
    
    
 /*
    let customCenterMap: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        //button.setImage(#imageLiteral(resourceName: "centerMapIcon-35x35").withRenderingMode(.alwaysOriginal), for: .normal)
        //button.setImage(UIImage(named: "simpleWhiteCircleCenterMap"), for: .normal)
        button.setImage(UIImage(named: "peachArrowInCircle"), for: .normal)
        button.addTarget(self, action: #selector(handleCenterMapBtnPressed), for: .touchUpInside)
        //button.tintColor = UIColor(red: 9/255, green: 171/255, blue: 231/255, alpha: 1)
        //button.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.75)
        //button.alpha = 0.90
        button.layer.shadowOpacity = 90 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.50).cgColor
        button.layer.shadowRadius = 1.0
        button.layer.shadowOffset = CGSize(width: -1, height: 2)
        return button
    }()
   
    let customQRButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        //button.setImage(#imageLiteral(resourceName: "centerMapIcon-35x35").withRenderingMode(.alwaysOriginal), for: .normal)
        //button.setImage(UIImage(named: "simpleWhiteCircleCenterMap"), for: .normal)
        button.setImage(UIImage(named: "roundedQRSymbolPeachWhiteCircle"), for: .normal)
        button.addTarget(self, action: #selector(handleQRCode), for: .touchUpInside)
        //button.tintColor = UIColor(red: 9/255, green: 171/255, blue: 231/255, alpha: 1)
        //button.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.75)
        //button.alpha = 0.90
        button.layer.shadowOpacity = 90 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.35).cgColor
        button.layer.shadowRadius = 1.0
        button.layer.shadowOffset = CGSize(width: -1, height: 2)
        return button
    }()
    */
    /*
    let viewSearchBarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "thinBlueMagnifyIcon"), for: .normal)
        button.addTarget(self, action: #selector(presentSearchBar), for: .touchUpInside)
        button.layer.shadowOpacity = 30 // Shadow is 30 percent opaque.
        button.layer.shadowColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        button.layer.shadowRadius = 2.0
        button.layer.shadowOffset = CGSize(width: -2, height: 2)
        button.alpha = 1
        //button.backgroundColor = .clear
        return button
    }()
    */
    
    /*
    lazy var viewSearchTextContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        let textTap = UITapGestureRecognizer(target: self, action: #selector(configureSearchBar))
        view.layer.backgroundColor = UIColor(red: 50/255, green: 130/255, blue: 250/255, alpha: 1).cgColor
        textTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(textTap)
        view.alpha = 1
        return view
    }()
    */
    
    let logoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named:"waywalkGothicText")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate))
        //let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        //iv.image = #imageLiteral(resourceName: "waywalkLogoBlack")
        //iv.image = UIImage(named: "waywalkGothicText")
        //iv.tintColor = UIColor(red: 7/255, green: 160/255, blue: 210/255, alpha: 1)
        iv.tintColor = UIColor(red: 5/255, green: 157/255, blue: 212/255, alpha: 1)
        return iv
    } ()
    
    lazy var backgroundLogoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4.0
        view.layer.shadowOpacity = 1 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 125/255, green: 125/255, blue: 125/255, alpha: 0.75).cgColor
        view.layer.shadowRadius = 4.0
        view.layer.shadowOffset = CGSize(width: -2, height: 2)
        return view
    }()
    
    lazy var startTripButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.titleLabel?.textAlignment = .center
        button.setTitle("Start Trip", for: .normal)
        button.backgroundColor = UIColor(red: 250/255, green: 150/255, blue: 90/255, alpha: 1)
        //button.layer.borderColor = UIColor.lightGray.cgColor
        //button.layer.borderWidth = 0.25
        button.setTitleColor(.white, for: .normal)
        //button.addTarget(self, action: #selector(handleStartTrip), for: .touchUpInside)
        button.alpha = 1
        return button
    }()
    
    lazy var stopTripButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.titleLabel?.textAlignment = .center
        button.setTitle("Stop Trip", for: .normal)
        button.backgroundColor = UIColor(red: 250/255, green: 150/255, blue: 90/255, alpha: 1)
        //button.layer.borderColor = UIColor.lightGray.cgColor
        //button.layer.borderWidth = 0.25
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleStopTrip), for: .touchUpInside)
        button.alpha = 1
        return button
    }()
    
    
    lazy var startStopButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = .center
        button.setTitle("START", for: .normal)
        //button.titleLabel?.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 24)
        button.titleLabel?.font = UIFont(name: "AvenirNextCondensed-BoldItalic", size: 18)
        button.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        //button.setTitleColor(UIColor.airBnBNew(), for: .normal)
        button.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255), for: .normal)
        button.addTarget(self, action: #selector(handleStartStopTrip), for: .touchUpInside)
        //button.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        //button.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        //button.layer.shadowRadius = 5.0
        //button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.alpha = 0
        return button
    }()
    
    
    lazy var cancelTripBackground: UIView = {
        let view = UIView()
        //view.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        view.backgroundColor = UIColor.walkzillaRed()
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.25).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        let settingsTap = UITapGestureRecognizer(target: self, action: #selector(handleCancelTrip))
        settingsTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(settingsTap)
        view.alpha = 0
        return view
    }()
    
    let cancelTripButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "cancelButtonHeavy"), for: .normal)
        button.tintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        button.addTarget(self, action: #selector(handleCancelTrip), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    //let customCenterMap = UIButton(type: UIButton.ButtonType.custom)
    
    
    lazy var sideMenu: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return view
    }()
    
    let tabGradientView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        view.layer.borderWidth = 1
        view.layer.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1).cgColor
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.55).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 6.0
        view.layer.shadowOpacity = 0.50
        view.layer.cornerRadius = 15
        
        /*
        view.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        view.layer.shadowColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 0.75).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 8.0
        view.layer.shadowOpacity = 0.75
        view.layer.cornerRadius = 20
        */

        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.alpha = 1
        return view
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = (UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1))
        view.alpha = 0
        //view.backgroundColor = UIColor.darkGray.cgColor
        return view
    }()
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    // Mark: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        //extends the edges beyound the tab bar
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true
        */
        
        //fetchCurrentUserData()
        
        //self.title = "Home"
        navigationController?.navigationBar.isHidden = true
        
        expansionState = .NotExpanded
        
        configureMapViewComponents()
        
        configureSearchTableView()
        
        setupToHideKeyboardOnTapOnView()
        
        // setting boolean values
        didSetUserOrigin = false
        secondSegmentSelected = false
        isStoreDetailViewVisible = false
        isMenuExpanded = false
        isRightMenuExpanded = false
        isSearchTableViewVisible = false
   
        //searchTableView.isHidden = false
        //isStoreViewAtOrigin = true
        
        self.rootRef = Database.database().reference()
        
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        
        
        
 
        // check user location auth status
        checkLocationAuthStatus()

        UNService.shared.authorize()
        CLService.shared.authorize()
        
        //this animation will get rid of glitch in app beforehand
        
        
        // view covers the entire UI window
        
        /*
        print("DEBUG: splashview will be revealed this time")
            
        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            if let window:UIWindow = applicationDelegate.window {
                //let revealingSplashView:UIView = UIView(frame: UIScreen.main.bounds)
                revealingSplashView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                    window.addSubview(revealingSplashView)
                self.revealingSplashView.layer.backgroundColor = UIColor(red: 250/255, green: 150/255, blue: 90/255, alpha: 1).cgColor
                self.revealingSplashView.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                self.revealingSplashView.animationType = SplashAnimationType.twitter
                self.revealingSplashView.startAnimation()
                self.revealingSplashView.heartAttack = true
                self.splashViewRevealed = true
            }
        }
        */
        
        mapView.delegate = self
        destinationTextField.delegate = self
        
        mapView.isRotateEnabled = false
        
        
        
        plotStoreAnnotations()
        
        isUserLoggedIn()
        
        centerMapOnUserLocation() //this command i will have to verify later. may or may not need.
  
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.layoutSubviews()
        
        // when user changes view should we invalidate timer? i want to keep on while user toggles
        //newTimer.invalidate()
        //manager?.stopUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /*
        tabBarController?.tabBar.layer.shadowColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 0.35).cgColor
        tabBarController?.tabBar.layer.shadowOpacity = 95 // Shadow is 30 percent opaque.
        tabBarController?.tabBar.layer.shadowRadius = 4.0
        tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 1, height: 0)
        */
        
        navigationController?.navigationBar.isHidden = true
    }
    
    
    
    // MARK: - Helper Functions
    
    func addBlurEffect() {
        let bounds = destTextFieldBlurView.bounds
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        destTextFieldBlurView.addSubview(visualEffectView)
        visualEffectView.layer.cornerRadius = 22
        visualEffectView.clipsToBounds = true

        // Here you can add visual effects to any UIView control.
        // Replace custom view with navigation bar in the above code to add effects to the custom view.
    }
    
    func removeBlurEffect() {
        visualEffectView.removeFromSuperview()
    }
    
    
    func fetchCurrentUserData() {
        
        
        
        if Auth.auth().currentUser != nil {
            
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            
            DataService.instance.REF_USERS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                
                let uid = snapshot.key
                let user = User(uid: uid, dictionary: dictionary)
                
                guard let profileImageUrl = user.profileImageURL else { return }
                self.profileImageView.loadImage(with: profileImageUrl)
                
                let profileDimension: CGFloat = 40
                //self.mapView.addSubview(self.profileImageView)
                //self.profileImageView.anchor(top: self.mapView.topAnchor, left: nil, bottom: nil, right: self.mapView.rightAnchor, paddingTop: 34, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: profileDimension, height: profileDimension)
                self.profileImageView.layer.cornerRadius = profileDimension / 2
            }
    

                } else {
        
            /*
                           let profileDimension: CGFloat = 40
                    mapView.addSubview(simpleProfileBackground)
                    simpleProfileBackground.anchor(top: mapView.topAnchor, left: nil, bottom: nil, right: mapView.rightAnchor, paddingTop: 34, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: profileDimension, height: profileDimension)
                    simpleProfileBackground.layer.cornerRadius = profileDimension / 2
                    
                    mapView.addSubview(simpleProfileButton)
                    simpleProfileButton.anchor(top: simpleProfileBackground.topAnchor , left: simpleProfileBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 9, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 21, height: 23)
            */
                }

    }

    func configureMapViewComponents() {
        
        view.backgroundColor = .white
        
        configureMapView()

        let tabBarHeight = CGFloat((tabBarController?.tabBar.frame.size.height)!)
        
        //let menuDimension: CGFloat = 35
        
        /*
        let backgroundDimension: CGFloat = 45
        mapView.addSubview(simpleMenuBackground)
        simpleMenuBackground.anchor(top: mapView.topAnchor, left: mapView.leftAnchor, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: backgroundDimension, height: backgroundDimension)
        simpleMenuBackground.layer.cornerRadius = backgroundDimension / 2
     
        
        simpleMenuBackground.addSubview(simpleMenuButton)
        simpleMenuButton.anchor(top: simpleMenuBackground.topAnchor, left: simpleMenuBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 5.5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 35, height: 35)
        */
        

        
        /*
        simpleActionShadowBackground.addSubview(simpleRightMenuBackground)
        simpleRightMenuBackground.anchor(top: simpleActionShadowBackground.topAnchor, left: simpleActionShadowBackground.leftAnchor, bottom:  simpleActionShadowBackground.bottomAnchor, right: simpleActionShadowBackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        simpleRightMenuBackground.layer.cornerRadius = 60 / 2
        */
        
       //simpleRightMenuBackground.addSubview(simpleRightMenuButton)
       //simpleRightMenuButton.anchor(top: simpleRightMenuBackground.topAnchor, left: simpleRightMenuBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        
        /*
        let analyticsBackgroundDimension: CGFloat = 45
        mapView.addSubview(simpleActionBackground)
        simpleActionBackground.anchor(top: nil, left: nil, bottom:  mapView.bottomAnchor, right: mapView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 20, width: analyticsBackgroundDimension, height: analyticsBackgroundDimension)
        simpleActionBackground.layer.cornerRadius = 10
        //simpleActionBackground.layer.cornerRadius = analyticsBackgroundDimension / 2.6
        
        simpleActionBackground.addSubview(beBoppActionButton)
        beBoppActionButton.anchor(top: simpleActionBackground.topAnchor, left: simpleActionBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 7, paddingBottom: 0, paddingRight: 0, width: 30, height: 26)
        
        */
        
        let groupsBackgroundDimension: CGFloat = 50
        mapView.addSubview(notificationBoltBackground)
        notificationBoltBackground.anchor(top: nil, left: nil, bottom: mapView.bottomAnchor, right: mapView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 38, paddingRight: 20, width: groupsBackgroundDimension, height: groupsBackgroundDimension)
        notificationBoltBackground.layer.cornerRadius = groupsBackgroundDimension / 2
        
        mapView.addSubview(messagesLabelBackground)
        messagesLabelBackground.anchor(top: notificationBoltBackground.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: -4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 56, height: 18)
        messagesLabelBackground.layer.cornerRadius = 9
        messagesLabelBackground.centerXAnchor.constraint(equalTo: notificationBoltBackground.centerXAnchor).isActive = true
        
        messagesLabelBackground.addSubview(messagesLabel)
        messagesLabel.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        messagesLabel.centerXAnchor.constraint(equalTo: messagesLabelBackground.centerXAnchor).isActive = true
        messagesLabel.centerYAnchor.constraint(equalTo: messagesLabelBackground.centerYAnchor).isActive = true
        
        //notificationButtonBackground.layer.cornerRadius = 10
        //groupsButtonBackground.layer.cornerRadius = 23
        
        /*
        groupsButtonBackground.addSubview(activityLabel)
        activityLabel.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        activityLabel.centerYAnchor.constraint(equalTo: groupsButtonBackground.centerYAnchor).isActive = true
        activityLabel.centerXAnchor.constraint(equalTo: groupsButtonBackground.centerXAnchor).isActive = true
        */
        
        notificationBoltBackground.addSubview(notificationBolt)
        notificationBolt.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 18, height: 9)
        notificationBolt.centerXAnchor.constraint(equalTo: notificationBoltBackground.centerXAnchor).isActive = true
        notificationBolt.centerYAnchor.constraint(equalTo: notificationBoltBackground.centerYAnchor).isActive = true
        
        
        /*
        mapView.addSubview(saveSegmentButton)
        saveSegmentButton.anchor(top: mapView.topAnchor, left: mapView.leftAnchor, bottom: nil, right: mapView.rightAnchor, paddingTop: 100, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 120, height: 40)
        saveSegmentButton.layer.cornerRadius = 20
        
        mapView.addSubview(removeSegmentButton)
        removeSegmentButton.anchor(top: mapView.topAnchor, left: mapView.leftAnchor, bottom: nil, right: mapView.rightAnchor, paddingTop: 150, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 120, height: 40)
        removeSegmentButton.layer.cornerRadius = 20
        */
        
        mapView.addSubview(pedoDistanceLabel)
        pedoDistanceLabel.anchor(top: mapView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 170, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 110)
       pedoDistanceLabel.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
        
         mapView.addSubview(milesLabel)
         milesLabel.anchor(top: pedoDistanceLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        milesLabel.centerXAnchor.constraint(equalTo: pedoDistanceLabel.centerXAnchor).isActive = true
        
        
        //mapView.addSubview(stepsLabel)
        //stepsLabel.anchor(top: milesLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //stepsLabel.centerXAnchor.constraint(equalTo: pedoDistanceLabel.centerXAnchor).isActive = true

         /*
        mapView.addSubview(toggleSaveRemoveSegmentView)
        toggleSaveRemoveSegmentView.anchor(top: mapView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 150, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 175, height: 50)
        toggleSaveRemoveSegmentView.layer.cornerRadius = 23
        toggleSaveRemoveSegmentView.centerXAnchor.constraint(equalTo: self.mapView.centerXAnchor).isActive = true
        
        toggleSaveRemoveSegmentView.addSubview(saveRemoveSegmentBackground)
        saveRemoveSegmentBackground.anchor(top: toggleSaveRemoveSegmentView.topAnchor, left: toggleSaveRemoveSegmentView.leftAnchor, bottom: toggleSaveRemoveSegmentView.bottomAnchor, right: toggleSaveRemoveSegmentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        saveRemoveSegmentBackground.layer.cornerRadius = 23
        
        saveRemoveSegmentBackground.addSubview(saveRemovePathLabel)
        saveRemovePathLabel.anchor(top: saveRemoveSegmentBackground.topAnchor, left: saveRemoveSegmentBackground.leftAnchor, bottom: saveRemoveSegmentBackground.bottomAnchor, right: saveRemoveSegmentBackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        saveRemovePathLabel.clipsToBounds = true
        saveRemovePathLabel.centerXAnchor.constraint(equalTo: self.saveRemoveSegmentBackground.centerXAnchor).isActive = true
        saveRemovePathLabel.centerYAnchor.constraint(equalTo: self.saveRemoveSegmentBackground.centerYAnchor).isActive = true
        */
        
        /*
        mapView.addSubview(startStopPedometerButton)
        startStopPedometerButton.anchor(top: removeSegmentButton.bottomAnchor, left: removeSegmentButton.leftAnchor, bottom: nil, right: removeSegmentButton.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 40)
        startStopPedometerButton.layer.cornerRadius = 20
        */
        
        /*
        let stackView = UIStackView(arrangedSubviews: [ statusTitle, stepsLabel, paceLabel, averagePaceLabel, pedoDistanceLabel])
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(stackView)
        stackView.anchor(top: toggleSaveRemoveSegmentView.bottomAnchor, left: mapView.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        */

        
        //configureNavigationSubView()
        
        configureRightMenuView()
        
        configureMapViewButtons()
        
        configureTabBar()
        
        configureMenuView()
        
        
        
        
        //configureGestureRecognizers()
        
        //configureNavigationBar()
        
    }
    
    func configureNavigationSubView() {
        
        /*
        
        //let navBarHeight = CGFloat((navigationController?.navigationBar.frame.size.height)!)
        
        mapView.addSubview(navigatorSubView)
        navigatorSubView.anchor(top: mapView.topAnchor, left: mapView.leftAnchor, bottom: nil, right: mapView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)

        //navigatorSubView.addSubview(pointsBackgroundView)
       // pointsBackgroundView.anchor(top: navigatorSubView.topAnchor, left: navigatorSubView.leftAnchor, bottom: nil, right: nil, paddingTop: 1.7, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 114, height: 27)
        
        //pointsBackgroundView.addSubview(pointsLabel)
        //pointsLabel.anchor(top: pointsBackgroundView.topAnchor, left: pointsBackgroundView.leftAnchor , bottom: nil, right: nil, paddingTop: 4.5, paddingLeft: 14, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        navigatorSubView.layer.shadowOpacity = 70 // Shadow is 30 percent opaque.
        navigatorSubView.layer.shadowColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1).cgColor
        navigatorSubView.layer.shadowRadius = 2.0
        navigatorSubView.layer.shadowOffset = CGSize(width: -2, height: 1)
 
         */
        
    }

    func isUserLoggedIn() {
        
        // this can be to set a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            if Auth.auth().currentUser == nil {
                
                print("DEBUG: WE should present the loging if the there is no current user")
                
                //self.configureLogInView()
                self.presentLoginView()  //black view should go dark under configure black view
                
                /*
                let loginVC = LoginVC()
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion:nil)
                */
            }
        }
    }

        //DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {     }
    
    func configureSearchTableView() {
        
        //let tabBarHeight = CGFloat((tabBarController?.tabBar.frame.size.height)!)
        
    if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
        
        if let window:UIWindow = applicationDelegate.window {
            
            //searchTableView.isHidden = false
            isSearchTableViewVisible = false
        
            window.addSubview(searchTableView)
            searchTableView.addSubview(lineView)
            
            //searchTableView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -(view.frame.height - 0), paddingRight: 0, width: 0, height: view.frame.height)
            
            searchTableView.anchor(top: nil, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -(view.frame.height - 636), paddingRight: 0, width: 0, height: view.frame.height)
            
            //lineView.anchor(top: searchTableView.topAnchor, left: searchTableView.leftAnchor, bottom: nil, right: searchTableView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 10)
            
            searchTableView.isHidden = true
            lineView.isHidden = true
            
            mapView.addSubview(destTextFieldBlurView)
            destTextFieldBlurView.anchor(top: mapView.topAnchor, left: mapView.leftAnchor, bottom: nil, right: mapView.rightAnchor, paddingTop: 30, paddingLeft: 105, paddingBottom: 0, paddingRight: 105, width: 0, height: 45)
            
            mapView.addSubview(searchImageView)
            searchImageView.anchor(top: destTextFieldBlurView.topAnchor, left: destTextFieldBlurView.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 18, height: 18)

            mapView.addSubview(destinationTextField)
            destinationTextField.anchor(top: mapView.topAnchor, left: searchImageView.rightAnchor, bottom: nil, right: mapView.rightAnchor, paddingTop: 32, paddingLeft: 8, paddingBottom: 0, paddingRight: 105, width: 0, height: 45)

            addBlurEffect()
            
            }
        }

        configureTableView()
        fetchStores()
    }
    
    /*
    func configureLogInView() {
        
        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
                   if let window:UIWindow = applicationDelegate.window {

                    self.loginViewBV.backgroundColor = .clear
                   window.addSubview(self.loginViewBV)
                   self.loginViewBV.frame = window.frame

                    
                   }
               }
        
        
        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            
            if let window:UIWindow = applicationDelegate.window {
            
            //isLoginViewExpanded = false
        
                window.addSubview(loginView)

                loginView.anchor(top: nil, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: -(view.frame.height - 850), paddingRight: 30, width: 0, height: view.frame.height - 250)
                
                loginView.addSubview(loginButton)
                loginButton.anchor(top: loginView.topAnchor, left: loginView.leftAnchor, bottom: nil, right: nil, paddingTop: 200, paddingLeft: 50, paddingBottom: 0, paddingRight: 0, width: 240, height: 50)
                
                loginView.addSubview(signUpButton)
                signUpButton.anchor(top: loginButton.bottomAnchor, left: loginButton.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 240, height: 50)
            
            //loginView.isHidden = true
                
                
                
                
                
            }
        }
    }
    */
    func presentLoginView() {
        
        handleLoginVC()
        
        /*
                let height: CGFloat = 600
        let collectionViewY = -(view.frame.height) - height
                
                //UIView.animate(withDuration: 0.5) {
                //    self.loginViewBV.alpha = 1
               // }
        
        UIView.animate(withDuration: 0.5) {
            self.loginViewBV.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self.loginViewBV.alpha = 1
        }
                
        UIView.animate(withDuration: 0.80, delay: 0, usingSpringWithDamping: 0.70, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                
                  
                    self.loginView.frame = CGRect(x: 0, y: collectionViewY, width: self.loginView.frame.width, height: self.loginView.frame.height)
                    
                    //self.isLoginViewExpanded = true

                                                 
                }, completion: nil)
 
        */
    }
    
    /*
    @objc func handleUserLogin() {
        print("login view dismiss")
        

        let height: CGFloat = 600
        let collectionViewY = view.frame.height + height

        UIView.animate(withDuration: 0.80, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                
                self.loginView.frame = CGRect(x: 30, y: (collectionViewY), width: self.loginView.frame.width, height: self.loginView.frame.height)
            
            }) { (_) in
                //self.loginView.isHidden = true
                self.loginView.removeFromSuperview()
                self.handleLoginVC()
        }
            
        UIView.animate(withDuration: 0.25) {
        self.loginViewBV.alpha = 0
        }
        
    }
    */
    /*
    @objc func handleUserSignUp() {
        print("login view dismiss")
        

        let height: CGFloat = 600
        let collectionViewY = view.frame.height + height

        UIView.animate(withDuration: 0.80, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                
                self.loginView.frame = CGRect(x: 30, y: (collectionViewY), width: self.loginView.frame.width, height: self.loginView.frame.height)
            
            }) { (_) in
                //self.loginView.isHidden = true
                self.loginView.removeFromSuperview()
                self.handleSignUpVC()
        }
            
        UIView.animate(withDuration: 0.25) {
        self.loginViewBV.alpha = 0
        }
        
    }
    */
    func handleLoginVC() {
        
        
        let loginVC = LoginVC()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion:nil)
        
        print("setting login view to not hidden")
        //loginView.isHidden = false     // maybe add this value as handle login presents or signup vc presents
        
    }
    
    /*
    func handleSignUpVC() {
        
        //userSettingsVC.delegate = self
        let signUpVC = SignUpVC()
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true, completion:nil)
        
        print("DEBUG: Signup view presented")
    }
    */
    
    @objc func handleHomeRewards() {
        
        print("handle home rewards")
        
        let rewardsVC = RewardsVC()
        navigationController?.pushViewController(rewardsVC, animated: true)
        
        //print("DEBUG: key holder KEY VALUE IS SET TO THIS \(keyHolder)")
        //print("DEBUG: COMPARE KEY VALUE IS SET TO THIS \(finalSegmentId)")
    }
    
    @objc func handleAnalytics() {
        
        print("handle analytics")
    }

  @objc func handleMessages() {
     
     print("handle home rewards")
     
     let messagesVC = MessagesController()
     navigationController?.pushViewController(messagesVC, animated: true)

 }
    /*
   func configureSearchBar() {
     
    searchBar = UISearchBar()
    searchBar.sizeToFit()
    searchBar.placeholder = "Where to?"
    searchBar.delegate = self

    searchBar.tintColor =  UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1) // changes the text
    searchBar.searchTextField.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    searchBar.searchTextField.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    searchBar.searchTextField.layer.cornerRadius = 18
    searchBar.searchTextField.layer.masksToBounds = true
    searchBar.searchTextField.layer.borderColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1).cgColor
    searchBar.searchTextField.layer.borderWidth = 0.25
    
    searchBar.barTintColor = UIColor.clear
    searchBar.backgroundColor = UIColor.clear
    searchBar.isTranslucent = true
    searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)

   }
*/
    
    
    func configureMapView() {
        
        mapView = MKMapView()
        let tabBarHeight = CGFloat((tabBarController?.tabBar.frame.size.height)!)
        
        view.addSubview(mapView)
        //mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        mapView.addConstraintsToFillView(view: view)
        
        mapView.addSubview(searchBarSubView)
        searchBarSubView.anchor(top: mapView.topAnchor, left: mapView.leftAnchor, bottom: nil, right: mapView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        //mapView.tintColor = UIColor.airBnBRed()
        mapView.tintColor = UIColor.walkzillaYellow()
        
        mapView.addSubview(userActivityButtonBackground)
        userActivityButtonBackground.anchor(top: nil, left: mapView.leftAnchor, bottom: mapView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 38, paddingRight: 0, width: 50, height: 50)
        userActivityButtonBackground.layer.cornerRadius = 50 / 2
        //userActivityButtonBackground.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
            
        userActivityButtonBackground.addSubview(userActivityButton)
        userActivityButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 20, height: 15)
        userActivityButton.centerXAnchor.constraint(equalTo: userActivityButtonBackground.centerXAnchor).isActive = true
        userActivityButton.centerYAnchor.constraint(equalTo: userActivityButtonBackground.centerYAnchor).isActive = true
        
        mapView.addSubview(activityLabelBackground)
        activityLabelBackground.anchor(top: userActivityButtonBackground.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: -4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 56, height: 18)
        activityLabelBackground.layer.cornerRadius = 9
        activityLabelBackground.centerXAnchor.constraint(equalTo: userActivityButtonBackground.centerXAnchor).isActive = true
        
        activityLabelBackground.addSubview(activityLabel)
        activityLabel.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        activityLabel.centerXAnchor.constraint(equalTo: activityLabelBackground.centerXAnchor).isActive = true
        activityLabel.centerYAnchor.constraint(equalTo: activityLabelBackground.centerYAnchor).isActive = true
        
        
        //mapView.tintColor = UIColor(red: 26/255, green: 172/255, blue: 239/255, alpha: 1) // true blue
        //mapView.tintColor = UIColor(red: 122/255, green: 206/255, blue: 33/255, alpha: 1) // limer

    }
   
    func configureTabBar() {
        // changing tab bar tint color to white
        tabBarController?.tabBar.barTintColor = UIColor.white
        //self.homeVC?.hideTabBar(tabBarController?.tabBar.isHidden = false
        
        tabBarController?.tabBar.isTranslucent = false
        /*
        tabBarController?.tabBar.layer.shadowColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 0.35).cgColor
        tabBarController?.tabBar.layer.shadowOpacity = 95 // Shadow is 30 percent opaque.
        tabBarController?.tabBar.layer.shadowRadius = 4.0
        tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 1, height: 0)
        */
        
        /*
        // adding shadow view to the tab bar
        tabBarController?.tabBar.isTranslucent = true
        tabBarController?.tabBar.barTintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        tabBarController?.tabBar.layer.cornerRadius = 15
        tabBarController?.tabBar.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        tabBarController?.tabBar.layer.borderWidth = 1
        tabBarController?.tabBar.layer.masksToBounds = true
        tabBarController?.tabBar.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        tabBarController?.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        mapView.addSubview(tabGradientView)
        tabGradientView.anchor(top: nil, left: mapView.leftAnchor, bottom: mapView.bottomAnchor, right: mapView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
        */
 
    }
    
    func configureNavigationBar() {

        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = .clear

        // configure navigation bar with large titles
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Let's go!"
        
        navigationItem.titleView = searchBar
        
        // nav bar bottom border
        navigationController?.navigationBar.shadowImage = UIImage()
        
        /*
         
        navigationController?.navigationBar.addSubview(lineView)
        lineView.anchor(top: navigationController?.navigationBar.topAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: nil, right: navigationController?.navigationBar.rightAnchor, paddingTop: 55, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.18)

        navigationController?.navigationBar.addSubview(navigatorSubView)
        navigatorSubView.anchor(top: navigationController?.navigationBar.bottomAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: nil, right: navigationController?.navigationBar.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        navigatorSubView.addSubview(qrButton)
        qrButton.anchor(top: navigatorSubView.topAnchor, left: navigatorSubView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        
        */
        
        // remove nav bar top border
        //removeTabBarTopBorder()
           
           //remove nav bar bottom border
            //navigationController?.navigationBar.shadowImage = UIImage()
           //let lineView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: -4))
           //lineView.backgroundColor = UIColor.white
           //navigationController?.navigationBar.addSubview(lineView)
           
           
           //let notifcationImage = UIImage(named: "simpleBlueBell-25x25")
               
           //let notificationButton = UIBarButtonItem(image: notifcationImage, style: .plain, target: self, action: #selector(handleNotificationView))
           
        
        
        
        //self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 9/255, green: 171/255, blue: 231/255, alpha: 1)
           
           // can add a boolean statement here for notifications buttons to be included
        
        
        // make navigation bar clear
        //navigationController?.navigationBar.isHidden = false
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //navigationController?.navigationBar.shadowImage = UIImage()
        //navigationController?.navigationBar.isTranslucent = true
        //navigationController?.view.backgroundColor = .clear
        

        // creating custom logo
        //let logo = UIImage(named: "waywalkGothicText")
        //let imageView = UIImageView(image: logo)
        
        
        /*
        let imageView = UIImageView(image: UIImage(named:"waywalkGothicText")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate))
        imageView.tintColor = UIColor(red: 8/255, green: 159/255, blue: 218/255, alpha: 1)
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 125, height: 34)
        //imageView.contentMode = .scaleAspectFit
        navigationController?.navigationBar.topItem?.titleView = imageView
        */
  
           
           // creating custom notification button for feed view
      
    customMenuButton.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
           //customMenuButton.setImage(UIImage(named: "menuSliderBtn"), for: .normal)
        //customMenuButton.setImage(UIImage(named:"menuSliderBtn")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        customMenuButton.setTitle("Menu", for: .normal)
        customMenuButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        customMenuButton.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), for: .normal)
    customMenuButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
           customMenuButton.addTarget(self, action: #selector(expansionStateCheck), for: .touchUpInside)
        //customMenuButton.tintColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        
        
        /*
        // creating custom inbox button for feed view
        //let customCenterMap = UIButton(type: UIButton.ButtonType.custom)
        customCenterMap.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        customCenterMap.setImage(UIImage(named: "simpleWhiteCircleCenterMap"), for: .normal)
        //customInboxButton.layer.borderWidth = 2
        //customInboxButton.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        customCenterMap.layer.cornerRadius = 40 / 2
        customCenterMap.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        customCenterMap.addTarget(self, action: #selector(handleCenterMapBtnPressed), for: .touchUpInside)
        customCenterMap.layer.shadowOpacity = 80 // Shadow is 30 percent opaque.
        customCenterMap.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.35).cgColor
        customCenterMap.layer.shadowRadius = 2.0
        customCenterMap.layer.shadowOffset = CGSize(width: -2, height: 2)
       */

           //let barMenuButton = UIBarButtonItem(customView: customMenuButton)
           //let barCenterMapButton = UIBarButtonItem(customView: customCenterMap)
           
        //self.navigationItem.rightBarButtonItems = [barCenterMapButton]
        
        //navigationController?.navigationBar.topItem?.titleView = imageView
        
        
        
        //let customMenuButtonArrow = UIButton(type: UIButton.ButtonType.custom)
            customMenuButtonArrow.frame = CGRect(x: 0, y: 0, width: 40, height: 33)
        customMenuButtonArrow.setImage(UIImage(named:"simpleMenuRoundedIcon.png")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)

        customMenuButtonArrow.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 33, height: 33)
                   customMenuButtonArrow.addTarget(self, action: #selector(expansionStateCheck), for: .touchUpInside)
        customMenuButtonArrow.tintColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        //customMenuButtonArrow.tintColor = UIColor(red: 250/255, green: 150/255, blue: 90/255, alpha: 1)
        
        let barMenuButtonArrow = UIBarButtonItem(customView: customMenuButtonArrow)
        
        //self.navigationItem.leftBarButtonItems = [barMenuButtonArrow, barMenuButton]
        self.navigationItem.leftBarButtonItems = [barMenuButtonArrow]
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 17)!], for: .normal)
        
        //self.navigationItem.leftBarButtonItems = [barMenuButtonArrow]
        
        
        // adjust the tab bar icon colors
        //tabBarController?.tabBar.tintColor = UIColor.blue
        
        
        
        // create clear tab bar
        //tabBarController?.tabBar.backgroundImage = UIImage()
        
        /*
        // make navigation bar white
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //navigationController?.navigationBar.shadowImage = UIImage()
        
        // sets bar's background image color
        navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: .white), for: .default)
        
        // sets bar's shadow image (Color) //
        navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1))
        navigationController?.navigationBar.isTranslucent = false
        
        
        // adding logo to navigation bar
        let logo = UIImage(named: "waywalkLogoBlack")
        let imageView = UIImageView(image: logo)
        
        imageView.contentMode = .scaleAspectFit
        navigationController?.navigationBar.topItem?.titleView = imageView
        
        // hiding top navigation bar
        navigationController?.navigationBar.isHidden = true
        
        // make navigation bar clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        
        // changing tab bar tint color to white
        tabBarController?.tabBar.barTintColor = UIColor.white
        tabBarController?.tabBar.isTranslucent = false
        
        // adjust the tab bar icon colors
        //tabBarController?.tabBar.tintColor = UIColor.blue
        
        // remove nav bar top border
        //removeNavigationBarBorder()
        
        // create clear tab bar
        tabBarController?.tabBar.backgroundImage = UIImage()
        
        
        // navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menuSliderBtn").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuSlider))
 
 
    */
        /*
        customProfileButton.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        customProfileButton.setImage(UIImage(named:"simpleProfileInCircle")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)

            customProfileButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 29, height: 29)
                       customProfileButton.addTarget(self, action: #selector(handleProfileSelected), for: .touchUpInside)
            customProfileButton.tintColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
            //customMenuButtonArrow.tintColor = UIColor(red: 250/255, green: 150/255, blue: 90/255, alpha: 1)
            
            let barMenuButtonProfile = UIBarButtonItem(customView: customProfileButton)
            
            self.navigationItem.rightBarButtonItems = [barMenuButtonProfile]
        */
        

        
    }
    
    

    
    
    @objc func handleBackButton() {
       // _ = self.navigationController?.popViewController(animated: true)
        
        let homeVC = HomeVC()
        let nav = self.navigationController
        DispatchQueue.main.async {
            nav?.view.layer.add(CATransition().popFromLeft(), forKey: nil)
            nav?.popViewController(animated: false)
        }
    }
    
    @objc func handleUserActivity() {
        print("handle user activity")
    }
    
    func removeTabBarTopBorder() {
        
        // remove tab bar top border
        tabBarController?.tabBar.shadowImage = UIImage()
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: -4))
        lineView.backgroundColor = UIColor.white
        tabBarController?.tabBar.addSubview(lineView)
    }
    
    func hideTabBar() {
        var frame = self.tabBarController?.tabBar.frame
        frame!.origin.y = self.view.frame.size.height + (frame?.size.height)!
        self.tabBarController?.tabBar.frame = frame!
        
        /*
         UIView.animate(withDuration: 0.25, animations: {
            frame!.origin.y = self.view.frame.size.height + (frame?.size.height)!
            self.tabBarController?.tabBar.frame = frame!
        })
         */
    }

    func showTabBar() {
        
        //tabBarController?.tabBar.isHidden = false
        
        /*
        var frame = self.tabBarController?.tabBar.frame
        //frame!.origin.y = self.view.frame.size.height //- (frame?.size.height)!
        //self.tabBarController?.tabBar.frame = frame!
        
         UIView.animate(withDuration: 0.25, animations: {
            frame!.origin.y = self.view.frame.size.height //- (frame?.size.height)!
            self.tabBarController?.tabBar.frame = frame!
        })
         */
    }
    
    // MARK: - CLLocationManager
    
    func checkLocationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            manager?.startUpdatingLocation()
            
        } else {
            manager?.requestAlwaysAuthorization()
        }
    }
    
    func centerMapOnUserLocation() {
        
        //let coordinateRegion = MKCoordinateRegion.init(center: mapView.userLocation.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        let coordinateRegion = MKCoordinateRegion.init(center: mapView.userLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /*
    func sendUserLocation() {
        // sending over user location called each time we enter the search criteria
        
        let searchStoreCell = SearchStoreCell()
        guard let userLocation = manager?.location else { return }
        searchStoreCell.configureUserLocationCell(userLocation: userLocation)
    }
    */
    
    func plotStoreAnnotations() {
        
        // may add a completion block to this that then calls for the search table to come out after the annotations populate
        
        let storeAnnotationRef = self.rootRef.child("stores")
        storeAnnotationRef.observe(.value) { snapshot in
            
            let storeDictionaries = snapshot.value as? [String: Any] ?? [:]
            
            print(snapshot)
            
            for (key, _) in storeDictionaries {
                if let storeDict = storeDictionaries[key] as? [String: Any] {
                    let store = StoreAnnotation(dictionary: storeDict)
                    
                    DispatchQueue.main.async {
                        
                        let storeFrontAnnotation = MKPointAnnotation()
                        storeFrontAnnotation.coordinate = CLLocationCoordinate2D(latitude: store?.latitude ?? 0, longitude: store?.longitude ?? 0)
                        
                        storeFrontAnnotation.title = store?.title
                        
                        guard let points = store?.points else { return }
                        storeFrontAnnotation.subtitle = String(points)
                        
                        
                        self.mapView.addAnnotation(storeFrontAnnotation)
                        
                    }
                }
 
            }
        }
    }
    
    
    func configureMapViewButtons() {
        
        let tabBarHeight = CGFloat((tabBarController?.tabBar.frame.size.height)!)
        
        let centerMapDimension: CGFloat = 50
        mapView.addSubview(centerMapBackground)
        centerMapBackground.anchor(top: mapView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 80, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: centerMapDimension, height: centerMapDimension)
        centerMapBackground.layer.cornerRadius = centerMapDimension / 2
        centerMapBackground.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
        //centerMapBackground.layer.cornerRadius = 10
        
        centerMapBackground.addSubview(centerMapButton)
        centerMapButton.anchor(top: nil , left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 35, height: 35)
        centerMapButton.centerXAnchor.constraint(equalTo: centerMapBackground.centerXAnchor).isActive = true
        centerMapButton.centerYAnchor.constraint(equalTo: centerMapBackground.centerYAnchor).isActive = true
        
        
        let settingsDimension: CGFloat = 35
        mapView.addSubview(settingsButtonBackground)
        settingsButtonBackground.anchor(top: mapView.topAnchor, left: mapView.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: settingsDimension, height: settingsDimension)
        settingsButtonBackground.layer.cornerRadius = settingsDimension / 2
        //settingsButtonBackground.layer.cornerRadius = 10
        
        mapView.addSubview(settingsButton)
        settingsButton.anchor(top: nil , left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 22, height: 23)
        settingsButton.centerXAnchor.constraint(equalTo: settingsButtonBackground.centerXAnchor).isActive = true
        settingsButton.centerYAnchor.constraint(equalTo: settingsButtonBackground.centerYAnchor).isActive = true
        settingsButton.tintColor = UIColor.rgb(red: 220, green: 220, blue: 220)
        
        
        let cancelTripButtonDimension: CGFloat = 45
        mapView.addSubview(cancelTripBackground)
        cancelTripBackground.anchor(top: mapView.topAnchor, left: nil, bottom: nil, right: mapView.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: cancelTripButtonDimension, height: cancelTripButtonDimension)
        cancelTripBackground.layer.cornerRadius = 10
        
        mapView.addSubview(cancelTripButton)
        cancelTripButton.anchor(top: cancelTripBackground.topAnchor , left: cancelTripBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 13, paddingLeft: 13, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        /*
        let rewardsDimension: CGFloat = 40
        mapView.addSubview(simpleRewardsBackground)
        simpleRewardsBackground.anchor(top: mapView.topAnchor, left: nil, bottom: nil, right: mapView.rightAnchor, paddingTop: 34, paddingLeft: 0, paddingBottom: 0, paddingRight: 56, width: rewardsDimension, height: rewardsDimension)
        simpleRewardsBackground.layer.cornerRadius = 15
        
        
        mapView.addSubview(simpleRewardsButton)
        simpleRewardsButton.anchor(top: simpleRewardsBackground.topAnchor , left: simpleRewardsBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 11, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        */
        
        //mapView.addSubview(analyticsButton)
        //analyticsButton.anchor(top: nil, left: nil, bottom: mapView.bottomAnchor, right: mapView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: tabBarHeight + 20, paddingRight: 20, width: 60, height: 60)
        
        /*
        mapView.addSubview(rewardsBackgroundSubView)
        rewardsBackgroundSubView.anchor(top: mapView.topAnchor, left: nil, bottom: nil, right: mapView.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 45, height: 45)
        rewardsBackgroundSubView.layer.cornerRadius = 45 / 2
        
        
        rewardsBackgroundSubView.addSubview(rewardsBackground)
        rewardsBackground.anchor(top: rewardsBackgroundSubView.topAnchor, left: rewardsBackgroundSubView.leftAnchor, bottom: rewardsBackgroundSubView.bottomAnchor, right: rewardsBackgroundSubView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 45, height: 45)
        rewardsBackground.layer.cornerRadius = 45 / 2
        
        rewardsBackground.addSubview(homeRewardsButton)
        homeRewardsButton.anchor(top: rewardsBackground.topAnchor, left: rewardsBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 11, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 22, height: 23)
        */
        
        /*
        mapView.addSubview(startTripButton)
        startTripButton.anchor(top: mapView.topAnchor, left: nil, bottom: nil, right: mapView.rightAnchor, paddingTop: 300, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 100, height: 30)
        startTripButton.layer.cornerRadius = 10

        mapView.addSubview(stopTripButton)
        stopTripButton.anchor(top: startTripButton.bottomAnchor, left: nil, bottom: nil, right: mapView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 100, height: 30)
        stopTripButton.layer.cornerRadius = 10

        */
        
        
        mapView.addSubview(startStopButton)
        startStopButton.anchor(top: nil, left: nil, bottom: mapView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 80, paddingRight: 0, width: 100, height: 100)
        startStopButton.layer.cornerRadius = 100 / 2
        startStopButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
        
        
        
        /*
         
         mapView.addSubview(analyticsButton)
         analyticsButton.anchor(top: nil, left: nil, bottom: mapView.bottomAnchor, right: mapView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: tabBarHeight + 20, paddingRight: 20, width: 60, height: 60)
         analyticsButton.layer.cornerRadius = 60 / 2
         
         //analyticsBackground.addSubview(analyticsButton)
         //analyticsButton.anchor(top: analyticsBackground.topAnchor, left: analyticsBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
         //analyticsButton.layer.cornerRadius = 60 / 2
         
        navigatorSubView.addSubview(startTripButton)
        startTripButton.anchor(top: navigatorSubView.topAnchor, left: nil, bottom: nil, right: navigatorSubView.rightAnchor, paddingTop: 1.5, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 90, height: 27)
        //startTripButton.layer.cornerRadius = 12
        startTripButton.layer.cornerRadius = 13
        
        navigatorSubView.addSubview(cancelTripButton)
        cancelTripButton.anchor(top: navigatorSubView.topAnchor, left: nil, bottom: nil, right: startTripButton.leftAnchor, paddingTop: 1.5, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 90, height: 27)
        //cancelTripButton.layer.cornerRadius = 12
        cancelTripButton.layer.cornerRadius = 13
        
        
        mapView.addSubview(customQRButton)
        customQRButton.anchor(top: navigatorSubView.bottomAnchor, left: nil, bottom: nil, right: mapView.rightAnchor, paddingTop: 18, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 42, height: 42)
        
       mapView.addSubview(customCenterMap)
       customCenterMap.anchor(top: customQRButton.bottomAnchor, left: nil, bottom: nil, right: mapView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 42, height: 42)
        */
    }
    
    // function for swipe and search table animations
    func animateInputView(targetPosition: CGFloat, completion: @escaping(Bool) -> ()) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.searchTableView.frame.origin.y = targetPosition
        }, completion: completion)
    }
    
    func configureTableView() {
        
        // configure search store view table view
        tableView = UITableView()
        //tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        
        // search table view background
        tableView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //tableView.alpha = 0.8
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        
        tableView.register(SearchStoreCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // seperator insets.
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        
        searchTableView.addSubview(tableView)
        /*
        tableView.anchor(top: searchBar.bottomAnchor, left: searchTableView.leftAnchor, bottom: searchTableView.bottomAnchor, right: searchTableView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: 0, height: 0)
        */
        
        tableView.anchor(top: searchTableView.topAnchor, left: searchTableView.leftAnchor, bottom: searchTableView.bottomAnchor, right: searchTableView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: 0, height: 0)

    }
  
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = nil
        
        dismissOnSearch()
        
        self.customMenuButton.isHidden = false
        //self.customMenuButtonArrow.isHidden = false
        //self.customProfileButton.isHidden = false
        
        self.customMenuButton.alpha = 1
        //self.customProfileButton.alpha = 1
        
        /*
        UIView.animate(withDuration: 0.15) {
            self.customMenuButton.isHidden = false
            self.customMenuButton.alpha = 1
        }
        */
        //showTabBar()
        //handleDismiss()
    }
    
    
    func dismissOnSearch() {
        
        if expansionState == .FullyExpanded {
            searchTableView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            lineView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.searchTableView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                    self.searchTableView.alpha = 0
                self.lineView.alpha = 0
                    
                }) { (_) in
                    self.searchTableView.transform = .identity
                    self.lineView.transform = .identity
                    
                    self.searchTableView.isHidden = true
                    self.lineView.isHidden = true
                    
                    self.isSearchTableViewVisible = false
                    print("DEBUG: Search table is set to false")
                    self.expansionState = .NotExpanded
                }
         }
        
        
        /*
        if expansionState == .FullyExpanded {
            self.searchBar.endEditing(true)
            self.searchBar.showsCancelButton = false
            
            animateInputView(targetPosition: self.searchTableView.frame.origin.y + 645) { (_) in
        
                self.expansionState = .NotExpanded
                print("fully expanded to not Expanded")
            }
            /*
            UIView.animate(withDuration: 0.25) {
                self.centerMapButton.frame.origin.y += 524
            }
            */
        }
        */
            
            /*
            UIView.animate(withDuration: 0.25) {
                self.centerMapButton.frame.origin.y += 174
            }
            */

    }
    
    
    func saveSelectedPath(forMapItem mapItem: MKMapItem) {
        
        //manager?.stopUpdatingLocation() // temporary stop updating location
        //print("Location status has temporarily stopped updating")
        
        removeSource = oldSource
        oldSource = mapItem
        
        // initiate variable i with a value of 1
        i = 1
        getTripKey()
        
        //reanimateStartTripButton()
        reanimateCancelTripButton()
        
        /*
         removeStartTripButton()
         isStoreDetailViewVisible = false
         */
    }
    
    func removeSelectedPath(forMapItem mapItem: MKMapItem) {
        
        let storeCell = StoreCell()
        
        storeCell.homeVC = self
        //StoreCell().animateCancelButtonOut()
    // --> animateRemoveSegmentButtonOut()
        UpdateService.instance.updateUserLocation(withCoordinate: mapView.userLocation.coordinate)
        oldSource = removeSource
        
        /*
         removeStartTripButton()
         isStoreDetailViewVisible = false
         */
    }
    
    // MARK: - Handlers
    
    @objc func handleCancelTrip() {
        // Perhaps this can be a function that centers, remove all overlays, and resets the trip itself.
        mapView.removeOverlays(mapView.overlays)
        
        //removeCancelTripButton()
        dismissStoreDetailView()
        centerMapOnUserLocation()
        
        // we don't need to remove the trip at all. just stop the pedometer and replot the route
        let currentUserID = Auth.auth().currentUser?.uid
        DataService.instance.REF_TRIPS.child(currentUserID!).removeValue()
        
        cancelTripBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
         
         UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
             
             self.cancelTripBackground.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
             self.cancelTripBackground.alpha = 0

         }) { (_) in

             self.cancelTripBackground.transform = .identity
         }
    }
    
    @objc func handleNotifcationVC() {
        // very important to initialize this view controller as it should be with a collection view and flow layout
        let notificationVC = NotificationsVC()
        navigationController?.pushViewController(notificationVC, animated: true)
        
        /*
        let nav = self.navigationController
        DispatchQueue.main.async {
            nav?.view.layer.add(CATransition().popFromRight(), forKey: nil)
            nav?.pushViewController(notificationVC, animated: true)
        }
        */
    }
    
    @objc func handleSearchFriends() {
        
        let searchVC = SearchVC()
        navigationController?.pushViewController(searchVC, animated: true)
        /*
        let nav = self.navigationController
        DispatchQueue.main.async {
            nav?.view.layer.add(CATransition().popFromRight(), forKey: nil)
            nav?.pushViewController(searchVC, animated: true)
        }
        */
    }
    
    @objc func handleMessengerNotificationVC() {
        
        let messagesVC = MessagesController()
        navigationController?.pushViewController(messagesVC, animated: true)
        
        /*
        let nav = self.navigationController
        DispatchQueue.main.async {
            nav?.view.layer.add(CATransition().popFromRight(), forKey: nil)
            nav?.pushViewController(messagesVC, animated: true)
        }
        */
    }
    
    @objc func handleProfileSelected() {
        print("DEBUG: Profile view selected")
        
        let profileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        //profileVC.modalPresentationStyle = .fullScreen
        //present(profileVC, animated: true, completion:nil)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
    @objc func expansionStateCheck() {
    
        
        if expansionState == .FullyExpanded {
            
            searchTableView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                
                self.searchTableView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                self.searchTableView.alpha = 0
                
            }) { (_) in
                self.searchTableView.transform = .identity
                self.expansionState = .NotExpanded
            }
            

            /*
            animateInputView(targetPosition: self.searchTableView.frame.origin.y + 645) { (_) in
                self.expansionState = .NotExpanded
                print("DEBUG: Fully expanded to not expanded")
                
                //self.searchTableView.isHidden = true
                self.isSearchTableViewVisible = false
                self.handleMenuSlider()
            }
            */
        } else {
            
            handleMenuSlider()
            //searchTableView.isHidden = true
        }
    }
    
    @objc func expansionStateCheckRight() {
        
        if expansionState == .FullyExpanded {
            
            searchTableView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                
                self.searchTableView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                self.searchTableView.alpha = 0
                
            }) { (_) in
                self.searchTableView.transform = .identity
                self.expansionState = .NotExpanded
            }
            
        } else {
            
            handleRightMenuSlider()
            //searchTableView.isHidden = true
        }
    }
    
    
    
        @objc func expansionStateCheckGroups() {
        
        if expansionState == .FullyExpanded {
            
            searchTableView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                
                self.searchTableView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                self.searchTableView.alpha = 0
                
            }) { (_) in
                self.searchTableView.transform = .identity
                self.expansionState = .NotExpanded
            }
            
        } else {
            
            handleGroupsSlider()
            //searchTableView.isHidden = true
        }
    }
    
    func configureStoreDetailBV() {
        
        storeDetailBV.anchor(top: self.mapView.topAnchor, left: self.mapView.leftAnchor, bottom: self.mapView.bottomAnchor, right: self.mapView.rightAnchor, paddingTop: 0, paddingLeft: -5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        UIView.animate(withDuration: 0.25, animations: {
                    self.storeDetailBV.backgroundColor = UIColor(white: 0, alpha: 0.5)
                    self.storeDetailBV.alpha = 1
                })

    }
    
    func handleDismissStoreBV() {
        
        UIView.animate(withDuration: 0.25) {
        self.storeDetailBV.alpha = 0
        
        }
        
    }

    func configureMenuView() {

        menuVC.delegate = self
        
        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            
            if let window:UIWindow = applicationDelegate.window {
                
                blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
                
                window.addSubview(blackView)
                blackView.frame = window.frame
            
                UIView.animate(withDuration: 0.5, animations: {
                    self.blackView.alpha = 0
                })
            }
        }
        
        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            
            if let window:UIWindow = applicationDelegate.window {
                
                window.addSubview(menuVC.view)
                
                // initial starting point of the view
                menuVC.view.frame = CGRect(x: -(view.frame.width) - 40, y: 0, width: 450, height: window.frame.height)

            }
        }
    }
    
    func configureRightMenuView() {
    
           print("DEBUG: Right menu is configured at this point.")
           
           rightMenuVC.delegate = self
        
           if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
               
               if let window:UIWindow = applicationDelegate.window {
                   
                   rightMenuBV.backgroundColor = UIColor(white: 0, alpha: 0.5)
                   rightMenuBV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRightMenuDismiss)))
                
               
                   window.addSubview(rightMenuBV)
                   rightMenuBV.frame = window.frame
                            
                   UIView.animate(withDuration: 0.5, animations: {
                       self.rightMenuBV.alpha = 0
                   })
               }
           }
           
           if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
               
               if let window:UIWindow = applicationDelegate.window {
                   
                window.addSubview(rightMenuVC.view)
                
                
                // initial starting point of the horizontal slide view
                //rightMenuVC.view.frame = CGRect(x: (view.frame.width) + 35, y: 0, width: 450, height: window.frame.height)
                    
                // the proper slide from east to west requires a subtracted value
                //rightMenuVC.view.frame = CGRect(x: (view.frame.width) - 200, y: 0, width: 450, height: window.frame.height)
                
                // need to add 16 to the height of the original position to account for the indicator view poking up
               
                
                
                rightMenuVC.view.frame = CGRect(x: 0, y: view.frame.height + 16, width: view.frame.width, height: 675)
               
                /*
                window.addSubview(indicatorView)
                
                indicatorView.anchor(top: rightMenuVC.view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: -16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 5)
                indicatorView.centerX(inView: rightMenuVC.view)
                */
            
               }
           }
       }
    
    
    
    @objc func handleMenuSlider() {

        if isStoreDetailViewVisible == true {
            
            storeDetailView.dismissDetailView()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.presentSlideMenu()
            }
            
        } else {
            
            presentSlideMenu()
        }
    }
    
    func presentSlideMenu() {
        
        //handleMenuBlackView()
        
        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
                          
            if let window:UIWindow = applicationDelegate.window {
                              
                //window.addSubview(menuVC.view)
                              
                // initial starting point of the view
                //menuVC.view.frame = CGRect(x: -(view.frame.width), y: 0, width: 450, height: window.frame.height)
                              
                let width: CGFloat = 570
                let collectionViewX = window.frame.width - width
                            
                UIView.animate(withDuration: 0.15) {
                    self.blackView.alpha = 1
                }
                              
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.70, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
  
                // final starting point of the view
                    self.menuVC.view.frame = CGRect(x: collectionViewX, y: 0, width: self.menuVC.view.frame.width, height: window.frame.height)
                    self.isMenuExpanded = true

                }, completion: nil)
            }
        }
    }
    
    func presentRightSlideMenu() {
        
        //handleMenuBlackView()
        
        let notificationsVC = NotificationsVC()
        //navigationController?.pushViewController(notificationsVC, animated: true)
        
        let nav = self.navigationController
        DispatchQueue.main.async {
            
            self.view.window!.backgroundColor = UIColor.white
            nav?.view.layer.add(CATransition().popFromRight(), forKey: kCATransition)
            nav?.pushViewController(notificationsVC, animated: false)
        }
        
        /*
        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            if let window:UIWindow = applicationDelegate.window {
                
                //let width: CGFloat = 510
                //let collectionViewX = window.frame.width - width + 155
                
                //let height: CGFloat = 568
                let height: CGFloat = 625
                let collectionViewY = window.frame.height - height
                
                UIView.animate(withDuration: 0.15) {
                    self.rightMenuBV.alpha = 1
                }
                
                UIView.animate(withDuration: 0.40, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                
                    // final starting point of the view
                    //self.rightMenuVC.view.frame = CGRect(x: collectionViewX, y: 0, width: self.rightMenuVC.view.frame.width, height: window.frame.height)
                        
                    self.rightMenuVC.view.frame = CGRect(x: 0, y: collectionViewY, width: window.frame.width, height: self.rightMenuVC.view.frame.height)
                    
                    //self.indicatorView.frame = CGRect(x: 0, y: collectionViewY, width: window.frame.width, height: self.rightMenuVC.view.frame.height)
                    
                    // add bounce of indicator view
                    self.indicatorView.frame.origin.y = self.rightMenuVC.view.frame.origin.y - self.rightMenuVC.view.frame.height
                    
                    // remove bounce of indicator view
                    //self.indicatorView.frame.origin.y = self.indicatorView.frame.origin.y - self.rightMenuVC.view.frame.height
                    
                    self.isRightMenuExpanded = true
                                                 
                }, completion: nil)
            }
        }
 */
    }
    
    @objc func handleRightMenuSlider() {

        if isStoreDetailViewVisible == true {
            
            storeDetailView.dismissDetailView()
            
            rightMenuVC.collectionView.isHidden = true
            rightMenuVC.searchBarContainer.isHidden = true
            
            presentRightSlideMenu()
            
   
        } else {
            
            rightMenuVC.collectionView.isHidden = true
            rightMenuVC.searchBarContainer.isHidden = true
            
            presentRightSlideMenu()
        }
    }
    

    
     @objc func handleGroupsSlider() {

         if isStoreDetailViewVisible == true {
             
             storeDetailView.dismissDetailView()
             
            rightMenuVC.configureSearchBar()
            rightMenuVC.collectionView.isHidden = false
            rightMenuVC.searchBarContainer.isHidden = false
             
             presentRightSlideMenu()
             
    
         } else {
            rightMenuVC.configureSearchBar()
            rightMenuVC.collectionView.isHidden = false
            rightMenuVC.searchBarContainer.isHidden = false
             
             presentRightSlideMenu()
         }
     }
    
    @objc func handleNotificationSlider() {
        
        // slide menu configured here

               //notificationsVC.delegate = self
               
               if self.notificationsVC.view.tag == 100 {
                   // removing collection view from superview
                   self.notificationsVC.view.removeFromSuperview()
                   print("removing menu view from superview")
               }
               
               if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
                   
                   if let window:UIWindow = applicationDelegate.window {
                   
                       window.addSubview(notificationsVC.view)

                       // initial starting point of the view
                       notificationsVC.view.frame = CGRect(x: 0, y: view.frame.height, width: window.frame.width, height: 450)
                       // core graphic height value of where the bootom of the view starts
                       
                       let height: CGFloat = 450
                       
                       // may need to change this back to view.frame.width
                       let collectionViewY = window.frame.height - height
                       
                       UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                           self.blackView.alpha = 1
                        
                           // final starting point of the view
                           self.notificationsVC.view.frame = CGRect(x: 0, y: collectionViewY, width: window.frame.width , height: self.notificationsVC.view.frame.height )

                           self.isNotificationsExpanded = true
                           print("menu set to be expanded")
                        
                          // self.collectionView.tag = 100
                           
                           //self.configureSliderMenu()
                           
                       }, completion: nil)
                   }
               }
    }
    
    @objc func dismissNotificationsSlider() {
        
        let height: CGFloat = 450

        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
        
        if let window:UIWindow = applicationDelegate.window {

            let collectionViewY = window.frame.height - height

                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    
                    print("DEBUG: FROM HERE I CAN GET A RESPONSE")
                    
                    self.notificationsVC.view.frame = CGRect(x: 0, y: collectionViewY - 450, width: window.frame.height, height: self.notificationsVC.view.frame.height)
        
                    self.isNotificationsExpanded = false
                })
            }
        }
    }

    
    func setMenuContstraints() {
        /*
        menuVC.view.translatesAutoresizingMaskIntoConstraints = false
        menuVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        menuVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        menuVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        menuVC.view.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        */
        
    }
    
    func handleMenuBlackView() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 1
        })
        
        /*
        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            
            if let window:UIWindow = applicationDelegate.window {
                
                blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
                blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
                window.addSubview(blackView)
                blackView.frame = window.frame
            
                UIView.animate(withDuration: 0.5, animations: {
                    self.blackView.alpha = 1
                })
            }
        }
        */
        
    }
    
    func handleBlackView() {
        
        //navigationController?.navigationBar.isHidden = true
        
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        mapView.addSubview(blackView)
        blackView.frame = mapView.frame
        //blackView.alpha = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.blackView.alpha = 1
        })
    }
    /*
    func dismissSliderMenu() {
        
        let width: CGFloat = 575

            if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            
            if let window:UIWindow = applicationDelegate.window {

                let collectionViewX = window.frame.width - width

                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                        
                        print("DEBUG: FROM HERE I CAN GET A RESPONSE")
                        
                        self.menuVC.view.frame = CGRect(x: collectionViewX - 575, y: 0, width: self.menuVC.view.frame.width, height: window.frame.height)
            
                        self.isMenuExpanded = false
                    })
                }
            }
    }
    */
    @objc func handleDismiss() {
        
        //let width: CGFloat = 550
        let width: CGFloat = 570
        
        if isMenuExpanded == true {
            
            if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            
            if let window:UIWindow = applicationDelegate.window {
                
                print("in practice this works")
                let collectionViewX = window.frame.width - width
                
                
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                            self.menuVC.view.frame = CGRect(x: collectionViewX - 570, y: 0, width: self.menuVC.view.frame.width, height: window.frame.height)
            
                        self.isMenuExpanded = false
                        print("menu expanded set to false")
                    })
                }
            }
        }
        
        
        
        UIView.animate(withDuration: 0.25) {
        self.blackView.alpha = 0
        }
            /*
        //if searchTableView.isHidden == false {
        
        if isSearchTableViewVisible == true {
            print("DEBUG: The search table is visible and needs to be dismissed")
            dismissOnSearch()
            
        } else {
            // storeDetailView.dismissDetailView()
            UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            }
    
        */
            
            
        //showTabBar()
        //self.navigationController?.navigationBar.isHidden = false
    }
    
    
    @objc func handleRightMenuDismiss() {
        
        //let height: CGFloat = 568
        let height: CGFloat = 525
        
        if isRightMenuExpanded == true {
            
            if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            
            if let window:UIWindow = applicationDelegate.window {
                
                print("in practice this works")
                let collectionViewY = window.frame.width - height
                
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                            self.rightMenuVC.view.frame = CGRect(x: 0, y: -(collectionViewY) + 650, width: window.frame.width, height: self.rightMenuVC.view.frame.height)
            
                        self.isRightMenuExpanded = false
                        print("menu expanded set to false")
                    })
                }
            }
        }

        UIView.animate(withDuration: 0.25) {
        self.rightMenuBV.alpha = 0
        }
        
        rightMenuVC.handleDissmissKeyboard()
         
    }
    
    func handleBlackViewOnDismiss() {
        UIView.animate(withDuration: 0.25) {
            self.blackView.alpha = 0
        }
        //self.navigationController?.navigationBar.isHidden = false
    }
    func handleRightMenuBVOnDismiss() {
        UIView.animate(withDuration: 0.25) {
            self.rightMenuBV.alpha = 0
        }
        //self.navigationController?.navigationBar.isHidden = false
    }
    
    /*
    @objc func handleProfileSelected() {
        
        // very important to initialize this view controller as it should be with a collection view and flow layout
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
  
        let nav = self.navigationController
        DispatchQueue.main.async {
            nav?.view.layer.add(CATransition().popFromRight(), forKey: nil)
            nav?.pushViewController(userProfileVC, animated: false)
        }
    }
    */
 
    
    @objc func handleMainTab() {
        print("Handle main tab")
        
        let mainTabVC = MainTabVC()
        self.present(mainTabVC, animated: true, completion: nil)
    }
    
    @objc func handleCenterMapBtnPressed() {
        
        centerMapOnUserLocation()
        
       //centerMapButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        centerMapBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            
            //self.centerMapButton.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            //self.centerMapButton.alpha = 0
            
            self.centerMapBackground.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            self.centerMapBackground.alpha = 0
        }) { (_) in
            //self.centerMapButton.transform = .identity
            self.centerMapBackground.transform = .identity
        }
    }
    
    @objc func handleStartStopTrip() {
    
        if startStopButton.titleLabel?.text == "START" {
            
            
            startStopButton.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
                           
                           UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                               
                            self.startStopButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                               
                           }) { (_) in
                            self.startStopButton.transform = .identity
                }
            
            
            pedoDistanceLabel.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            milesLabel.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            //toggleSaveRemoveSegmentView.transform = CGAffineTransform(scaleX: 1, y: 1)
                           
                           UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                            
                            self.pedoDistanceLabel.alpha = 1
                            self.milesLabel.alpha = 1
                            //self.toggleSaveRemoveSegmentView.alpha = 1
                            
                            self.pedoDistanceLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                            self.milesLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                            //self.toggleSaveRemoveSegmentView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                               
                           }) { (_) in
                            self.pedoDistanceLabel.transform = .identity
                            self.milesLabel.transform = .identity
                            //self.toggleSaveRemoveSegmentView.transform = .identity
                }
                
                print("start trip pressed")
        
               startStopButton.setTitle("STOP", for: .normal)
            startStopButton.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), for: .normal)
                startStopButton.backgroundColor = .white
                
                saveSegmentVisible = false
            
              
                
                print("start the checking location status agian.")
                checkLocationAuthStatus()
                
                navigateRunner()

                storeDetailView.dismissDetailView()

                startPedometer()
                
                plotProposedTrip()
            
                
                // if we have the select path button showing , remove it before starting
                if initialCheckpointSelected == true {
                    //self.toggleSaveRemoveSegmentView.transform = CGAffineTransform(scaleX: 1, y: 1)

                
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    
                    //self.toggleSaveRemoveSegmentView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                    //self.toggleSaveRemoveSegmentView.alpha = 0


                }) { (_) in
                    //self.toggleSaveRemoveSegmentView.transform = .identity
                    
                    // setting your boolean variable here
                    
                }

                }
                
            
            
            } else {
            
            startTripPressed = true
            // when we stop.. we may need to make sure the last key is saved as the key to compare to determine when to end route
            
            startStopButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            pedoDistanceLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            milesLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            
            
                           
                           UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                               
                            
                            self.startStopButton.alpha = 0
                            self.pedoDistanceLabel.alpha = 0
                            self.milesLabel.alpha = 0
                            
                            self.startStopButton.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                            self.pedoDistanceLabel.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                            self.milesLabel.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                            
                           }) { (_) in
                            self.startStopButton.transform = .identity
                            self.pedoDistanceLabel.transform = .identity
                            self.milesLabel.transform = .identity
                }

                  print("stop trip and upload all final activity.")
                  
                  // setting this to false
                  initialCheckpointSelected = false
                  
                  // if the pedometer has started then we need to stop it
                  stopPedometer()
                  
               startStopButton.setTitle("START", for: .normal)
            startStopButton.setTitleColor(UIColor.airBnBNew(), for: .normal)
                 startStopButton.backgroundColor = .white
      
            
            
            
            
            print("DEBUG: START TRIP SHOULD BE TRUE")
           
            saveRun()
            
            newTimer?.invalidate()
            manager?.stopUpdatingLocation()
            

            
            // when your trip is over the checkpoints you actually reach are
            //loadMap()
            
            }
        }

    
    @objc func handleStopTrip() {
        
        print("stop trip and upload all final activity.")
        
        // setting this to false
        initialCheckpointSelected = false
        
        // if the pedometer has started then we need to stop it
        stopPedometer()
        
        // when your trip is over the checkpoints you actually reach are
        //plotActualTrip()
    
    }
    
    func plotProposedTrip() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        //count = 1
        
        // initial source of user saved here in preparation to plot complete route
        //let currentLocation: CLLocation = (manager?.location)!
        
        guard let currentLocation = manager?.location else { return }
        let placeMark = MKPlacemark(coordinate: currentLocation.coordinate)
        let placeHolder = MKMapItem(placemark: placeMark)
        savedSource = placeHolder
        
        
        // observe the last trip within trip history
        DataService.instance.REF_TRIPS.child(currentUid).queryLimited(toLast: 1).observe(.childAdded) {(snapshot: DataSnapshot) in
            let tripId = snapshot.key
                print("DEBUG: TRIP ID \(tripId)")
            
            if let segmentSnap = snapshot.children.allObjects as? [DataSnapshot] {
                for segment in segmentSnap {
                    
                    let segmentId = segment.key
                    print("DEBUG: SEGMENT ID \(segmentId)")
                    
                    //currentTripId = tripId
                    
                    // need the last known value of the trip in order to stop the trip at at the end
                    self.finalSegmentId = segmentId
                    print("PLOT PATH KEY VALUES \(self.finalSegmentId ?? "")")
                   
                    DataService.instance.REF_TRIPS.child(currentUid).child(tripId).child(segmentId).child("destinationCoordinate").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let destinCoordinatesArray = snapshot.value as! NSArray
                        let latitude = destinCoordinatesArray[0] as! Double
                        let longitude = destinCoordinatesArray[1] as! Double
                    
                    self.pathDestination = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    let placemark = MKPlacemark(coordinate: self.pathDestination )
                    let mapItem = MKMapItem(placemark: placemark)
                    
                        self.plotSegment(forMapItem: mapItem)
            
                    })
               
            /*
            // then observe the last segment entry within the trip
            DataService.instance.REF_TRIPS.child(currentUid).child(tripId).queryLimited(toFirst: UInt(self.count)).observe(.childAdded) {(snapshot: DataSnapshot) in
                key = snapshot.key
                
                print("DEBUG: SNAPSHOT VALUE \(snapshot)" )
                
                DataService.instance.REF_TRIPS.child(currentUid).child(tripId).child(key).child("destinationCoordinate").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let destinCoordinatesArray = snapshot.value as! NSArray
                    let latitude = destinCoordinatesArray[0] as! Double
                    let longitude = destinCoordinatesArray[1] as! Double
                
                self.pathDestination = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                let placemark = MKPlacemark(coordinate: self.pathDestination )
                let mapItem = MKMapItem(placemark: placemark)
                
                    if destinCoordinatesArray != [] {
                        
                        print("DESTINATION IS NOT EMPTY")
                self.plotSegment(forMapItem: mapItem)
                
                // incrementing the count value
                self.count += 1
                
                /*
                monitorRegionLocation(center: destinCoord, identifier: "placeholder")
                addUserTripPolyline(forMapItem: mapItem)
                
                let placeMark = MKPlacemark(coordinate: userLocation.coordinate)
                let placeHolder = MKMapItem(placemark: placeMark)
                */
                    }
                    
                })
            }
            */
                    
                    
                }
            }
            
            
        }
    }
    
    func plotSegment(forMapItem mapItem: MKMapItem) {

        
        // i want to plot the segment show the user route via a zoom out, then... zoom in when the user is read to go...
        
         let request = MKDirections.Request()
         request.source = savedSource
         request.destination = mapItem
         request.transportType = MKDirectionsTransportType.walking
        
        let directions = MKDirections(request: request)
         directions.calculate { (response, error) in
             guard let response = response else {
                 self.showAlert(error.debugDescription)
                 return
             }
             self.route = response.routes[0] // The int 0 is the first fastest route. This will need to be changed to a route with a specific distance.
             self.mapView.addOverlay(self.route.polyline)
             //self.shouldPresentLoadingView(false)
        }
        
        print("DEBUG: SAVED SOURCE \(savedSource)")
        print("DEBUG: DESTINATION \(mapItem)")
        
        savedSource = mapItem
        
         
            
             /*
             let annotation = MKPointAnnotation()
             annotation.coordinate = mapItem.placemark.coordinate
             self.oldSource = userStartLocation
             self.zoomToFit(selectedAnnotation: annotation)
             
             
             
             
             
             
             if didSetUserOrigin == false {
                 
                 let placeMark = MKPlacemark(coordinate: userLocation.coordinate)
                 let placeHolder = MKMapItem(placemark: placeMark)
                 
                 oldSource = placeHolder
                 
                 didSetUserOrigin = true
                 
             } else {
                 
                 return
             }
             
             
            */
        
     }
    
    
    @objc func handleStartStopPedometer() {
        print("Pedometer started")
        
        // not sure if this is being used.
        
        if startStopPedometerButton.titleLabel?.text == "Start Pedometer" {
            //Start the pedometer
            pedometer = CMPedometer()
            startTimer() // start the timer
            pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
                if let pedData = pedometerData {
                    self.numberOfSteps = Int(truncating: pedData.numberOfSteps)
                    //self.stepsLabel.text = "Steps:\(pedData.numberOfSteps)"
                    if let distance = pedData.distance {
                        self.distance = Double(truncating: distance)
                    }
                    if let averageActivePace = pedData.averageActivePace {
                        self.averagePace = Double(truncating: averageActivePace)
                    }
                    if let currentPace = pedData.currentPace {
                        self.pace = Double(truncating: currentPace)
                    }
                } else {
                    //self.stepsLabel.text = "Steps: Not Available"
                    self.numberOfSteps = nil
                }
            })
                        
           //Toggle the UI to on state
            statusTitle.text = "Pedometer On"
           startStopPedometerButton.setTitle("Stop Pedometer", for: .normal)
           startStopPedometerButton.backgroundColor = stopColor
            
            
            
            seconds = 0
            recordedDistance = Measurement(value: 0, unit: UnitLength.meters)
            locationList.removeAll()    // will need to at some point
            
            // a second timer here until I figure out what i'm doing
            newTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
              self.eachSecond()
            }
             
            startLocationUpdates() // monitor updates have already started
            
            
        } else {
              
           //Stop the pedometer
            pedometer.stopUpdates()
            stopTimer() // stop the timer
            
           //Toggle the UI to off state
            statusTitle.text = "Pedometer Off: " + timeIntervalFormat(interval: timeElapsed)
            
           startStopPedometerButton.backgroundColor = startColor
           startStopPedometerButton.setTitle("Start Pedometer", for: .normal)
            
            
            //loadMap()
        }
    }
    
    func startPedometer() {
        
         //Start the pedometer
         pedometer = CMPedometer()
         startTimer() // start the timer
        
         pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
             if let pedData = pedometerData {
                 self.numberOfSteps = Int(truncating: pedData.numberOfSteps)
                 //self.stepsLabel.text = "Steps:\(pedData.numberOfSteps)"
                 if let distance = pedData.distance {
                     self.distance = Double(truncating: distance)
                 }
                 if let averageActivePace = pedData.averageActivePace {
                     self.averagePace = Double(truncating: averageActivePace)
                 }
                 if let currentPace = pedData.currentPace {
                     self.pace = Double(truncating: currentPace)
                 }
             } else {
                 //self.stepsLabel.text = "Steps: Not Available"
                 self.numberOfSteps = nil
             }
         })
                     
        //Toggle the UI to on state
        statusTitle.text = "Pedometer On"
        startStopPedometerButton.setTitle("Stop Pedometer", for: .normal)
        startStopPedometerButton.backgroundColor = stopColor
        
    }
    
    func stopPedometer() {
        //Stop the pedometer
                 pedometer.stopUpdates()
                 stopTimer() // stop the timer
                 
        
                //Toggle the UI to off state
                 statusTitle.text = "Pedometer Off: " + timeIntervalFormat(interval: timeElapsed)
                 
                startStopPedometerButton.backgroundColor = startColor
                startStopPedometerButton.setTitle("Start Pedometer", for: .normal)


    }
    
    // timer functions
    func startTimer() {
        if timer.isValid { timer.invalidate() }
        timer = Timer.scheduledTimer(timeInterval: timerInterval,target: self, selector: #selector(timerAction(timer:)) , userInfo: nil, repeats: true)
    }
    
    
    //function for core data
    func eachSecond() {
      seconds += 1
      //updateDisplay()
    }
    
    
    
    
    func saveRun() {
        
        let newRun = Run(context: CoreDataStack.context)
        
        newRun.distance = recordedDistance.value
        newRun.duration = Int16(seconds)
        //newRun.duration = Int16(timeElapsed)   // this may be the wrong format if so change back to seconds
        newRun.timestamp = Date()
      
 
      for location in locationList {
        let locationObject = Location(context: CoreDataStack.context)
        locationObject.timestamp = location.timestamp
        locationObject.latitude = location.coordinate.latitude
        locationObject.longitude = location.coordinate.longitude
        newRun.addToLocations(locationObject)
        
        
      }
      
      CoreDataStack.saveContext()
      
      run = newRun
        print("DOES THIS VALUE RUN PRESET ANYTHING \(run)")
        
        //mapView.removeOverlays(mapView.overlays)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            self.loadMap()
            
            // this is here to reset the folder creation for logo images
            self.didCreateFolder = false
         }
    }
    
    func mapRegion() -> MKCoordinateRegion? {
      guard
        let locations = run?.locations,
        locations.count > 0
      else {
        return nil
      }
        
      let latitudes = locations.map { location -> Double in
        let location = location as! Location
        return location.latitude
      }
        
      let longitudes = locations.map { location -> Double in
        let location = location as! Location
        return location.longitude
      }
        
      let maxLat = latitudes.max()!
      let minLat = latitudes.min()!
      let maxLong = longitudes.max()!
      let minLong = longitudes.min()!
        
      let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                          longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 3,
                                    longitudeDelta: (maxLong - minLong) * 3)
      return MKCoordinateRegion(center: center, span: span)
    }
    
    
    private func polyLine() -> [MulticolorPolyline] {
        
      // 1
      let locations = run.locations?.array as! [Location]
      var coordinates: [(CLLocation, CLLocation)] = []
      var speeds: [Double] = []
      var minSpeed = Double.greatestFiniteMagnitude
      var maxSpeed = 0.0
        
      // 2
      for (first, second) in zip(locations, locations.dropFirst()) {
        let start = CLLocation(latitude: first.latitude, longitude: first.longitude)
        let end = CLLocation(latitude: second.latitude, longitude: second.longitude)
        coordinates.append((start, end))
          
        //3
        let distance = end.distance(from: start)
        let time = second.timestamp!.timeIntervalSince(first.timestamp! as Date)
        let speed = time > 0 ? distance / time : 0
        speeds.append(speed)
        minSpeed = min(minSpeed, speed)
        maxSpeed = max(maxSpeed, speed)
      }
        
      //4
      let midSpeed = speeds.reduce(0, +) / Double(speeds.count)
        
      //5
      var segments: [MulticolorPolyline] = []
      for ((start, end), speed) in zip(coordinates, speeds) {
        let coords = [start.coordinate, end.coordinate]
        let segment = MulticolorPolyline(coordinates: coords, count: 2)
        segment.color = segmentColor(speed: speed,
                                     midSpeed: midSpeed,
                                     slowestSpeed: minSpeed,
                                     fastestSpeed: maxSpeed)
        segments.append(segment)
      }
      return segments
    }
    
    
    
    /*
    func polyLine() -> MKPolyline {
        guard let locations = run?.locations else {
        return MKPolyline()
      }
        
      let coords: [CLLocationCoordinate2D] = locations.map { location in
        let location = location as! Location
        return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
      }
        
        print("DEBUG: Here are the location coordinates \(coords)")
      return MKPolyline(coordinates: coords, count: coords.count)
    }
    */
    
    
    
    
    
    func loadMap() {
      guard
        let locations = run?.locations,  //  not saving anything  figure out
        locations.count > 0,
        let region = mapRegion()
      else {
          let alert = UIAlertController(title: "Error",
                                        message: "Sorry, this run has no locations saved",
                                        preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .cancel))
          present(alert, animated: true)
          return
      }
        
        print("HERE ARE THE LOCATIONS \(locations.count)")
        
      mapView.setRegion(region, animated: true)
        //mapView.addOverlay(polyLine())
        
        mapView.addOverlays(polyLine())
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.snapshotMapview()
         }
        
    }
    
    
    
    
    
    
    
    
    func stopTimer(){
        newTimer?.invalidate()
        displayPedometerData()
        
        
        let creationDate = Int(NSDate().timeIntervalSince1970)
        self.timeElapsed += self.timerInterval
            
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            
            // observe the last trip within trip history
            DataService.instance.REF_TRIPS.child(currentUid).queryLimited(toLast: 1).observe(.childAdded) {(snapshot: DataSnapshot) in
                let tripId = snapshot.key
                    print("DEBUG: TRIP ID \(tripId)")
                    print("CREATION DATE \(creationDate)")
                
            
                guard let distance = Double("\(self.pedoDistanceLabel.text ?? "0.00")") else { return }
                print("DEBUG: THIS IS THE DISTANCE \(distance)")
                
                guard let steps = Int("\(self.stepsLabel.text ?? "0")") else { return }
                print("DEBUG: THIS IS THE STEPS \(steps)")
                
                let duration = "\(self.timeIntervalFormat(interval: self.timeElapsed))"
                print("DEBUG: THIS IS THE DURATION \(duration)")
                
                //guard let pace = Double("\(self.paceLabel.text ?? "0.00")") else { return }
                //print("DEBUG: THIS IS THE PACE \(pace)")
                
                print("DEBUG: THIS IS THE PACE \(self.paceLabel.text ?? "0")")
                let pace = "\(self.paceLabel.text ?? "0")"
                
                print("DEBUG: THIS IS THE AVERAGE \(self.averagePaceLabel.text ?? "0")")
                let averagePace = "\(self.averagePaceLabel.text ?? "0")"
                
                DataService.instance.REF_ACTIVITY.child(currentUid).child(tripId).updateChildValues(["creationDate": creationDate, "distance": distance, "stepCount": steps, "duration": duration, "pace": pace, "averagePace": averagePace])
                
                
                // get current date
                
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd" //"dd.MM.yyyy"
                let result = formatter.string(from: date)
                print("this is the current date \(result)")
                
                // convert current date interger into date
                
                // convert Int to TimeInterval (typealias for Double)
                let timeInterval = TimeInterval(creationDate)
                // create NSDate from Double (NSTimeInterval)
                let myNSDate = Date(timeIntervalSince1970: timeInterval)
                print("this is the last date of my activity \(result)")
                
                // now lets get the difference in these days
                let numOfDays = date.daysBetweenDate(toDate: myNSDate)
                print("number of days should be equal to zero \(numOfDays)")
                
                // calling function with date and trip id
                self.calculateToDateTotal(tripDate: myNSDate, tripId: tripId)
                
            }
        
        mapView.removeOverlays(mapView.overlays)
        UpdateService.instance.resetTripId()
        
        // loading finished map of actual path
        
    }
    
    func calculateToDateTotal(tripDate: Date, tripId: String ) {
        
        // go to activities and examine the last 20 entries
        // if any of these entries match the date of the latest entry above then find values and add them
        // sum of values will be placed under the current trip
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_ACTIVITY.child(currentUid).queryLimited(toLast: 20).observeSingleEvent(of: .value, with: { (snapshot) in

            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
            for snap in snapshots {
                    
                let snapshotKey = snap.key
                print("The key value is THIS ONNNNE \(snapshotKey)")
                    
                DataService.instance.REF_ACTIVITY.child(currentUid).child(snapshotKey).child("creationDate").observeSingleEvent(of: .value) { (snapshot) in
                    
                    guard let creationDateValue = snapshot.value as? Int else { return }
 
                    // convert Int to Date
                    let timeInterval = TimeInterval(creationDateValue)
                    let myNSDate = Date(timeIntervalSince1970: timeInterval)
                    
                    // now convert the date into a string
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd" //"dd.MM.yyyy"
                    let result1 = formatter.string(from: myNSDate)
                    let result2 = formatter.string(from: tripDate)
                    
                    if result1 == result2 {
                        
                        print("These keys were created equal \(snapshotKey) result1 is \(result1) and result2 is \(result2)")
                        
                        // now i need to add the values of each snapshot key and pull the dictionary to fetch values
                        
                        Database.fetchActivity(with: snapshotKey) { (activity) in
                            
                            let distance = Double(activity.distance)
                            let steps = Int(activity.stepCount)
                            
                            self.totalDistance = self.totalDistance + distance
                            self.totalSteps = self.totalSteps + steps
                            
                            print("distance as it increments is \(distance)")
                            print("total distance as it increments is \(self.totalDistance)")
                            
                            // send totals to activity database
                            DataService.instance.REF_ACTIVITY.child(currentUid).child(tripId).child("daily-activity-total").updateChildValues(["totalDistance": self.totalDistance, "stepCount": self.totalSteps])
                            
                            
                            // send totals temp to the user database
                            DataService.instance.REF_USERS.child(currentUid).updateChildValues(["dailyDistance": self.totalDistance, "dailyStepCount": self.totalSteps, "dailyActivityDate": result2])
                        }
                    }
                }
            }
            }
            
        })
    }
     
    @objc func timerAction(timer:Timer){
        displayPedometerData()
    }

    func displayPedometerData(){
        //time Elapsed
        timeElapsed += self.timerInterval
        //timeElapsed += 1.0
        statusTitle.text = "On: " + timeIntervalFormat(interval: timeElapsed)
        
        //Number of steps
        if let numberOfSteps = self.numberOfSteps {
            //stepsLabel.text = String(format:"Steps: %i", numberOfSteps)
            stepsLabel.text = String(format:"%i", numberOfSteps)
        } else {
            stepsLabel.text = "0"
        }
        
        // distance
        
        if let distance = self.distance {
            //pedoDistanceLabel.text = String(format:"Distance: %02.02f meters,\n %02.02f mi", distance, miles(meters: distance))
            pedoDistanceLabel.text = String(format:"%02.02f", miles(meters: distance))
        } else {
            //pedoDistanceLabel.text = "Distance: N/A"
            pedoDistanceLabel.text = "0.00"
        }
         
        //average pace
        if let averagePace = self.averagePace {
            averagePaceLabel.text = paceString(title: "Avg Pace", pace: averagePace)
            //averagePaceLabel.text = paceString(pace: averagePace)
        } else {
            averagePaceLabel.text =  paceString(title: "Avg Comp Pace", pace: computedAvgPace())
            //averagePaceLabel.text =  "0.00"
        }
         
        //pace
        if let pace = self.pace {
            paceLabel.text = paceString(title: "Pace", pace: pace)
            //paceLabel.text = paceString(pace: pace)
        } else {
            paceLabel.text =  paceString(title: "Avg Comp Pace", pace: computedAvgPace())
            //paceLabel.text =  "0.00"
        }
        
    }
    
    
    @objc func handleSaveSegment() {
        
        let currentUserID = Auth.auth().currentUser?.uid
        
        guard let mapItem = selectedMapAnnotation else { return }
        saveSelectedPath(forMapItem: mapItem)

        DataService.instance.REF_USERS.child(currentUserID!).updateChildValues(["tripCoordinate": [mapItem.placemark.coordinate.latitude, mapItem.placemark.coordinate.longitude]])
        
        UpdateService.instance.updateTripsWithCoordinatesUponSelect()
        UpdateService.instance.saveTripSegment(forRunnerKey: currentUserID!)
        UpdateService.instance.updateDestinationToNewOrigin(withCoordinate: mapItem.placemark.coordinate)
        
        dismissStoreDetailView()
    }
    
    @objc func handleRemovedSaveSegment() {
        let currentUserID = Auth.auth().currentUser?.uid
        
        guard let mapItem = selectedMapAnnotation else { return }
        removeSelectedPath(forMapItem: mapItem)
        
        UpdateService.instance.cancelTripSegment(forRunnerKey: currentUserID!)
        //animateRemoveSegmentButtonOut()
        //animateSaveSegmentButtonOut()
        
    }
    
    @objc func handleSaveRemoveSegment() {
        
    //toggleSaveRemoveSegmentView.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
                   
                   UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                       
                    //self.toggleSaveRemoveSegmentView.transform = CGAffineTransform(scaleX: 1, y: 1)
                       
                   }) { (_) in
                    //self.toggleSaveRemoveSegmentView.transform = .identity
        }
        
        if saveRemovePathLabel.text == "Save Path" {
            
            
            if initialCheckpointSelected == false {
                //self.toggleSaveRemoveSegmentView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                self.startStopButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                //self.toggleSaveRemoveSegmentView.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
                    self.startStopButton.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
                
                //self.toggleSaveRemoveSegmentView.alpha = 1
                    self.startStopButton.alpha = 1
                self.initialCheckpointSelected = true
            }) { (_) in
                //self.toggleSaveRemoveSegmentView.transform = .identity
                self.startStopButton.transform = .identity
            }

            }
            
            
            print("Save segment pressed")
                   let currentUserID = Auth.auth().currentUser?.uid
            
            guard let mapItem = selectedMapAnnotation else { return }
            saveSelectedPath(forMapItem: mapItem)
            
            //storeCell.saveStorePointValue(mapItem)
            // take map item and then compare it in order to find the store id and save it to trips here...

            DataService.instance.REF_USERS.child(currentUserID!).updateChildValues(["tripCoordinate": [mapItem.placemark.coordinate.latitude, mapItem.placemark.coordinate.longitude]])
            
            UpdateService.instance.updateTripsWithCoordinatesUponSelect()
            UpdateService.instance.saveTripSegment(forRunnerKey: currentUserID!)
            UpdateService.instance.updateDestinationToNewOrigin(withCoordinate: mapItem.placemark.coordinate)
            
            //at the moment i don't want to dismiss the view on save
            //dismissStoreDetailView()
            
            // now setting to remove segment
           saveRemovePathLabel.text = "Remove Path"
            saveRemovePathLabel.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
            saveRemovePathLabel.backgroundColor = UIColor.clear
            toggleSaveRemoveSegmentView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
           //toggleSaveRemoveSegmentView.backgroundColor = stopColor
            
            saveSegmentVisible = false
            
        } else {

            let currentUserID = Auth.auth().currentUser?.uid
            
            guard let mapItem = selectedMapAnnotation else { return }
            removeSelectedPath(forMapItem: mapItem)
            
            UpdateService.instance.cancelTripSegment(forRunnerKey: currentUserID!)
            

           //toggleSaveRemoveSegmentView.backgroundColor = startColor
            
           saveRemovePathLabel.text = "Save Path"
            saveRemovePathLabel.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
             saveRemovePathLabel.backgroundColor = .clear
            toggleSaveRemoveSegmentView.backgroundColor = UIColor.walkzillaYellow()
            saveSegmentVisible = true
        }
    }
    
   func startLocationUpdates() {
        //manager?.delegate = self  // may be repetitive
    manager?.activityType = .fitness
        manager?.distanceFilter = 10
        //manager?.startUpdatingLocation()
    }
}


extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthStatus()
        if status == .authorizedAlways {
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
    
    
    // used in unison with core data in order to save the location data
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      for newLocation in locations {
        let howRecent = newLocation.timestamp.timeIntervalSinceNow
        guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }

        if let lastLocation = locationList.last {
            let delta = newLocation.distance(from: lastLocation)
          recordedDistance = recordedDistance + Measurement(value: delta, unit: UnitLength.meters)
            
            print("HERE IS THE RECORDED DISTANCE \(recordedDistance)")
        }

        locationList.append(newLocation)
        print("HERE IS THE new location \(newLocation)")
      }
    }

}

extension HomeVC: MKMapViewDelegate {
    

    
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        // don't call this function if user has already stopped updating location
        UpdateService.instance.updateUserLocation(withCoordinate: userLocation.coordinate) // Calling the Update user location function.
        
        
        
        if didSetUserOrigin == false {
            
            let placeMark = MKPlacemark(coordinate: userLocation.coordinate)
            let placeHolder = MKMapItem(placemark: placeMark)
            
            oldSource = placeHolder
            
            didSetUserOrigin = true
            
        } else {
            
            return
        }
        
    }
    // Below is from the Udemy lesson 23.
    
 
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        let imageView = UIImageView()
        let hotImageView = UIImageView()
        
       


        let annotationIdentifier = "MyCustomAnnotation"
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        

        if annotationView == nil {
            
           //imageView.frame = CGRect(x: 40, y: 9, width: 11, height: 14 ) // lightening bolt
            hotImageView.frame = CGRect(x: -2, y: -4, width: 15, height: 15)   // green dot
            
          annotationView = CKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
          if case let annotationView as CKAnnotationView = annotationView {
            annotationView.isEnabled = true
            //annotationView.canShowCallout = true
            
            
            annotationView.label = UILabel(frame: CGRect(x: 7, y: 7.5, width: 34.0, height: 18.0))
        
            if let label = annotationView.label {
                label.font = UIFont(name: "Avenir-Black", size: 13)
                label.textAlignment = .center
                label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
                label.adjustsFontSizeToFitWidth = true
                annotationView.addSubview(label)
                
            }
 
          }
        }

        if case let annotationView as CKAnnotationView = annotationView {
          annotationView.annotation = annotation
        
            let pinImage = UIImage(named: "roundedRecMarker")
            

            let size = CGSize(width: 62, height: 32)
            //UIGraphicsBeginImageContext(size)
            UIGraphicsBeginImageContextWithOptions(size, false, 10)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            // when zooming in and out some annotations will disappear accordingly
            //annotationView.displayPriority = .defaultHigh

            annotationView.image = resizedImage
            

            if let subtitle = annotation.subtitle,
                let label = annotationView.label {

            //label.text = title
 
            //label.text = "+\(subtitle ?? "?")"
            label.text = "\(subtitle ?? "?")"  // using question mark for optional value
                
            let pointVal = Int(subtitle ?? "?")
            //guard let pointVal = Int(subtitle) else { return }
            print("These are the point values \(pointVal)")
                
        // if the value is less than 300 points show the low bar
        //if the value is between 300 and 700 show the middle bar
        // if the value is above 700 give them a hot bar fire symbol
                
                /*
                if pointVal! >= 200 && pointVal! <= 299 {
                    
                }
                */
                
                // types of annotations marker
                // virtual check in
                // favorites
                // hot deal
                
                

                //imageView.image = UIImage(named: "like_selected-red")
                //roundedRecMarkerHeartUnselected
                
                switch pointVal! {
                case 1 ... 249:
                    print("low range")
                    let pinImage = UIImage(named: "roundedRecMarkerHeart")
                    let size = CGSize(width: 62, height: 32)
                    UIGraphicsBeginImageContextWithOptions(size, false, 10)
                    pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    annotationView.image = resizedImage
                    
                    // when zooming in and out some annotations will disappear accordingly
                    //annotationView.displayPriority = .defaultHigh

                    
                    
                case 250 ... 499:
                    print("mid range")
                    //hotImageView.image = UIImage(named: "greenDot")
                            let pinImage = UIImage(named: "roundedRecMarkerHeart")
                            let size = CGSize(width: 62, height: 32)
                            UIGraphicsBeginImageContextWithOptions(size, false, 10)
                            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                    
                            annotationView.image = resizedImage
                    
                    
                case 500 ... 749:
                    print("high mid range, hot deal")
            
                    
                    let pinImage = UIImage(named: "roundedRecMarkerShort")
                    let size = CGSize(width: 55, height: 30)
                    UIGraphicsBeginImageContextWithOptions(size, false, 10)
                    pinImage!.draw(in: CGRect(x: -7, y: 0, width: size.width, height: size.height))
                    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
            
                    annotationView.image = resizedImage
                    
                    annotationView.label = UILabel(frame: CGRect(x: 13, y: 7.5, width: 34.0, height: 18.0))
                    
    
                case 750 ... 1000:
                    print("high range, hot deal")
                    
                    
                                    let pinImage = UIImage(named: "roundedRecMarkerShort")
                                    let size = CGSize(width: 55, height: 30)
                                    UIGraphicsBeginImageContextWithOptions(size, false, 10)
                                    pinImage!.draw(in: CGRect(x: -7, y: 0, width: size.width, height: size.height))
                                    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                                    UIGraphicsEndImageContext()
                            
                                    annotationView.image = resizedImage
                    annotationView.label = UILabel(frame: CGRect(x: 13, y: 7.5, width: 34.0, height: 18.0))
                    hotImageView.image = UIImage(named: "greenDot")
                
                    
                default:
                    print("Integer value not within range")
                    
                }
  
            }
            
            /*
            if let title = annotation.title,
                           let storeLabel = annotationView.label {
                           
                           storeLabel.text = title
                           
            }
                */
           
            
        }
        
        var storeLabel = UILabel(frame: CGRect(x: -16, y: 55, width: 80, height: 20))

            storeLabel.font = UIFont(name: "HelveticaNeue", size: 10.0)
            storeLabel.textAlignment = .center
            storeLabel.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            storeLabel.text = annotation.title as? String
        
        //annotationView?.addSubview(storeLabel)
        /*
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 11, y: 25, width: 23, height: 8)
        //imageView.image = UIImage(named: "like_selected-red")
        
        imageView.image = UIImage(named: "seventyFivePercentBar")
 
 */
        
        //imageView.image = UIImage(named:"seventyFivePercentBar")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        //imageView.tintColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        annotationView?.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.20).cgColor
        annotationView?.layer.shadowOpacity = 95 // Shadow is 30 percent opaque.
        annotationView?.layer.shadowRadius = 6.0
        annotationView?.layer.shadowOffset = CGSize(width: 0, height: 3)
      
        annotationView?.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.3, options: .curveEaseInOut, animations: {
                annotationView?.alpha = 1
            annotationView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

            }) { (_) in
                annotationView?.transform = .identity
            }
     
        //annotationView?.addSubview(imageView)
        annotationView?.addSubview(hotImageView)
  
        return annotationView
        
    }
   
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
       
        
        if isStoreDetailViewVisible == true {
            // don't anitmate center map button in
            print("DEBUG: Store detail view set to true")
        } else {
            
            //centerMapBackground.fadeTo(alphaValue: 1, withDuration: 0.25)
            
   
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.50, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                self.centerMapBackground.transform = CGAffineTransform(scaleX: 1, y: 1)

                self.centerMapBackground.alpha = 1
                
            })
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        // if start trip has not been pressed render this line else render the other line
        if startTripPressed == false {
            
            
            print("WE GET HERE START is FALSE SO THE NORMAL LINE RENDERS")
        let lineRenderer = MKPolylineRenderer(overlay: self.route.polyline)

        //lineRenderer.strokeColor = UIColor(red: 26/255, green: 172/255, blue: 239/255, alpha: 1) // true blue
        lineRenderer.strokeColor = UIColor.rgb(red: 0, green: 0, blue: 0)
       //lineRenderer.strokeColor = UIColor.walkzillaRed()
        
            lineRenderer.lineWidth = 4.5
        lineRenderer.lineCap = .round
        lineRenderer.lineJoin = .bevel
        //lineRenderer.lineJoin = .miter
        //lineRenderer.fillColor = UIColor(red: 160/255, green: 170/255, blue: 250/255, alpha: 1)
        lineRenderer.lineDashPattern = [NSNumber(value: 0.1), NSNumber(value: 8)]
        
        
        return lineRenderer

        
    } else {
            
            
     print("WE GET HEEEEERE START TRIP set to TRUE  SO THE NORMAL LINE RENDERS")
            
            mapView.removeOverlays(mapView.overlays)
            
            
            guard let polyline = overlay as? MulticolorPolyline else {
              return MKOverlayRenderer(overlay: overlay)
            }
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = polyline.color
            renderer.lineWidth = 8

            return renderer
            
            
          /*
          guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
          }
          let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.airBnBNew()
          renderer.lineWidth = 8
            
            self.startTripPressed = false // may move this after the load map function
          return renderer
            */
        }
        
        
        
        
 
        /*
        let overlay = overlay as? MKPolyline
                // define a list of colors you want in your gradient
        //let gradientColors = [UIColor.rgb(red: 0, green: 0, blue: 255), UIColor.rgb(red: 236, green: 38, blue: 125), UIColor.rgb(red: 253, green: 145, blue: 20), UIColor.rgb(red: 253, green: 190, blue: 60)]
        
        //let gradientColors = [UIColor.rgb(red: 242, green: 137, blue: 140), UIColor.airBnBRed(), UIColor.airBnBDeepRed()]
        let gradientColors = [UIColor.rgb(red: 242, green: 116, blue: 118), UIColor.airBnBDeepRed()]
        
        //UIColor.rgb(red: 122, green: 206, blue: 33)
        
                // Initialise a GradientPathRenderer with the colors
        let polylineRenderer = GradientPathRenderer(polyline: overlay!, colors: gradientColors)

                // set a linewidth
        polylineRenderer.lineWidth = 13
        polylineRenderer.lineCap = .round
        polylineRenderer.lineJoin = .bevel
        polylineRenderer.lineDashPattern = [NSNumber(value: 0.1), NSNumber(value: 10)]
        
        polylineRenderer.showsBorder = true
        //polylineRenderer.borderColor = UIColor.rgb(red: 252, green: 132, blue: 187) /* defaults to white if not specified*/
        polylineRenderer.borderColor = .white
        return polylineRenderer
       // }
    */
    }

    func dropPinFor(mapItem: MKMapItem) {
        
        
        /*
        // Everytime we add a destination pin we must remove the previous one. We do this with the function below.
        for annotation in mapView.annotations {
            if annotation.isKind(of: MKPointAnnotation.self) {
                mapView.removeAnnotation(annotation)
            }
        }
    */
        
        
        /*
        let annotation = MKPointAnnotation()
        
        
        let annotationIdentifier = "MyCustomAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
          annotationView = CKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
          if case let annotationView as CKAnnotationView = annotationView {
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            
            
            annotationView.label = UILabel(frame: CGRect(x: 13, y: 5, width: 40.0, height: 20.0))
            if let label = annotationView.label {
              label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
              label.textAlignment = .center
                label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
              label.adjustsFontSizeToFitWidth = true
              annotationView.addSubview(label)
            }
          }
        }
    
        
        annotation.coordinate = mapItem.placemark.coordinate
        annotation.title = mapItem.name
        
        if case let annotationView as CKAnnotationView = annotationView {
          annotationView.annotation = annotation
          annotationView.image = UIImage(named: "largeGreenRectWhite")
            
            if let title = annotation.subtitle,
            let label = annotationView.label {
            label.text = title
          }
        }
        
        
        mapView.addAnnotation(annotation)
        zoomToFit(selectedAnnotation: annotation)
        */
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        annotation.title = mapItem.name
        
        //mapView.addAnnotation(annotation)
        zoomToFit(selectedAnnotation: annotation)
        
    }
    
    
    func zoomToFit(selectedAnnotation: MKAnnotation?) {
        
        
        if mapView.annotations.count == 0 {
            return
        } // Nothing past this line gets executed if this condition is met.
        
        var topLeftCoordinate = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoordinate = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        
        if let selectedAnnotation = selectedAnnotation {
            for annotation in mapView.annotations {
                
                //if let userAnno = annotation as? MKUserLocation {
                if let userAnno = oldSource?.placemark {
                    topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, userAnno.coordinate.longitude)
                    topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, userAnno.coordinate.latitude)
                    bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, userAnno.coordinate.longitude)
                    bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, userAnno.coordinate.latitude)
                }
                
                if annotation.title == selectedAnnotation.title {
                    topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, annotation.coordinate.longitude)
                    topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, annotation.coordinate.latitude)
                    bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, annotation.coordinate.longitude)
                    bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, annotation.coordinate.latitude)
                }
            }
            
            var region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(topLeftCoordinate.latitude - (topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 0.65, topLeftCoordinate.longitude + (bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 0.65), span: MKCoordinateSpan(latitudeDelta: fabs(topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 3.0, longitudeDelta: fabs(bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 3.0))
            
            region = mapView.regionThatFits(region)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func searchMapKitForResultsWithPolyline(forMapItem mapItem: MKMapItem) {
        
        //plotStoreAnnotations()
        
        let request = MKDirections.Request()
        request.source = oldSource
        request.destination = mapItem
        request.transportType = MKDirectionsTransportType.walking
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard let response = response else {
                self.showAlert(error.debugDescription)
                return
            }
            self.route = response.routes[0] // The int 0 is the first route. This will need to be changed to a route with a specific distance.
            self.mapView.addOverlay(self.route.polyline)
            self.shouldPresentLoadingView(false)
        }
    }
    
    func addUserTripPolyline(forMapItem mapItem: MKMapItem) {
        
        mapView.removeOverlays(mapView.overlays)
        
        //let currentLocation: CLLocation = (manager?.location)!
        

        // here we need to make sure we get the proper user location, doesn't work in similation but may work in real life
        guard let currentLocation = manager?.location else { return }
        
        //let currentLocation = mapView.userLocation
        let placeMark = MKPlacemark(coordinate: currentLocation.coordinate)
        let userStartLocation = MKMapItem(placemark: placeMark)
        
    print("DEBUG: THIS IS THE USER new start location \(currentLocation)")
        
        let request = MKDirections.Request()
        request.source = userStartLocation
        request.destination = mapItem
        request.transportType = MKDirectionsTransportType.walking
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard let response = response else {
                self.showAlert(error.debugDescription)
                return
            }
            self.route = response.routes[0] // The int 0 is the first route. This will need to be changed to a route with a specific distance.
            self.mapView.addOverlay(self.route.polyline)
            self.shouldPresentLoadingView(false)
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = mapItem.placemark.coordinate
            self.oldSource = userStartLocation
            
            
            let zoomRadius: CLLocationDistance = 500
            let coordinateRegion = MKCoordinateRegion.init(center: self.mapView.userLocation.coordinate, latitudinalMeters: zoomRadius, longitudinalMeters: zoomRadius)
            self.mapView.setRegion(coordinateRegion, animated: true)
           // self.zoomToFit(selectedAnnotation: annotation)
        }
    }
    
    
    func segmentColor(speed: Double, midSpeed: Double, slowestSpeed: Double, fastestSpeed: Double) -> UIColor {
      enum BaseColors {
        static let r_red: CGFloat = 1
        static let r_green: CGFloat = 20 / 255
        static let r_blue: CGFloat = 44 / 255
        
        static let y_red: CGFloat = 1
        static let y_green: CGFloat = 215 / 255
        static let y_blue: CGFloat = 0
        
        static let g_red: CGFloat = 0
        static let g_green: CGFloat = 146 / 255
        static let g_blue: CGFloat = 78 / 255
      }
      
      let red, green, blue: CGFloat
      
      if speed < midSpeed {
        let ratio = CGFloat((speed - slowestSpeed) / (midSpeed - slowestSpeed))
        red = BaseColors.r_red + ratio * (BaseColors.y_red - BaseColors.r_red)
        green = BaseColors.r_green + ratio * (BaseColors.y_green - BaseColors.r_green)
        blue = BaseColors.r_blue + ratio * (BaseColors.y_blue - BaseColors.r_blue)
      } else {
        let ratio = CGFloat((speed - midSpeed) / (fastestSpeed - midSpeed))
        red = BaseColors.y_red + ratio * (BaseColors.g_red - BaseColors.y_red)
        green = BaseColors.y_green + ratio * (BaseColors.g_green - BaseColors.y_green)
        blue = BaseColors.y_blue + ratio * (BaseColors.g_blue - BaseColors.y_blue)
      }
      
      return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        mapView.removeOverlays(mapView.overlays)
        
        
        
        /*
        if initialCheckpointSelected == false {
            //self.toggleSaveRemoveSegmentView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            self.startStopButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            //self.toggleSaveRemoveSegmentView.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
                self.startStopButton.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
            
            //self.toggleSaveRemoveSegmentView.alpha = 1
                self.startStopButton.alpha = 1
            self.initialCheckpointSelected = true
        }) { (_) in
            //self.toggleSaveRemoveSegmentView.transform = .identity
            self.startStopButton.transform = .identity
        }

        }
        */
        
        
        
        
        
        // when selecting another annotation i need for the startstop button is pressed
        if saveSegmentVisible == false {
            
            // toggle back to saved segment
            //toggleSaveRemoveSegmentView.backgroundColor = startColor
            
            saveRemovePathLabel.text = "Save Path"
            saveRemovePathLabel.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
             saveRemovePathLabel.backgroundColor = .clear
        }
        
        //centerMapButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        //centerMapBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
        userActivityButtonBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
        notificationBoltBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            //self.centerMapButton.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            //self.centerMapBackground.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            self.userActivityButtonBackground.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            self.notificationBoltBackground.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            
            //self.centerMapBackground.alpha = 0
            //self.centerMapButton.alpha = 0
            self.userActivityButtonBackground.alpha = 0
            self.notificationBoltBackground.alpha = 0
            
            //self.centerMapBackground.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0).cgColor
            //self.centerMapButton.isHidden = true
            
            
        }) { (_) in
            //self.centerMapButton.transform = .identity
            //self.centerMapBackground.transform = .identity
            self.userActivityButtonBackground.transform = .identity
            self.notificationBoltBackground.transform = .identity
        }

        
        
        
        
        //searchTableView.isHidden = true
        //isSearchTableViewVisible = false
        
        /*
        UIView.animate(withDuration: 0.3, animations: {
            //self.viewSearchBarButton.alpha = 1
            //self.backgroundConfigureSearchBar.alpha = 0.80
            
        })
        */
        
        if view.annotation is MKUserLocation {
            return
        }
        
        selectedAnnotation = view.annotation as? MKPointAnnotation
        zoomToFit(selectedAnnotation: selectedAnnotation)
        
        /*
        let pinImage = UIImage(named: "simpleMarkerTrueBlue")
        let size = CGSize(width: 48, height: 55)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        view.image = resizedImage
        */
        
        /*
        let selectedAnnotation = view.annotation
        for annotation in mapView.annotations {
            if let annotation = annotation as? MKAnnotation where !annotation.isEqual(selectedAnnotation) {
                // do some actions on non-selected annotations in 'annotation' var
            }
        */
        
        // need to work on this function
        
        for annotation in mapView.annotations {
            if let annotation = annotation as? MKPointAnnotation,
                !annotation.isEqual(selectedAnnotation) {
            // do some actions on non-selected annotations in 'annotation' var
                
                //view.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                mapView.deselectAnnotation(annotation, animated: true)
                
            } else {
                print("THIS ISSSS THE SAME ANNOTATION")
            }
        }
        
        /*
         // enlarges annotation, but I would rather change the color of the icon instead
        view.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            view.alpha = 1
            view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)

        }) { (_) in
           // annotationView?.transform = .identity
        }
        */
        
        guard let selectedAnnotationCoordinate = selectedAnnotation?.coordinate else { return }
        let selectedDestination = MKPlacemark(coordinate: selectedAnnotationCoordinate)
        let selectedMapItem = MKMapItem(placemark: selectedDestination)
        
        //print(selectedMapItem.placemark.coordinate)
        selectedMapItem.name = selectedAnnotation!.title
        
        if isStoreDetailViewVisible == false {

            configureStoreViewComponents()
            
            //storeDetailView.isHidden = false
            
           storeDetailView.presentIntialStoreView()
            
        
        } else {
            
         let recallStoreDetail = StoreCell()
            recallStoreDetail.configureCell()
            tableView.reloadData()
         }
        
        let selectedMapItemArray = [selectedMapItem]

        storeDetailView?.selectedAnnotationResults = selectedMapItemArray
        storeDetailView.homeVC = self
        
        searchMapKitForResultsWithPolyline(forMapItem: selectedMapItem)
        selectedMapAnnotation = selectedMapItem

    // --> animateSaveSegmentButtonIn()

        /*
        if secondSegmentSelected == true {
            animateRemoveSegmentButtonIn()
        }
         */
        
        secondSegmentSelected = true
        
        
    }
    
    func plotSearchTableSelection(_forMapItem mapItem: MKMapItem) {
        
        //MKAnnotationView
           
           mapView.removeOverlays(mapView.overlays)
        
               
        //guard let selectedAnnotationCoordinate = selectedAnnotation.coordinate else { return }
        
        /*
        // here we need to find the selected annotation coordinate..
        
        
               let selectedDestination = MKPlacemark(coordinate: selectedAnnotationCoordinate)
               let selectedMapItem = MKMapItem(placemark: selectedDestination)
               
        */
        let selectedMapItem = mapItem
        // if we have the selected annotation map item it goes here
        
        //selectedMapItem.name = selectedAnnotation.title
                

               if isStoreDetailViewVisible == false {

                   configureStoreViewComponents()
                   
                   //storeDetailView.isHidden = false
                   //storeDetailView.presentIntialStoreView()
                   
               } else {
                   
                let recallStoreDetail = StoreCell()
                   recallStoreDetail.configureCell()
                   tableView.reloadData()
                }
               
               let selectedMapItemArray = [selectedMapItem]

               storeDetailView?.selectedAnnotationResults = selectedMapItemArray
               storeDetailView.homeVC = self
               
               searchMapKitForResultsWithPolyline(forMapItem: selectedMapItem)
               selectedMapAnnotation = selectedMapItem

           // --> animateSaveSegmentButtonIn()

               /*
               if secondSegmentSelected == true {
                   animateRemoveSegmentButtonIn()
               }
                */
               
               secondSegmentSelected = true
       }
    
    
    /*
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        selectedAnnotation = view.annotation as? MKPointAnnotation
        // We can use this function to change the size and section color of the annotation.
    }
    */
    
    // MARK: - Helper Functions
    
    
    func configureStoreViewComponents() {
        
    mapView.addSubview(self.storeDetailBV)
    
        
    //if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
        
        //if let window:UIWindow = applicationDelegate.window {
            
            isSearchTableViewVisible = true
            
            //let tabBarHeight = CGFloat((tabBarController?.tabBar.frame.size.height)!)
            
            storeDetailView = StoreDetailView()
            storeDetailView?.homeVC = self
            storeDetailView.layer.cornerRadius = 3
            storeDetailView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
            storeDetailView.layer.shadowColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 0.15).cgColor
            storeDetailView.layer.shadowOpacity = 95 // Shadow is 30 percent opaque.
            storeDetailView.layer.shadowRadius = 5.0
            storeDetailView.layer.shadowOffset = CGSize(width: 1, height: -1)
            

            //window.addSubview(storeDetailView)
        view.addSubview(storeDetailView)
        
           // storeDetailView.anchor(top: nil, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -((window.frame.height) - 270), paddingRight: 0, width: 0, height: window.frame.height + 20)
            
            //storeDetailView.anchor(top: nil, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -((window.frame.height) - 165), paddingRight: 0, width: 0, height: window.frame.height + 20)
            
            storeDetailView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 150)
            
            storeDetailView.addSubview(toggleSaveRemoveSegmentView)
        toggleSaveRemoveSegmentView.anchor(top: nil, left: storeDetailView.leftAnchor, bottom: storeDetailView.bottomAnchor, right: storeDetailView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
            toggleSaveRemoveSegmentView.centerXAnchor.constraint(equalTo: self.storeDetailView.centerXAnchor).isActive = true
            toggleSaveRemoveSegmentView.layer.cornerRadius = 3
            
            toggleSaveRemoveSegmentView.addSubview(saveRemovePathLabel)
            saveRemovePathLabel.anchor(top: toggleSaveRemoveSegmentView.topAnchor, left: toggleSaveRemoveSegmentView.leftAnchor, bottom: toggleSaveRemoveSegmentView.bottomAnchor, right: toggleSaveRemoveSegmentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            saveRemovePathLabel.centerXAnchor.constraint(equalTo: self.toggleSaveRemoveSegmentView.centerXAnchor).isActive = true
            saveRemovePathLabel.centerYAnchor.constraint(equalTo: self.toggleSaveRemoveSegmentView.centerYAnchor).isActive = true
            
            
      //  }
   // }
 
            
        isStoreDetailViewVisible = true
        
        dismissOnSearch()
    }
    
    /*
    func resetStoreDetailViewToOrigin() {
        if isStoreViewAtOrigin == false {
            
            //reset store back to origin
            storeDetailView.restoreStoreDetailView()
            isStoreViewAtOrigin = true
            print("Store view origin is set to true")
            
        }
    }
    */
    
    func storeViewSetToDismissed() {

        //this function will be called to dismiss store detail view.
        
        //isStoreViewAtOrigin = false
        isStoreDetailViewVisible = false
        
        //searchTableView.isHidden = false
    
        print("Store view origin is set to false")
        print("Store detail view visable set to false")
        
        //centerMapButton.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        //centerMapBackground.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        userActivityButtonBackground.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        notificationBoltBackground.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            //self.centerMapButton.isHidden = false
            //self.centerMapButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            //self.centerMapBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.userActivityButtonBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.notificationBoltBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            // self.centerMapButton.alpha = 1
            //self.centerMapBackground.alpha = 1
            self.userActivityButtonBackground.alpha = 1
            self.notificationBoltBackground.alpha = 1
            //self.centerMapBackground.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
            
            
            
        }) { (_) in
            //self.centerMapButton.transform = .identity
            //self.centerMapBackground.transform = .identity
            self.userActivityButtonBackground.transform = .identity
            self.notificationBoltBackground.transform = .identity
        }
    }
 
    
    func reanimateCancelTripButton() {

        cancelTripBackground.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
         
         UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
             
             self.cancelTripBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
             self.cancelTripBackground.alpha = 1

         }) { (_) in

             self.cancelTripBackground.transform = .identity
         }
    }
    
    func dismissStoreDetailView() {
        
        storeDetailView.dismissDetailView()
        
        /*
        UIView.animate(withDuration: 0.5) {
      
            self.storeDetailView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.storeDetailView.frame.height)
        }
         */
            //storeDetailView.removeFromSuperview()
        
        
        //removeStartTripButton()
        
        //removeCancelTripButton()
        
        //isStoreDetailViewVisible = false
    }
    
    
    @objc func handleProfileView() {
        
        /*
        if Auth.auth().currentUser != nil {
                
                guard let currentUid = Auth.auth().currentUser?.uid else { return }
                
                print("DEBUG: The current user id is \(currentUid)")
                DataService.instance.REF_USERS.child(currentUid).child("isStoreadmin").observe(.value) { (snapshot) in
                    let isStoreadmin = snapshot.value as! Bool
                    
                    print(snapshot.value as! Bool)
                    
                    if isStoreadmin == true {    // this is the profile screen for users
                        
                            print("DEBUG: we get to the admin  profile")
                            //let userProfileVC = UserProfileVC()
                        let adminProfileVC = AdminProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
                        self.navigationController?.pushViewController(adminProfileVC, animated: true)
                        
                        
                    } else {
                        
                        print("DEBUG: we get to the user profile")
                        //let userProfileVC = UserProfileVC()
                        let profileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
                        self.navigationController?.pushViewController(profileVC, animated: true)
                        
        
                    }
                }
            }
        
        */
        
        print("DEBUG: we get to the user profile")
        let profileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    /*
    func animateSaveSegmentButtonIn() {
        saveSegmentButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.saveSegmentButton.alpha = 1
            self.saveSegmentButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
        }) { (_) in
            self.saveSegmentButton.transform = .identity
        }
    }
    
    func animateRemoveSegmentButtonIn() {
        removeSegmentButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.removeSegmentButton.alpha = 1
            self.removeSegmentButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (_) in
            self.removeSegmentButton.transform = .identity
        }
    }
    
    func animateSaveSegmentButtonOut () {
        saveSegmentButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.saveSegmentButton.alpha = 0
            self.saveSegmentButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (_) in
            self.saveSegmentButton.transform = .identity
        }
    }
    
    func animateRemoveSegmentButtonOut () {
        removeSegmentButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.removeSegmentButton.alpha = 0
            self.removeSegmentButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (_) in
            self.removeSegmentButton.transform = .identity
        }
    }
    */
    
    func getTripKey () {
        
        let runnerKey = (Auth.auth().currentUser?.uid)!
        
        //print( "I is equal to \(i)")
        
        // go down into the trips database, find the user, then find the most recently added trip (last 1), then look at the destination children added starting from the first going down sequentially with i.
        DataService.instance.REF_TRIPS.child(runnerKey).queryLimited(toLast: 1).observe(.childAdded) {(snapshot: DataSnapshot) in
            // this is the key for all of the child snapshots which in this case is the trip ID
            let tripId = snapshot.key
            
            // when we find the trip id that we want go under this trip specifically and grab the destination
            DataService.instance.REF_TRIPS.child(runnerKey).child(tripId).queryLimited(toFirst: UInt(self.i)).observe(.childAdded) {(snapshot: DataSnapshot) in
            
            key = snapshot.key
            print("Print path id as they are saved \(key)")

            //self.saveInitCoordinates(key)
                
            self.saveInitCoordinates(tripId)
                
                // preserve points for the trip id
                //self.preservePointValue(tripId)
                    
     
            self.keyHolder = key

            self.tripHolder = tripId
                
                
            }
        }
    
    }
    
    func updateMonitoredDestination(_ incrementedVal: Int) {
        
        let currentKey = (Auth.auth().currentUser?.uid)!
        
           DataService.instance.REF_TRIPS.child(currentKey).queryLimited(toLast: 1).observe(.childAdded) {(snapshot: DataSnapshot) in
               // this is the key for all of the child snapshots which in this case is the trip ID
               let tripId = snapshot.key
               
               // when we find the trip id that we want go under this trip specifically and grab the destination
            DataService.instance.REF_TRIPS.child(currentKey).child(tripId).queryLimited(toFirst: UInt(incrementedVal)).observe(.childAdded) {(snapshot: DataSnapshot) in
               
               let destinationKey = snapshot.key
               print("Print path id as they are saved \(key)")

                
                // updating the region that is to be monitored the plot new source and destination
                    DataService.instance.REF_TRIPS.child(currentKey).child(tripId).child(destinationKey).child("destinationCoordinate").observe(.value) { (snapshot) in
                        
                        let destinCoordinatesArray = snapshot.value as! NSArray
                        let latitude = destinCoordinatesArray[0] as! Double
                        let longitude = destinCoordinatesArray[1] as! Double
                        
                        let newCoordinateValue = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        
                        print("THIS IS THE SNAPSHOT OF OUR NEXT DESTINATION \(newCoordinateValue)")
                        
                        //updateDestinationCoordMonitor(newCoordinateValue)
                        self.monitorRegionLocation(center: newCoordinateValue, identifier: "newPlaceholder")
                        
                        let destinCoord = newCoordinateValue
                        let placemark = MKPlacemark(coordinate: destinCoord)
                        let mapItem = MKMapItem(placemark: placemark)
                        self.addUserTripPolyline(forMapItem: mapItem)
                    }
                   
               }
           }
   
    }
    
    func preservePointValue(_ tripId: String) {
        let currentUid = (Auth.auth().currentUser?.uid)!
        // the keyy value increments as the trip region is reached maybe as we save path a new function is called
            // saving destination coordnate and point value to trip id
            let destinCoord = self.destinCoordinate
            let placemark = MKPlacemark(coordinate: destinCoord)
            let mapItem = MKMapItem(placemark: placemark)
            
            var val = 1
               // when we find the trip id that we want go under this trip specifically and grab the destination
               DataService.instance.REF_TRIPS.child(currentUid).child(tripId).queryLimited(toFirst: UInt(val)).observe(.childAdded) {(snapshot: DataSnapshot) in
                
                let destId = snapshot.key
                
                // i am attempting to send the coordinates, trip key and destination id
                //self.storeCell.saveStorePointValue(mapItem, tripId: tripId, destId: destId)
                
                val += 1
                       print("LETS PRINT THE VALUE \(val)")

               }

    }
   
    // may not need the below function
    
    /*
    func configureInitTripData(_ tripId: String) {
        
        guard let currentUid = (Auth.auth().currentUser?.uid) else { return }
        
        DataService.instance.REF_TRIPS.child(currentUid).child(tripId).updateChildValues(["creationDate": creationDate, "points": 0, "stepCount": 0, "averagePace": 0, "distance": 0])
    }
    */
    
    func saveInitCoordinates (_ value: String) {
       
        let runnerKey = (Auth.auth().currentUser?.uid)!
        print(key)
        
        DataService.instance.REF_TRIPS.child(runnerKey).child(value).child(key).child("destinationCoordinate").observeSingleEvent(of: .value, with: { (snapshot) in
            let destinCoordinatesArray = snapshot.value as! NSArray
            let lat2 = destinCoordinatesArray[0] as! Double
            let long2 = destinCoordinatesArray[1] as! Double
            
            self.destinCoordinate = CLLocationCoordinate2D(latitude: lat2, longitude: long2)
            
            print("Initial Coordinates Saved.. the value is \(value) and the key is \(key)")
            
 
            
        })
        
        //saveActivityMetrics(value)
    }
    /*
    func saveActivityMetrics(_ value: String) {
        
        guard let currentUid = (Auth.auth().currentUser?.uid) else { return }
        //let creationDate = Int(NSDate().timeIntervalSince1970)
        
        // activity database will contain the TRIP ID in order to reference accordingly
        
        DataService.instance.REF_ACTIVITY.child(currentUid).child(value).updateChildValues(["creationDate": 0, "points": 0, "stepCount": 0, "duration": 0, "averagePace": 0, "distance": 0])
        
    }
    */
    func navigateRunner() {
        
        print(self.destinCoordinate)
        
        let destinCoord = self.destinCoordinate
        let placemark = MKPlacemark(coordinate: destinCoord)
        let mapItem = MKMapItem(placemark: placemark)
        
        let zoomRadius: CLLocationDistance = 1850
        let coordinateRegion = MKCoordinateRegion.init(center: mapView.userLocation.coordinate, latitudinalMeters: zoomRadius, longitudinalMeters: zoomRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        /*
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        zoomToFit(selectedAnnotation: annotation)
        */
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            // here is when we set the destination to be monitored
            self.monitorRegionLocation(center: destinCoord, identifier: "placeholder")
            
            print("THIS IS THE NEW DESTINATION COORDINATE \(destinCoord)")
            self.addUserTripPolyline(forMapItem: mapItem)
         }
        

        
        
        /*let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        
        let placemark = MKPlacemark(coordinate: destinCoord)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.openInMaps(launchOptions: launchOptions) */
    }
    
    
    
    // LET"S START HERE!!!!
    
    
   // @objc func imageWasSaved(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer) {
    func imageWasSaved(_ image: UIImage) {
        /*
        if let error = error {
            print(error.localizedDescription)
            return
        }
        */
        //let checkInCreationDate = Int(NSDate().timeIntervalSince1970)
        
        // print("Image was saved in the photo gallery")
        // UIApplication.shared.open(URL(string:"photos-redirect://")!)
        
        
        // START HERE AND WORK BACK
        
         
        let postImg = image
             guard
                 //let caption = captionTextView.text,
                 //let postImg = photoImageView.image,
               
                 let currentUid = Auth.auth().currentUser?.uid else { return }
             
             
        
             // Get image upload data.
             //guard let uploadData = postImg.jpegData(compressionQuality: 0.3) else { return }
        guard let uploadData = postImg.jpegData(compressionQuality: 0.75) else { return }
             
             // Update storage
             let filename = NSUUID().uuidString
            // let creationDate = Int(NSDate().timeIntervalSince1970)
             
        
        print("DEBUG: We are checking the value to this point\(filename)")
        
       
             // creating a new folder for admin_store_images
        let storageRef = DataService.instance.REF_STORAGE_SCREENSHOT_IMAGES.child(filename)
             
             storageRef.putData(uploadData, metadata: nil) {(metadata, error) in
                 
                 if let error = error {
                     print("Failed to upload image to storage with error", error.localizedDescription)
                     return
                 }
                 
                 // Image URL.
                 
                 storageRef.downloadURL(completion: { (url, error) in
                     if error != nil {
                         print("Failed to download url:", error!)
                         return
                     } else {
                         let postImageUrl = (url?.absoluteString)!
                         print(postImageUrl)
                         
                         let values = ["imageUrl": postImageUrl] as [String: Any]
                         
         
                         // place value or image under the activity database
                        DataService.instance.REF_ACTIVITY.child(currentUid).child(self.tripHolder).updateChildValues(values)
                        
                        if self.checkpointReached == true {
                        self.createCheckInPost(postImageUrl)
                        }

                     }
                 })
             }
    }
    
    func createCheckInPost(_ imageUrl: String) {
        // here is well we build the checkin and place it in the post feed.
        
        // use tripholder, send image to create the actual post then place in post feed .. use current upload post
        // Parameters  send image url
               guard let currentUid = Auth.auth().currentUser?.uid else { return }

               let creationDate = Int(NSDate().timeIntervalSince1970)

    
            let postImageUrl = imageUrl
                           
            let values = [//"caption": caption,
                                        "tripId": tripHolder,
                                        "logoId": childByAutoKey as Any,
                                         "creationDate": creationDate,
                                         "likes": 0,
                                         "imageUrl": postImageUrl,
                                         "type": "checkIn",
                                         "ownerUid": currentUid] as [String: Any]
                           
                           // Post id.
                           let postId = DataService.instance.REF_POSTS.childByAutoId()
                           let userPostId = DataService.instance.REF_USER_CHECKIN_POSTS  // update checkin post to data base
                           // Upload information to database.
                           
                           postId.updateChildValues(values, withCompletionBlock: { (err, ref) in
                               
                            
                            // very slick way to get the post key MUST USE!!!
                            
                            
                               guard let postKey = postId.key else { return }
                               // update user post section.
                               userPostId.child(currentUid).updateChildValues([postKey: 1])
                               
                               // update user feed structure
                               self.updateUserFeeds(with: postKey)
                               
                            self.retrieveStoreLogos(self.childByAutoKey, uid: currentUid, tripId: self.tripHolder, postId: postKey)
                               /*
                               // upload store hashtags to server
                               self.uploadHastagToServer(withPostId: postKey)
                               
                             
                               // upload store mentions notification to server
                               if caption.contains("@") {
                                   self.uploadMentionNotification(forPostId: postKey, withText: caption, isForComment: false)
                               }
                                */
                               
                               // auto dismiss and return to home category food feed.
                               self.dismiss(animated: true, completion: {
                                   self.tabBarController?.selectedIndex = 1
                                   
                               })
                           })
        
    }
    
    
    
    
    
    
    
    // TWO MAJOR KEY FEATURES THAT WILL REDUCE MY CODE, ABOVE SAVING THE KEY VALUE. AND THE GRABBING AND SAVING AN ENTIRE ARRAY!!!

    
    
    
    
    
    func retrieveStoreLogos(_ logoId: String, uid: String, tripId: String, postId: String) {
        
        //DataService.instance.REF_POSTS.child(postId).updateChildValues(["postId": postId])
        
        // we need to grab the store logos using the logo id, user id, trip id and activity feed.. grab the entire array and place
        //it under your checkin
        
        print("the logo id for retrieving store images is \(logoId) trip id is \(tripId) and postId is \(postId)")

        DataService.instance.REF_ACTIVITY.child(uid).child(tripId).child(logoId).observeSingleEvent(of: .value) { (snapshot) in
            
            let snap = snapshot.value //as! [String: Dictionary<String, Any>]
            
            
            // saving the entire array to the post feed for checkIn
            DataService.instance.REF_POSTS.child(postId).updateChildValues(["postId": postId, "logoImages" :snap])
            
        }
        
        //then we need to make sure that we read the cell data rather than attempting to retrieve new everytime
        
    }
    
    // MARK: - Handlers
    
    func updateUserFeeds(with postId: String) {
        
        // current user id
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // database values
        let values = [postId: 1]
        
        // update our follower feeds
        DataService.instance.REF_FOLLOWER.child(currentUid).observe(.childAdded) { (snapshot) in
            
            let followerUid = snapshot.key
            DataService.instance.REF_FEED.child(followerUid).updateChildValues(values)
        }
        
        // update current user feed.
        DataService.instance.REF_FEED.child(currentUid).updateChildValues(values)
        
    }
    
    /*
    func uploadHastagToServer(withPostId postId: String) {
        
        guard let caption = captionTextView.text else { return }
        
        // loop though all captions and search for words with a hashtag in front of them
        let words: [String] = caption.components(separatedBy: .whitespacesAndNewlines)
        
        for var word in words {
            
            if word.hasPrefix("#") {
                // below lines to confirm that we aren't getting any spaces or odd characters
                word = word.trimmingCharacters(in: .punctuationCharacters)
                word = word.trimmingCharacters(in: .symbols)
                
                let hashtagValues = [postId : 1]
                
                DataService.instance.REF_HASHTAG_POST.child(word.lowercased()).updateChildValues(hashtagValues)
            }
        }
    }
    */
    
    func takeScreenshot(of view: UIView) {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: view.bounds.width, height: view.bounds.height),
            false,
            2
        )

        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    

       //UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(imageWasSaved), nil)
        imageWasSaved(screenshot)
        
    }
    
    func snapshotMapview() {
        
        // maybe add a delay here then take screen shot
        takeScreenshot(of: mapView)
    }

    
    func monitorRegionLocation(center: CLLocationCoordinate2D, identifier: String) {
    
        if CLLocationManager.authorizationStatus() == .authorizedAlways  {
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                //this sets the monitoring region with a radius of 25 meters
                let region = CLCircularRegion(center: center, radius: 25, identifier: identifier)
                region.notifyOnEntry = true
                region.notifyOnExit = true
                
                manager?.startMonitoring(for: region)
            
            }
        }
    }
    
    func updateCompletedPath(_ storeIdentifier: String, keyHolder: String) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
              DataService.instance.REF_STORES.observeSingleEvent(of: .value) { (snapshot) in
                  
                  guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                  
                  allObjects.forEach({ (snapshot) in
                    if storeIdentifier == snapshot.key {
                      
                        Database.fetchStore(with: storeIdentifier, completion: { (store) in
                          
                            guard let storePoints = store.points else { return }
                            guard let storeName = store.title else { return }
                            guard let storeImage = store.imageUrl else { return }
                            
                            print("DEBUG: THE STORE Points SHOULD BE \(storePoints)")
                            
                            // just need to note here if the segment was completed.. then we can only re-plot the segment that is complete and add the point values to the rewards as such.
                                       DataService.instance.REF_TRIPS.child(currentUid).child(self.tripHolder).child(keyHolder).updateChildValues(["segmentCompleted": true])
                          
                            self.calculateSaveRewards(storeIdentifier, pointsAdded: storePoints, name: storeName, image: storeImage)
                    })
                }
            })
        }
        
    
    }
    
    func calculateSaveRewards(_ storeIdentifier: String, pointsAdded: Int, name: String, image: String) {
        
        // initially creating the rewards database with an imaginary user. may be able to erase this has been initially created
        // DataService.instance.REF_USER_REWARDS.child("ReusableReference01").updateChildValues(["rewardsGenerated": 1])
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
            
            DataService.instance.REF_USER_REWARDS.observeSingleEvent(of: .value) { (snapshot) in
                
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let uid = snapshot.key
                    
                    if currentUid == uid {
                        print("DEBUG: USER HAS BEEN FOUND IN THE REWARDS SECTION")
                        
                        DataService.instance.REF_USER_REWARDS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
                            
                            guard let allStoreObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                            
                            allStoreObjects.forEach { (snapshot) in
                                let storeId = snapshot.key
                                
                                if storeIdentifier == storeId {
                                    
                                    print("DEBUG: STORE HAS BEEN FOUND WITH THIS ID SO WE WILL UPDATE IT")
                                    
                                    DataService.instance.REF_USER_REWARDS.child(uid).child(storeId).child("points").observeSingleEvent(of: .value) { (snapshot) in
                                        
                                            let currentPointVal = snapshot.value
                                            
                                            print("DEBUG: THIS IS THE VALUE OF THE SNAPSHOT \(currentPointVal)")
                                            
                                            let totalPoints = (currentPointVal as! Int? ?? 0) + pointsAdded
                                            
                                            DataService.instance.REF_USER_REWARDS.child(uid).child(storeId).updateChildValues(["points": totalPoints])
                                        
                                        // return to stop recursive function.
                                        return
                                    }
                                    
                                } else {
                                    
                                    print("DEBUG: HAS NOT CREATED A STORE WITH THIS ID SO WE WILL CREATE IT")
                                 
                                    DataService.instance.REF_USER_REWARDS.child(uid).child(storeIdentifier).updateChildValues(["points": pointsAdded, "title": name, "image": image])
                                    
                                    // return to stop the recursive function... we need to use this in other use cases
                                    return
                                }
                                    
                            }
                        }
                    } else {
                        
                        // create user rewards section with information provided
                        print("DEBUG: USER IS NOT FOUND IN THE REWARDS SECTION, SO LET'S CREATE USER INITIALLY")
                        DataService.instance.REF_USER_REWARDS.child(currentUid).child(storeIdentifier).updateChildValues(["points": pointsAdded, "title": name, "image": image])
                    }
                })
            }

        
    }
    
    func setRewards(_ mapItem: MKMapItem?) {
        // setting compare key to string value globally
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        DataService.instance.REF_STORES.observeSingleEvent(of: .value) { (snapshot) in
            
            guard let mapItemLat = mapItem?.placemark.coordinate.latitude else { return }
            guard let mapItemLong = mapItem?.placemark.coordinate.longitude else { return }
            
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.forEach({ (snapshot) in
                let storeId = snapshot.key
                
                Database.fetchStore(with: storeId, completion: { (store) in
                    
                    guard let dbStoreLat = store.lat else { return }
                    guard let dbStoreLong = store.long else { return }
                    
                    
                    if dbStoreLat == mapItemLat && dbStoreLong == mapItemLong {
    
                        guard let storeId = store.storeId else { return }
                        guard let storePoints = store.points else { return }
                        
                        print("DEBUG: store ID \(storeId)")
                        print("DEBUG: store points \(storePoints)")
                        
                        // just need to note here if the segment was completed.. then we can only re-plot the segment that is complete and add the point values to the rewards as such.
                        DataService.instance.REF_TRIPS.child(currentUid).child(self.tripHolder).child(self.keyHolder).updateChildValues(["segmentCompleted": true])
  
                        
                        // here we need to send the points to be calculated and added
                    }
                })
            })
        }
        
        
    }
    
    func addStoreUrl(_ storeId: String) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        
        
        print("DEBUG: able to pass store id but now we must see why the store LOgo url \(storeId)")
        
        
    if didCreateFolder == false {
        DataService.instance.REF_STORES.child(storeId).child("storeLogoUrl").observeSingleEvent(of: .value) { (snapshot) in
            
            guard let logoUrl = snapshot.value as? String else { return }
            
            // retrieving points for that store that day
            DataService.instance.REF_STORES.child(storeId).child("points").observeSingleEvent(of: .value) { (snapshot) in
                
                guard let dailyPointVal = snapshot.value as? String else { return }
            
            // adding this information to the activity folder
            //DataService.instance.REF_ACTIVITY.child(currentUid).child(self.tripHolder).childByAutoId().childByAutoId().updateChildValues(["logoUrl": logoUrl, "storeId": storeId])
            
                DataService.instance.REF_ACTIVITY.child(currentUid).child(self.tripHolder).childByAutoId().child("logo\(self.logoNum)").updateChildValues(["logoUrl\(self.logoNum)": logoUrl, "points\(self.logoNum)": dailyPointVal])
            //DataService.instance.REF_ACTIVITY.child(currentUid).child(self.tripHolder).child("storeIdentifiers").updateChildValues(["storeId\(self.logoNum)": storeId])
            
                // going back to save the key value for the url value that was just created
            DataService.instance.REF_ACTIVITY.child(currentUid).child(self.tripHolder).queryLimited(toFirst: 1).observe(.childAdded) { (snapshot) in
            
                        let snap = snapshot.key
                self.childByAutoKey = snap // we only need to find this once
 
                
                // increment x
                self.logoNum += 1
                
                print("DEBUG: This is the child key \(self.childByAutoKey) and x is now equal = \(self.logoNum)")
                            }
                        }
        
            }
            self.didCreateFolder = true
        
    } else {
            
            DataService.instance.REF_STORES.child(storeId).child("storeLogoUrl").observeSingleEvent(of: .value) { (snapshot) in
                guard let logoUrl = snapshot.value as? String else { return }
                
                // retrieving points for that store that day
                DataService.instance.REF_STORES.child(storeId).child("points").observeSingleEvent(of: .value) { (snapshot) in
                    
                    guard let dailyPointVal = snapshot.value as? String else { return }
            
                
                    DataService.instance.REF_ACTIVITY.child(currentUid).child(self.tripHolder).childByAutoId().child("logo\(self.logoNum)").updateChildValues(["logoUrl\(self.logoNum)": logoUrl, "points\(self.logoNum)": dailyPointVal])
                
                //DataService.instance.REF_ACTIVITY.child(currentUid).child(self.tripHolder).child(self.childByAutoKey).childByAutoId().updateChildValues(["logoUrl": logoUrl, "storeId": storeId])

                //DataService.instance.REF_ACTIVITY.child(currentUid).child(self.tripHolder).child("storeIdentifiers").updateChildValues(["storeId\(self.logoNum)": storeId])
                
                self.logoNum += 1
                
            }
        }
    }
        /*
         let logosKey = snapshot.value as! [String: Dictionary<String, String>]
         for (key, value) in logosKey {
             if value[storeId] == logoUrl {
                 self.childByAutoKey = key // we only need to find this once
             }
         }
         */

    }
    

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Did enter region \(region.identifier)")
        print("Region monitoring activated! \(region)")
        
        
        // below i can use the store ID because it may be simpler and increments as the keyhold value increments
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_TRIPS.child(currentUid).child(tripHolder).child(keyHolder).child("storeId").observeSingleEvent(of: .value, with: { (snapshot) in

            guard let storeIdentifier = snapshot.value as? String else { return }
            let currentKeyHolderKey = self.keyHolder
            
            print("DEBUG: WE DEFINITELY GET TO THIS POINT AFTER ENTERING THE REGION \(storeIdentifier)")
            self.updateCompletedPath(storeIdentifier, keyHolder: currentKeyHolderKey)
            
            
            // call function that grabs takes store id and using this to get logo image and placing it under the posts
            self.addStoreUrl(storeIdentifier)
        })
    

        print("Normal key value is \(keyHolder)")
        print("Compare key value is \(finalSegmentId)")
        
        if keyHolder == finalSegmentId {
            print("Normal Key \(key) and Compare Key\(finalSegmentId) are equal, last trip!")
            
            AlertService.actionSheet(in: self, title: "Last Stop, Check In!") {
                
                CLService.shared.updateLocation()
                UNService.shared.finishTripRequest()
                
                // make sure this applies to the last check in region
                self.handleStartStopTrip()

                /*
                  startTripPressed = true
                  print("DEBUG: START TRIP SHOULD BE TRUE")
                 
                  saveRun()
                  
                  newTimer?.invalidate()
                  manager?.stopUpdatingLocation()
                 */
                
                return
            }
        
        } else {
        
        self.i += 1
            // increments value to for region monitor
        self.monVal += 1
        updateMonitoredDestination(self.monVal)
            print("DEBUG: THE MONITOR VALUE IS \(self.monVal)")
            
            
        self.getTripKey()
        
            // setting a boolean here to control whether or not a checkin gets posted
        checkpointReached = true
        AlertService.actionSheet(in: self, title: "You're Here, Check In!") {
                
                CLService.shared.updateLocation()
                UNService.shared.locationRequest()
                //self.handleStartTrip()
            
                // collect points for a particular location
      
            }
            

            
        }
        
        // first grab points from trip.. by comparing the region.. then add points, add coordinates, and add storeid to actual trip to plot and to the each store rewards via the storeid
        
        

        
        /*
        DataService.instance.REF_TRIPS.child(currentUid).child(tripHolder).child(keyHolder).child("destinationCoordinate").observeSingleEvent(of: .value, with: { (snapshot) in
                 
                 let destinCoordinatesArray = snapshot.value as! NSArray
                 let latitude = destinCoordinatesArray[0] as! Double
                 let longitude = destinCoordinatesArray[1] as! Double
             
             self.pathDestination = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
             
             let placemark = MKPlacemark(coordinate: self.pathDestination )
             let mapItem = MKMapItem(placemark: placemark)
            
            self.setRewards(mapItem)
            
        })
        */
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
            print("Did exit region \(region.identifier)")
            manager.stopMonitoring(for: region)
    }
    
    
    
    // MARK: - API
    
    func fetchStores() {
        
        if storeCurrentKey == nil {
            DataService.instance.REF_STORES.queryLimited(toLast: 11).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let storeId = snapshot.key
                    
                    Database.fetchStore(with: storeId, completion: { (store) in
                        self.stores.append(store)
                        self.tableView.reloadData()
                        
                    })
                })
                self.storeCurrentKey = first.key
            }
        } else {
            
            DataService.instance.REF_STORES.queryOrderedByKey().queryEnding(atValue: storeCurrentKey).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let storeId = snapshot.key
                    
                    if storeId != self.storeCurrentKey {
                        Database.fetchStore(with: storeId, completion: { (store) in
                            self.stores.append(store)
                            self.tableView.reloadData()
                        })
                    }
                })
                self.storeCurrentKey = first.key
            })
        }
        
        
        /*
        DataService.instance.REF_STORES.observe(.childAdded) { (snapshot) in
            
            let storeId = snapshot.key
            
            Database.fetchStore(with: storeId, completion: { (store) in
                
                self.stores.append(store)
                
                self.tableView.reloadData()
                
            })
            
            /* let uid = snapshot.key
             
             Database.fetchUser(with: uid, completion: { (user) in      // Using reference Database extension.
             
             self.users.append(user)
             self.tableView.reloadData()
             }) */
        } */
    }
    
    func handleMenuToggle(menuOption: MenuOption) {
        
        switch menuOption {
        
        case .Activity:
            print("show activity")
            
        case .Groups:

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                print("show Groups")
                
                //self.groupMessageController.delegate = self
                let groupMessageController = GroupMessageController()
                self.navigationController?.pushViewController(groupMessageController, animated: true)
                
                //groupMessageController.modalPresentationStyle = .fullScreen
                //self.present(groupMessageController, animated: true, completion:nil)
            }
        
            
        case .Search:
            
            print("show search")
            let searchVC = SearchVC()
            navigationController?.pushViewController(searchVC, animated: true)
    
        case .Messages:
            print("show messages")
            
            let messageVC = MessagesController()
            navigationController?.pushViewController(messageVC, animated: true)
            
        case .Notifications:
            print(" show notifications")
        
            let notificationsVC = NotificationsVC()
            navigationController?.pushViewController(notificationsVC, animated: true)
            
        case .Rewards:
            print("show rewards")
            let rewardsVC = RewardsVC()
            navigationController?.pushViewController(rewardsVC, animated: true)
            
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                
            //}
            
            
        case .Trips:
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                print("show trips")
                

            }

        case .Settings:
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                print("show Settings")
                
                self.userSettingsVC.delegate = self
                //let userSettingsVC = UserSettingsVC()
                self.userSettingsVC.modalPresentationStyle = .fullScreen
                self.present(self.userSettingsVC, animated: true, completion:nil)
            }
            

            
            case .Help:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                print("show help - email me!")
            }
            
        }
    }
    
    func handleRightMenuToggle(rightMenuOption: RightMenuOption) {
        
        switch rightMenuOption {
        
        case .Analytics:
            
            print("show analytics")
            
        case .Search:
            let searchVC = SearchVC()
            navigationController?.pushViewController(searchVC, animated: true)
            
        case .Message:
            let messageVC = MessagesController()
            navigationController?.pushViewController(messageVC, animated: true)
            
        case .Notifications:
            let notificationsVC = NotificationsVC()
            navigationController?.pushViewController(notificationsVC, animated: true)
            
        case .Groups:
            print("show groups")
            
        case .Posts:
            //let userSpecificFeedVC = UserSpecificFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
            //navigationController?.pushViewController(userSpecificFeedVC, animated: true)
            
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            print("THIS IS THE CURRENT USER ID FOR YOUR POST")
            //let userSpecificFeedVC = UserSpecificFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
            let userSpecificFeedVC = UserSpecificFeedVC()
            userSpecificFeedVC.uid = currentUid
            navigationController?.pushViewController(userSpecificFeedVC, animated: true)
            
            
            
        case .Followers:
            
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            
            DataService.instance.REF_USERS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                let uid = snapshot.key
                let user = User(uid: uid, dictionary: dictionary)
                
                let followVC = FollowLikeVC()
                followVC.viewingMode = FollowLikeVC.ViewingMode(index: 1)
                followVC.uid = user.uid
                self.navigationController?.pushViewController(followVC, animated: true)
            }
            
        case .Following:
            
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            
            DataService.instance.REF_USERS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                let uid = snapshot.key
                let user = User(uid: uid, dictionary: dictionary)
                
                let followingVC = FollowLikeVC()
                followingVC.viewingMode = FollowLikeVC.ViewingMode(index: 0)
                followingVC.uid = user.uid
                self.navigationController?.pushViewController(followingVC, animated: true)
            }
        }
    }

    
    func handleSettingsMenuToggle(settingsMenuOption: SettingsMenuOption) {
        
        switch settingsMenuOption {
        case .Profile:

            let profileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
            //profileVC.modalPresentationStyle = .fullScreen
            //present(profileVC, animated: true, completion:nil)
            navigationController?.pushViewController(profileVC, animated: true)
            
        case .Payment:
            print("show payment")
            
        case .Trips:
            print("show trips")
            
        case .Help:
            print("show help")
            
        case .Logout:
            
            let loginVC = LoginVC()
            
            if Auth.auth().currentUser == nil {
                       
                        loginVC.modalPresentationStyle = .fullScreen
                        present(loginVC, animated: true, completion:nil)
                       
                print("DEBUG: User is not logged in so you need to login")
                   } else {
                    
                do {
                try Auth.auth().signOut()
                        loginVC.modalPresentationStyle = .fullScreen
                        present(loginVC, animated: true, completion:nil)
                    print("DEBUG: User is logged in and WILL BE LOGGED OUT")
                    
                    guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                    guard let controller = navController.viewControllers[0] as? MainTabVC else { return }
                    controller.configureViewControllers()
                    
                } catch ( let error) {
                    print(error)
                }
            }
            
            //let loginVC = LoginVC()
            //loginVC.modalPresentationStyle = .fullScreen
            //present(loginVC, animated: true, completion:nil)
            
            // this must be in place to serve the below extension
            loginVC.delegate = self
            
        }
    }
    
    // pedometer values
    
    // convert seconds to hh:mm:ss as a string
    func timeIntervalFormat(interval: TimeInterval)-> String {
        var seconds = Int(interval + 0.5) // round up seconds
        let hours = seconds / 3600
        let minutes = (seconds / 60) % 60
        seconds = seconds % 60
        
        //return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        return String(format: "%02i:%02i", hours, minutes)
    }
    
    // convert a pace in meters per second to a string with the metric m/s and imperial minutes per mile
    func paceString(title: String, pace: Double)-> String {
    //func paceString(pace: Double)-> String {
        var minPerMile = 0.0
        let factor = 26.8224 // conversion factor
        if pace != 0 {
            minPerMile = factor / pace
        }
        let minutes = Int(minPerMile)
        let seconds = Int(minPerMile * 60) % 60
        //return String(format: "%@: %02.2f m/s \n\t %02i:%02i min/mi", title, pace, minutes, seconds)
        return String(format: "%02i:%02i", minutes)
    }
    
    func computedAvgPace()-> Double {
        if let distance = self.distance {
            pace = distance / timeElapsed
            return pace
        } else {
            return 0.0
        }
    }
    
    func miles(meters: Double)-> Double {
        let mile = 0.000621371192
        return meters * mile
    }
    
// calculate calories
    
}

// searchbar and store results tableview

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredStores.count
        } else {
            return stores.count
        }
        
        //return stores.count
        //return posts.count
        //return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if stores.count > 10 {
            if indexPath.item == stores.count - 1 {
                fetchStores()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchStoreCell
        
        
        var store: Store!
        
        if inSearchMode {
            store = filteredStores[indexPath.row]
        } else {
            store = stores[indexPath.row]
        }
        
        cell.store = store
        
        /*var store: Store!
        
        store = stores[indexPath.row]
        
        cell.store = store */
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "searchCell")
        //let mapItem = posts[indexPath.row]
        
        //let mapItem = stores[indexPath.row]
        
        //cell.textLabel?.text = mapItem.title
        //cell.detailTextLabel?.text = mapItem.location
        
        
        return cell
    }
    
    
    

    // after selecting an actual row starts here
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //handleDismiss()
        
        //shouldPresentLoadingView(true)
        
        let selectedSearchStore = stores[indexPath.row]
        var store: Store!
        
        if inSearchMode {
            store = filteredStores[indexPath.row]
        } else {
            store = stores[indexPath.row]
        }
        
        guard let storeName = store?.title else { return }
        guard let lat = selectedSearchStore.lat else { return }
        guard let long = selectedSearchStore.long else { return }
        //guard let points = selectedSearchStore.points else { return }
        
        let coordinatePin = CLLocationCoordinate2DMake(lat, long)
        let addressDict = [CNContainerNameKey: selectedSearchStore.title]
        
        let destinationPin = MKPlacemark(coordinate: coordinatePin, addressDictionary: addressDict as [String : Any])
        
        let newMapItem = MKMapItem(placemark: destinationPin)
        newMapItem.name = storeName
        
        //mapView.removeOverlays(mapView.overlays)
  
        dropPinFor(mapItem: newMapItem)
        //print(newMapItem)
        
        //animateTableView(shouldShow: false)
        
        //shouldPresentLoadingView(false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newMapItem.placemark.coordinate
   
         
        
        if initialCheckpointSelected == false {
                //self.toggleSaveRemoveSegmentView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            self.startStopButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                //self.toggleSaveRemoveSegmentView.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
                self.startStopButton.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
                
                //self.toggleSaveRemoveSegmentView.alpha = 1
                self.startStopButton.alpha = 1

            }) { (_) in
                //self.toggleSaveRemoveSegmentView.transform = .identity
                self.startStopButton.transform = .identity
            }
        }
        
        // when selecting another annotation i need for the startstop button is pressed
        if saveSegmentVisible == false {
            
            // toggle back to saved segment
            //toggleSaveRemoveSegmentView.backgroundColor = startColor
            
            saveRemovePathLabel.text = "Save Path"
            saveRemovePathLabel.textColor = .white
             saveRemovePathLabel.backgroundColor = .clear
        }
        
         /*
        guard let pointsLabel = selectedSearchStore.points else {return}
        annotation.title = String(pointsLabel)
        */
        
        
        // got this from new map item
        plotSearchTableSelection(_forMapItem: newMapItem)
        
        
        //mapView.addAnnotation(annotation)
        
        handleCancelSearch()
 
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //if destinationTextField.text == "" {
        //animateTableView(shouldShow: false)
        //}
    }
    
}

// MARK: - StoreCellDelegate

extension HomeVC: StoreCellDelegate {

    func distanceFromUser(location: CLLocation) -> CLLocationDistance? {
        
        guard let userLocation = manager?.location else { return nil }
        return userLocation.distance(from: location)
    }
}

extension HomeVC: SearchStoreCellDelegate {
    
    func distanceFromUser(searchLocation: CLLocation) -> CLLocationDistance? {
        
        //  seems you need to implement under the place where the function will be called.
        let searchCell = SearchStoreCell()
        searchCell.delegate = self

        guard let userLocation = manager?.location else { return nil }
        return userLocation.distance(from: searchLocation)
    }
    
}

extension UIViewController {
    
    func setupToHideKeyboardOnTapOnView()
    {
        
        print("SCREEN IS TAPPED HERE")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        print("KEYBOARD IS DISMISSED HERE")
        view.endEditing(true)
    }
}


// MARK: - HomeControllerDelegate

extension HomeVC: HomeControllerDelegate {
    
    func handleRightMenuToggle(shouldDismiss: Bool, rightMenuOption: RightMenuOption?) {
        
        if shouldDismiss {
                
                let height: CGFloat = 568

                if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
                    
                if let window:UIWindow = applicationDelegate.window {

                    let collectionViewY = window.frame.width - height
                        //print("we get this far it should toggle back")
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                            
                            self.rightMenuVC.view.frame = CGRect(x: 0, y: -(collectionViewY) + 650, width: window.frame.width, height: self.rightMenuVC.view.frame.height)
                                                
                            self.isRightMenuExpanded = false
                            self.handleRightMenuBVOnDismiss()
                            //must first complete using this completions block below
                        }) { (_) in
                            guard let rightMenuOption = rightMenuOption else { return }
                            self.handleRightMenuToggle(rightMenuOption: rightMenuOption)
                        }
                    }
                }
            } else {
                print("DEBUG: FROM HERE I CAN GET A RESPONSE")
            }
    }
    
    func handleProfileToggle(shouldDismiss: Bool) {
        
        if shouldDismiss {
            
            //let width: CGFloat = 550
            let width: CGFloat = 570

            if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
                
            if let window:UIWindow = applicationDelegate.window {

                let collectionViewX = window.frame.width - width
                    //print("we get this far it should toggle back")
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                        
                        self.menuVC.view.frame = CGRect(x: collectionViewX - 570, y: 0, width: self.menuVC.view.frame.width, height: window.frame.height)
                    
                        self.isMenuExpanded = false
                        self.handleBlackViewOnDismiss()
                        //must first complete using this completions block below
                    
                    self.handleProfileView()
                    }) { (_) in
                        //self.handleProfileView()
                }
                }
            }
        } else {
            print("DEBUG: FROM HERE I CAN GET A RESPONSE")
        }
    }
    
    
    func handleMenuToggle(shouldDismiss: Bool, menuOption: MenuOption?) {
        
        if shouldDismiss {
            
            //let width: CGFloat = 550
            let width: CGFloat = 570

            if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
                
            if let window:UIWindow = applicationDelegate.window {

                let collectionViewX = window.frame.width - width
                    //print("we get this far it should toggle back")
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                        
                        self.menuVC.view.frame = CGRect(x: collectionViewX - 570, y: 0, width: self.menuVC.view.frame.width, height: window.frame.height)
                    
                        self.isMenuExpanded = false
                        self.handleBlackViewOnDismiss()
                        
                    
                    guard let menuOption = menuOption else { return }
                    self.handleMenuToggle(menuOption: menuOption)
                    }) { (_) in
                        //must first complete using this completions block before peforming action
                        //guard let menuOption = menuOption else { return }
                        //self.handleMenuToggle(menuOption: menuOption)
                }
                }
            }
        } else {
            print("DEBUG: FROM HERE I CAN GET A RESPONSE")
        }
    }
}
/*
extension HomeVC: ProfileControllerDelegate {
    func handleProfileToggle(shouldDismiss: Bool) {
        print("DEFAULT: Should toggle menu back")
        
        if shouldDismiss {
            
            //let width: CGFloat = 550
            let width: CGFloat = 540

            if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
                
            if let window:UIWindow = applicationDelegate.window {

                let collectionViewX = window.frame.width - width
                    //print("we get this far it should toggle back")
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                        
                        self.menuVC.view.frame = CGRect(x: collectionViewX - 540, y: 0, width: self.menuVC.view.frame.width, height: window.frame.height)
                    
                        self.isMenuExpanded = false
                        self.handleBlackViewOnDismiss()
                        //must first complete using this completions block below
                    }) { (_) in
                        self.handleProfileView()
                        
                }
                }
            }
        } else {
            print("DEBUG: FROM HERE I CAN GET A RESPONSE")
        }
        
    }
}
*/
// MARK: - SettingsControllerDelegate

extension HomeVC: SettingsControllerDelegate {
    
    func handleSettingsMenuToggle(shouldDismiss: Bool, settingsMenuOption: SettingsMenuOption?) {

        // for this function to work we had to add the command under the original menu options settings --> userSettingsVC.delegate = self
        
                if shouldDismiss == true {
                       
                           guard let settingsMenuOption = settingsMenuOption else { return }
                   
                           self.handleSettingsMenuToggle(settingsMenuOption: settingsMenuOption)
                   
                      } else {
                   
                          print("DEBUG: FROM HERE I CAN GET A RESPONSE")
                      }
        
    }
    
}

extension HomeVC: AdminLoginControllerDelegate {
    func handleAdminLogin(shouldDismiss: Bool) {
        
        print("DEBUG: does this show up")
        if shouldDismiss {
            
            print("do we get here?")
            
            
            let adminLoginVC = AdminLoginVC()
            adminLoginVC.modalPresentationStyle = .fullScreen
            present(adminLoginVC, animated: true, completion:nil)
            
        }
    }
}


extension HomeVC: UITextFieldDelegate {
    

    func textFieldDidBeginEditing(_ sender: UITextField) {
        

            
        //reconfigures search table view
        configureSearchTableView()
        
        searchTableView.isHidden = false
        
        //lineView.isHidden = false
        
        if sender == destinationTextField {
  
            
        customMenuButton.isHidden = true
        customMenuButtonArrow.isHidden = true
        //customProfileButton.isHidden = true
               //searchBar.sizeToFit()
              
           
               //isSearchTableViewVisible = true
           
            /*
               if isStoreDetailViewVisible == true {
                   
                   dismissStoreDetailView()
                   
               }
            */
            
            searchTableView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            //lineView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                
                self.searchTableView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.searchTableView.alpha = 1
                
               // self.lineView.transform = CGAffineTransform(scaleX: 1, y: 1)
              //  self.lineView.alpha = 1
                
                
            }) { (_) in
                self.searchTableView.transform = .identity
               // self.lineView.transform = .identity
                self.expansionState = .FullyExpanded
                self.isSearchTableViewVisible = true
            }

            
            /*
               //let tabBarHeight = CGFloat((tabBarController?.tabBar.frame.size.height)!)
               let navBarHeight = CGFloat((navigationController?.navigationBar.frame.size.height)!)
               print(navBarHeight)
               
               if expansionState == .NotExpanded {
        
                animateInputView(targetPosition: self.searchTableView.frame.origin.y - 645) { (_) in
                       self.expansionState = .FullyExpanded
                       print("not expanded to fully expanded")
    

                   }
               }
 
             */
            
                /*
               
               if expansionState == .PartiallyExpanded {
                   
                   animateInputView(targetPosition: self.searchTableView.frame.origin.y - 342) { (_) in
                       self.expansionState = .FullyExpanded
                       print("partially expanded to fully expanded")
                   }
                   
               }
 
                */
               //searchBar.showsCancelButton = true
 
            
            /*
            UIView.animate(withDuration: 1.0, animations: {
                self.destinationTextField.frame = CGRect(x: self.destinationTextField.frame.origin.x + 100, y: self.destinationTextField.frame.origin.y, width: self.destinationTextField.frame.size.width, height: self.destinationTextField.frame.size.height) })
            
            UIView.animate(withDuration: 1.0, animations: {
            self.destTextFieldBlurView.frame = CGRect(x: self.destTextFieldBlurView.frame.origin.x + 100, y: self.destTextFieldBlurView.frame.origin.y, width: self.destinationTextField.frame.size.width, height: self.destTextFieldBlurView.frame.size.height) })
            */
 
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.removeBlurEffect()
                self.destTextFieldBlurView.transform = CGAffineTransform(scaleX: 1.40, y: 1)
                self.destTextFieldBlurView.layer.cornerRadius = 8
                self.visualEffectView.layer.cornerRadius = 8
                self.destTextFieldBlurView.layer.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 250).cgColor
                //self.destTextFieldBlurView.layer.backgroundColor = UIColor(red: 187/255, green: 216/255, blue: 224/255, alpha: 1).cgColor
                self.destTextFieldBlurView.layer.shadowColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0).cgColor
                self.destTextFieldBlurView.layer.borderWidth = 0.75
                self.destTextFieldBlurView.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
                //self.searchImageView.frame.origin.x -= 50
                //self.destinationTextField.frame.origin.x -= 50

            })
            
            
            
            mapView.addSubview(cancelSearchButton)
            cancelSearchButton.anchor(top: mapView.topAnchor, left: nil, bottom: nil, right: mapView.rightAnchor, paddingTop: 42, paddingLeft: 0, paddingBottom: 0, paddingRight: 32, width: 20, height: 20)

            cancelSearchButton.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            searchBarSubView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            settingsButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            settingsButtonBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
            simpleRightMenuButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            centerMapBackground.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            centerMapButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            searchImageView.transform = CGAffineTransform(translationX: 0, y: 0)
            destinationTextField.transform = CGAffineTransform(translationX: 0, y: 0)
            simpleProfileBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
            simpleProfileButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            profileImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                self.cancelSearchButton.alpha = 1
                self.cancelSearchButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                self.searchBarSubView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.searchBarSubView.alpha = 1
                
                self.settingsButtonBackground.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                self.settingsButtonBackground.alpha = 0
                
                self.settingsButton.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                self.settingsButton.alpha = 0
                
                
                self.simpleRightMenuButton.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                self.simpleRightMenuButton.alpha = 0
                
                self.simpleProfileBackground.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                self.simpleProfileBackground.alpha = 0
                
                self.simpleProfileButton.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                self.simpleProfileButton.alpha = 0
                
                self.profileImageView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                self.profileImageView.alpha = 0
                
                self.centerMapBackground.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                self.centerMapBackground.alpha = 0
                
                self.centerMapButton.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                self.centerMapButton.alpha = 0
                
                self.searchImageView.transform = CGAffineTransform(translationX: -40, y: 0)
                self.destinationTextField.transform = CGAffineTransform(translationX: -40, y: 0)
                
                
            }) { (_) in
                self.cancelSearchButton.transform = .identity
                self.settingsButtonBackground.transform = .identity
                self.settingsButton.transform = .identity
                self.simpleRightMenuButton.transform = .identity
                self.centerMapBackground.transform = .identity
                self.centerMapButton.transform = .identity
                self.simpleProfileBackground.transform = .identity
                self.simpleProfileButton.transform = .identity
                self.profileImageView.transform = .identity
                
                //self.searchImageView.transform = .identity
            }
            
            if isStoreDetailViewVisible == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.storeDetailView.dismissDetailView()
                }
            }
           
        }
    }
    

    //func textFieldEditingChanged(_ sender: UITextField, textDidChange searchText: String) {
    @objc func textFieldDidChange(_ searchText: UITextField) {

        print(searchText)

               //let searchText = searchText
        let searchText = String(searchText.text!)
        
        
        if searchText.isEmpty || searchText == " " {
                   inSearchMode = false
                   tableView.reloadData()
               } else {
                   inSearchMode = true
                   
                   // return fitlered stores
                   filteredStores = stores.filter({ (store) -> Bool in
                       
                       // using the username to filter through
                    //return store.title.contains(searchText)
                    return store.title.localizedCaseInsensitiveContains(searchText)
                   })
                   tableView.reloadData()
               }
    }
    
    @objc func handleCancelSearch() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.addBlurEffect()
            
            self.destTextFieldBlurView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.destTextFieldBlurView.layer.cornerRadius = 22
            self.visualEffectView.layer.cornerRadius = 22
            self.destTextFieldBlurView.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0).cgColor
            self.destTextFieldBlurView.layer.shadowColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.25).cgColor
            self.destTextFieldBlurView.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
            self.destTextFieldBlurView.layer.borderWidth = 1.75
            //self.searchImageView.frame.origin.x += 50
            //self.destinationTextField.frame.origin.x += 50
        })
        
        //clears search view
        destinationTextField.text = nil
        inSearchMode = false
        
        // reloads search table view data
        tableView.reloadData()

        
        cancelSearchButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        searchBarSubView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        settingsButton.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        settingsButtonBackground.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        simpleRightMenuButton.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        rewardsBackgroundSubView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        simpleProfileBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
        simpleProfileButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        profileImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        centerMapBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
        centerMapButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            
            self.cancelSearchButton.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            self.cancelSearchButton.alpha = 0
            
            self.searchBarSubView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            self.searchBarSubView.alpha = 0
            
            self.settingsButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.settingsButton.alpha = 1
            
            self.settingsButtonBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.settingsButtonBackground.alpha = 1
            
            self.simpleRightMenuButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.simpleRightMenuButton.alpha = 1
            
            self.rewardsBackgroundSubView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.rewardsBackgroundSubView.alpha = 1
            
            self.searchImageView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.destinationTextField.transform = CGAffineTransform(translationX: 0, y: 0)
            
            self.simpleProfileBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.simpleProfileBackground.alpha = 1
            
            self.simpleProfileButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.simpleProfileButton.alpha = 1
            
            self.profileImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.profileImageView.alpha = 1
            
            self.centerMapBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.centerMapBackground.alpha = 1
            
            self.centerMapButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.centerMapButton.alpha = 1
            
        }) { (_) in
            self.cancelSearchButton.transform = .identity
            self.settingsButton.transform = .identity
            self.settingsButtonBackground.transform = .identity
            self.simpleRightMenuButton.transform = .identity
            self.rewardsBackgroundSubView.transform = .identity
            self.simpleProfileBackground.transform = .identity
            self.simpleProfileButton.transform = .identity
             self.profileImageView.transform = .identity
            self.centerMapBackground.transform = .identity
            self.centerMapButton.transform = .identity
        }
        
        dismissOnSearch()
        
        //self.customMenuButton.isHidden = false
        //self.customMenuButtonArrow.isHidden = false
       // self.customProfileButton.isHidden = false
        
        //self.customMenuButton.alpha = 1
        //self.customProfileButton.alpha = 1
        
        
        print("We reach this point so this should allow the keyboard to be cancelllllled")
        view.endEditing(true)
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        centerMapOnUserLocation()
        
        
        return true
    }
}

extension HomeVC: MenuControllerDelegate {
    func handleMenuToggle(shouldToggle: Bool) {
        //groupMessageController.delegate = self
        
        if shouldToggle == true {
        print("groups menu to right menu toggle")

        presentRightSlideMenu()
        }
    }
}

extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
    /*
    func dateConverter() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let date = dateFormatter.date(from: "18-11-2016")
    }
    */

}



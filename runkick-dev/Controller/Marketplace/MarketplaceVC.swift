//
//  MarketplaceVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/14/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "MarketplaceCell"
private let reuseTableIdentifier = "CategoryCell"
private let reuseCarouselIdentifier = "CarouselCell"


//class MarketplaceVC: UITableViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

class MarketplaceVC: UIViewController, UISearchBarDelegate, UICollectionViewDelegate {
    // Mark: - Properties
    
    var stores = [Store]()
    var categories = [MarketCategory]()
    var filteredCategories = [MarketCategory]()
    var searchBar = UISearchBar()
    var inSearchMode = false
    var titleView: UIView!
    var collectionView: UICollectionView!
    var collectionViewEnabled = true
    var tableView: UITableView!
    
    var currentKey: String?
    var userCurrentKey: String?
    
    
    lazy var menuBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        let rewardsTap = UITapGestureRecognizer(target: self, action: #selector(handleMenuView))
        rewardsTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(rewardsTap)
        view.alpha = 1
        return view
    }()
    
    lazy var rewardsBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        let rewardsTap = UITapGestureRecognizer(target: self, action: #selector(handleRewardsView))
        rewardsTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(rewardsTap)
        view.alpha = 1
        return view
    }()
    
    let menuLabel: UILabel = {
        let label = UILabel()
        label.text = "Healthy Options"
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        return label
    }()
    
    let rewardsLabel: UILabel = {
        let label = UILabel()
        label.text = "Rewards"
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        return label
    }()
    
    lazy var menuRewardsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var lineView: UIView = {
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
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Stops"
        label.textColor = UIColor.rgb(red: 160, green: 160, blue: 160)
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        //label.font = UIFont(name: "ArialRoundedMTBold", size: 17)
        return label
    }()
    
    lazy var destinationTextField: UITextField = {
        let tf = UITextField()
        //tf.placeholder = "Where to?"
        tf.attributedPlaceholder = NSAttributedString(string:"Browse Categories", attributes:[NSAttributedString.Key.foregroundColor: UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1)])
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.keyboardType = UIKeyboardType.default
        tf.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0).cgColor
        tf.layer.cornerRadius = 0 //25
        tf.clipsToBounds = true
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(HomeVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        view.isUserInteractionEnabled = true
        return tf
    }()
    
    lazy var cancelSearchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "simpleCancelIcon"), for: .normal)
        button.addTarget(self, action: #selector(handleCancelSearch), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    let searchLineViewVertical: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
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
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMenuRewardsView()
        
        configureTableView()
        
        
        //configureNavigationBar
        configureNavigationBar()
        
        destinationTextField.delegate = self
        
        // configure search bar
        configureSearchBar()

        // configure collection view
        configureCollectionView()
        
        // configure horizontal collection view
        configureCollectionViewHorizontal()
    
        
        // configure refresh control
        configureRefreshControl()
        

       
        configureTabBar()
        
        // fetch stores
        fetchStores()
        
        fetchRecentVisted()
    }
    
    // this function ensures the navigation bar is filled after transitioning to a regular nav bar
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           
        configureTabBar()
    }

    // MARK: - Table view data source
    
    /*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredCategories.count
        } else {
            return categories.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if categories.count > 20 {
            if indexPath.item == categories.count - 1 {
                fetchCategories()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       print("item selected")
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let categoryFeedVC = CategoryFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        categoryFeedVC.post = categories[indexPath.item]
        navigationController?.pushViewController(categoryFeedVC, animated: true)
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseTableIdentifier, for: indexPath) as! CategoriesCell
        
        cell.categoryPost = inSearchMode ? filteredCategories[indexPath.row] : categories[indexPath.row]
        
        return cell
    }
    */
    
     // MARK: - UITableView
    
    func configureTableView() {
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.backgroundColor = UIColor.walkzillaYellow()
 
        // register cell classes
        tableView.register(CategoriesCell.self, forCellReuseIdentifier: reuseTableIdentifier)
        
        
        // seperator insets.
        //tableView.separatorInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        
        // giving the top border a bit of buffer
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: menuRewardsView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        



    }
    
    // MARK: - UICollectionView
    
    func configureCollectionView() {
        

        // define the collection view characteristics
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let frame = CGRect(x: 0, y: 130, width: view.frame.width, height: view.frame.height - 130)

        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white //.red
        

        
        tableView.addSubview(collectionView)
        collectionView.register(MarketplaceCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        

        
        tableView.separatorColor = .clear
        

        
        //tableView.separatorInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
        
    }
    
    func configureCollectionViewHorizontal() {
        
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 130)

        collectionViewHorizontal = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionViewHorizontal.delegate = self
        collectionViewHorizontal.dataSource = self
        collectionViewHorizontal.alwaysBounceHorizontal = true
        collectionViewHorizontal.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        

        tableView.addSubview(collectionViewHorizontal)
        collectionViewHorizontal.register(StoreCarouselCell.self, forCellWithReuseIdentifier: reuseCarouselIdentifier)
        
        //collectionViewHorizontal.addSubview(titleLabel)
        //titleLabel.anchor(top: collectionViewHorizontal.topAnchor, left: collectionViewHorizontal.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //return UIEdgeInsets(top: 60, left: 16, bottom: 0, right: 16)
        return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let width = (view.frame.width - 40) / 3
        //let width = (view.frame.width - 24) / 2
        let height = width + (width / 1.7)
        return CGSize(width: width, height: height)
        
        
        //let width = (view.frame.width - 12) / 2
        //return CGSize(width: width, height: width - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if categories.count > 20 {
            if indexPath.item == categories.count - 1 {
                fetchStores()
            }
        }
        
    }
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        
        return CGSize(width: view.frame.width, height: 50)
    }
    */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MarketplaceCell
        
        cell.categoryPost = categories[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let categoryFeedVC = CategoryFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        categoryFeedVC.post = categories[indexPath.item]
        navigationController?.pushViewController(categoryFeedVC, animated: true)
        
        
        print("DEBUG: Here is the post value\(categoryFeedVC.post)")
    }
    
*/
    
    // MARK: - Handlers
    
    /*
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
        searchBar.anchor(top: titleView.topAnchor, left: titleView.leftAnchor, bottom: titleView.bottomAnchor, right: titleView.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.frame.width - 35, height: 40)
        
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
        
        /*
        if let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField,
               let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {

                   //Magnifying glass
                   glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
                   glassIconView.tintColor = .white
           }
        */
        
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
        //searchBar.searchTextField.layer.borderColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1).cgColor
        //searchBar.searchTextField.layer.borderWidth = 0.25
        
        /*
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = searchBar
        */
        
        //navigationItem.titleView = nil
    }
    */
    
    
    func configureMenuRewardsView() {
        
        view.addSubview(menuRewardsView)
        menuRewardsView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
        
        menuRewardsView.addSubview(lineView)
        lineView.anchor(top: nil, left: menuRewardsView.leftAnchor, bottom: menuRewardsView.bottomAnchor, right: menuRewardsView.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 0.75)
        
        menuRewardsView.addSubview(indicatorView)
        indicatorView.anchor(top: nil, left: lineView.leftAnchor, bottom: lineView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -1, paddingRight: 0, width: 110, height: 4)
        
        menuRewardsView.addSubview(menuBackground)
        menuBackground.anchor(top: nil, left: menuRewardsView.leftAnchor, bottom: lineView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 25, paddingBottom: 10, paddingRight: 0, width: 120, height: 40)
        
        menuBackground.addSubview(menuLabel)
        menuLabel.anchor(top: nil, left: menuBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        menuLabel.centerYAnchor.constraint(equalTo: menuBackground.centerYAnchor).isActive = true
        
        
        menuRewardsView.addSubview(rewardsBackground)
        rewardsBackground.anchor(top: nil, left: menuBackground.rightAnchor, bottom: lineView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: 90, height: 40)
        
        rewardsBackground.addSubview(rewardsLabel)
        rewardsLabel.anchor(top: nil, left: rewardsBackground.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        rewardsLabel.centerYAnchor.constraint(equalTo: rewardsBackground.centerYAnchor).isActive = true
        
       
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
        lineView.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        
    }
    
    /*
    func configureNavigationBar() {
        
        //view.addSubview(navigationController!.navigationBar)
        
        //navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        //navigationController?.navigationBar.barTintColor = UIColor.walkzillaRed()
        
        // add or remove nav bar bottom border
        navigationController?.navigationBar.shadowImage = UIImage()
        let lineView = UIView(frame: CGRect(x: 0, y: 45, width: view.frame.width, height: 0.25))
        lineView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        /*
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
        
        let font = UIFont(name: "HelveticaNeue", size: 17)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)]
        navigationItem.title = "Search"
        */
        
        navigationController?.navigationBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
 
        configureSearchBarButton()
    }
    */
    
    
    func configureSearchBar() {
           
           //let navBarHeight = CGFloat((navigationController?.navigationBar.frame.size.height)!)

           
           searchBar.delegate = self
           
           titleView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 10))
          // let frame = CGRect(x: 0, y: 0, width: 100, height: 44)
           //let titleView = UIView(frame: frame)
           //searchBar.backgroundImage = UIImage()
           //searchBar.frame = frame
           titleView.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 245)
           titleView.layer.cornerRadius = 3
           
           titleView.addSubview(cancelSearchButton)
           cancelSearchButton.anchor(top: titleView.topAnchor, left: nil, bottom: nil, right: titleView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 15, height: 15)
           
           titleView.addSubview(destinationTextField)
           destinationTextField.anchor(top: titleView.topAnchor, left: titleView.leftAnchor, bottom: titleView.bottomAnchor, right: cancelSearchButton.leftAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 110, height: 40)
           
           titleView.addSubview(searchLineViewVertical)
           searchLineViewVertical.anchor(top: titleView.topAnchor, left: titleView.leftAnchor, bottom: titleView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: -5, paddingBottom: 0, paddingRight: 0, width: 0.5, height: 0)

           navigationItem.titleView = titleView
           
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
    
    
    
    
    @objc func handleBackButton() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleMenuView() {
        
        print("transition to menu")

        
    }
    
    @objc func handleRewardsView() {
        print("transition to rewards")

        
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
    /*
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //searchBar.showsCancelButton = true
        
        //self.navigationItem.leftBarButtonItems = nil

        
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        } else {
            // Fallback on earlier versions
        }
        
        fetchStores()
        
        // hide collection view when we run this function
        collectionView.isHidden = true
        //collectionViewEnabled = false
        
        //tableView.separatorColor = .clear
    }
    
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            // text printing out the text real time
            print(searchText)
            
            
            if searchText == "" || searchBar.text == nil {
                inSearchMode = false
                tableView.reloadData()
                view.endEditing(true)
            } else {
                inSearchMode = true
                // whatever pokemon we are looking at look at there name and see if there name contains that search text, here $0 represnts any categories array
                filteredCategories = categories.filter({ $0.category?.range(of: searchText) != nil
                    
                    return ($0.category?.localizedCaseInsensitiveContains(searchText))!
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
        
        collectionViewEnabled = true
        collectionView.isHidden = false
        
        // added stuff
        navigationItem.titleView = nil

        tableView.separatorColor = .clear
        
        tableView.reloadData()
    }
    
    */

    
    
    
    // MARK: - Handlers
    
    @objc func handleRefresh() {
        categories.removeAll(keepingCapacity: false)
        self.currentKey = nil
        fetchStores()
        collectionView?.reloadData()
        collectionViewHorizontal.reloadData()
    }
    
    func configureRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.tableView?.refreshControl = refreshControl
    }
    
    // MARK: - API
    /*
    func fetchStores() {
        DataService.instance.REF_MARKETPLACE.observeSingleEvent(of: .value) { (snapshot) in
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.forEach({ (snapshot) in
                let categoryId = snapshot.key
                Database.fetchCategory(with: categoryId, completion: { (category) in
                    DispatchQueue.main.async {
                        
                        self.categories.append(category)
                        self.collectionView.reloadData()
                        //print(snapshot)
                    }
                })
            })
        }
    }
    */
    
    
    /*
    func fetchStores() {

        if userCurrentKey == nil {
            DataService.instance.REF_MARKETPLACE.queryLimited(toLast: 4).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let categoryId = snapshot.key
                    
                    Database.fetchCategory(with: categoryId, completion: { (category) in
                        self.categories.append(category)
                        self.collectionView.reloadData()
                    })
                })
                self.userCurrentKey = first.key
            }
        } else {
            DataService.instance.REF_MARKETPLACE.queryOrderedByKey().queryEnding(atValue: userCurrentKey).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let categoryId = snapshot.key
                    
                    if categoryId != self.userCurrentKey {
                        Database.fetchCategory(with: categoryId, completion: { (category) in
                            self.categories.append(category)
                            self.collectionView.reloadData()
                        })
                    }
                })
                self.userCurrentKey = first.key
            })
        }
    }
 */
    
    func fetchStores() {
        // function to fetch our images and place them in the collection view

        if currentKey == nil {
            
            // initial data pull
            DataService.instance.REF_MARKETPLACE.queryLimited(toLast: 21).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.tableView.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let categoryId = snapshot.key
                    
                    Database.fetchCategory(with: categoryId, completion: { (category) in
                        self.categories.append(category)
                        self.collectionView.reloadData()
                    })
                })
                self.currentKey = first.key
            })
        } else {
            // paginate here
            
            DataService.instance.REF_MARKETPLACE.queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let categoryId = snapshot.key
                    
                    if categoryId != self.currentKey {
                        Database.fetchCategory(with: categoryId, completion: { (category) in
                            self.categories.append(category)
                            self.collectionView.reloadData()
                        })
                    }
                })
                self.currentKey = first.key
                
            })
        }
    }
    
    func fetchCategories() {
        // function to fetch our images and place them in the collection view

        if currentKey == nil {
            
            // initial data pull
            DataService.instance.REF_MARKETPLACE.queryLimited(toLast: 21).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.tableView.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let categoryId = snapshot.key
                    
                    Database.fetchCategory(with: categoryId, completion: { (category) in
                        self.categories.append(category)
                        self.tableView.reloadData()
                    })
                })
                self.currentKey = first.key
            })
        } else {
            // paginate here
            
            DataService.instance.REF_MARKETPLACE.queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let categoryId = snapshot.key
                    
                    if categoryId != self.currentKey {
                        Database.fetchCategory(with: categoryId, completion: { (category) in
                            self.categories.append(category)
                            self.tableView.reloadData()
                        })
                    }
                })
                self.currentKey = first.key
                
            })
        }
    }
    /*
    func configureSearchBarButton() {
        // configuring titile button
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 320, height: 35)
        button.backgroundColor = .clear
       // button.setTitle("Categories", for: .normal)
       // button.titleLabel?.font =  UIFont(name: "PingFangTC-Semibold", size: 17)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
        navigationItem.titleView = button
        
        searchBar.showsCancelButton = true
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        //navigationItem.rightBarButtonItem?.tintColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        
                   let searchBarText = UIButton(type: UIButton.ButtonType.custom)
                       
                       searchBarText.frame = CGRect(x: 0, y: 0, width: 120, height: 33)
                       
                    searchBarText.setTitle("Search restaurants and healthy cuisines", for: .normal)
                    searchBarText.setTitleColor(UIColor.rgb(red: 80, green: 80, blue: 80), for: .normal)
                    searchBarText.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                       searchBarText.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
                       searchBarText.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
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
    */
    @objc func showSearchBar() {
        
        
        // hide collectionView will in search mode
        //navigationItem.titleView = searchBar
        
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = nil
        
        //fetchCategories()
        tableView.reloadData()
        
        //fetchStores()
        collectionView.isHidden = true
        collectionViewHorizontal.isHidden = true
        titleLabel.isHidden = true
        
        collectionViewEnabled = false
    
        configureSearchBar()
    }
    
    func fetchRecentVisted() {

        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        
        if userCurrentKey == nil {
            DataService.instance.REF_USER_REWARDS.child(currentUid).queryLimited(toLast: 21).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                
                
                allObjects.forEach({ (snapshot) in
                    
                    let storeId = snapshot.key
                    
                    
                   
                    Database.fetchFavorites(with: storeId, uid: currentUid, completion: { (store) in
                        print("I am just troubleshooting now \(store)")
                        self.stores.append(store)
                        
                        
                        self.collectionViewHorizontal.reloadData()
                    })
                })
                self.userCurrentKey = first.key
                
        
            }
        } else {
            DataService.instance.REF_USER_REWARDS.child(currentUid).queryOrderedByKey().queryEnding(atValue: userCurrentKey).queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let storeId = snapshot.key
                    
                    if storeId != self.userCurrentKey {
                        Database.fetchFavorites(with: storeId, uid: currentUid, completion: { (store) in
                            self.stores.append(store)
                            self.collectionViewHorizontal.reloadData()
                        })
                    }
                })
                self.userCurrentKey = first.key
            })
        }
    }
    
    
    /*
    func fetchPosts() {
        // function to fetch our images and place them in the collection view

        if currentKey == nil {
            
            // initial data pull
            DataService.instance.REF_POSTS.queryLimited(toLast: 21).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.tableView.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    
                    Database.fetchPost(with: postId, completion: { (post) in
                        self.posts.append(post)
                        self.collectionView.reloadData()
                    })
                })
                self.currentKey = first.key
            })
        } else {
            // paginate here
            
            DataService.instance.REF_POSTS.queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else { return }
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    
                    if postId != self.currentKey {
                        Database.fetchPost(with: postId, completion: { (post) in
                            self.posts.append(post)
                            self.collectionView.reloadData()
                        })
                    }
                })
                self.currentKey = first.key
                
            })
        }
    }
 */
    
}


extension MarketplaceVC: UITableViewDataSource, UITableViewDelegate  {

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredCategories.count
        } else {
            return categories.count
        }
        
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if categories.count > 20 {
            if indexPath.item == categories.count - 1 {
                fetchCategories()
            }
        }
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       print("item selected")
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let categoryFeedVC = CategoryFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        categoryFeedVC.post = categories[indexPath.item]
        navigationController?.pushViewController(categoryFeedVC, animated: true)
        
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseTableIdentifier, for: indexPath) as! CategoriesCell
        
        cell.categoryPost = inSearchMode ? filteredCategories[indexPath.row] : categories[indexPath.row]
        
        return cell
    }

}

extension MarketplaceVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
          return 2
      }
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == self.collectionViewHorizontal {
            return 2
        }
          return 8
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
      
      if collectionView == self.collectionViewHorizontal {
          let width = 90

          return CGSize(width: width, height: width + 10)
      }
        
        let width = (view.frame.width - 55) / 2
        let height = width + (width / 5)
        return CGSize(width: width, height: height)

    }
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == self.collectionViewHorizontal {
            return UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 0)
        }
          
          //return UIEdgeInsets(top: 60, left: 16, bottom: 0, right: 16)
          return UIEdgeInsets(top: 5, left: 20, bottom: 0, right: 20)
      }
      

      
      func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
          
        if collectionView == self.collectionViewHorizontal {
            if stores.count > 20 {
                if indexPath.item == stores.count - 1 {
                    fetchRecentVisted()
                    
                    print("We have actually reach the horizontal collection view")
                }
            }
        }
        
        
          if categories.count > 20 {
              if indexPath.item == categories.count - 1 {
                  fetchStores()
              }
          }
          
      }
      /*
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
          
          
          
          return CGSize(width: view.frame.width, height: 50)
      }
      */

      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionViewHorizontal {
            
            return stores.count
        }
        
          return categories.count
      }
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        return CGSize(width: view.frame.width, height: 40)
    }
    */
    
     /*
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
        String, at indexPath: IndexPath) -> UICollectionReusableView {
            let header = collectionViewHorizontal.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
                reuseCarouselIdentifier, for: indexPath) as! StoreCarouselCell
        
        header.backgroundColor = .red
            return header
    }
   

     */
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         if collectionView == self.collectionViewHorizontal {
                 let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCarouselIdentifier, for: indexPath) as! StoreCarouselCell
                 print("Do we reach this point")
                 cellA.favorite = stores[indexPath.item]

                 //cell.delegate = self
                 return cellA
        }
          
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MarketplaceCell
          
          cell.categoryPost = categories[indexPath.row]

          return cell
      }
      
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          
          let categoryFeedVC = CategoryFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
          categoryFeedVC.post = categories[indexPath.item]
          navigationController?.pushViewController(categoryFeedVC, animated: true)
          
          
          print("DEBUG: Here is the post value\(categoryFeedVC.post)")
      }
      

}


extension MarketplaceVC: UITextFieldDelegate {
    

    func textFieldDidBeginEditing(_ sender: UITextField) {

        
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        } else {
            // Fallback on earlier versions
        }
        
        //fetchStores()

        collectionView.isHidden = true
        collectionViewHorizontal.isHidden = true
        titleLabel.isHidden = true
        
        tableView.reloadData()
        
        if sender == destinationTextField {
  
            cancelSearchButton.alpha = 1
           
        }
    }
    

    //func textFieldEditingChanged(_ sender: UITextField, textDidChange searchText: String) {
    @objc func textFieldDidChange(_ searchText: UITextField) {

        
        print(searchText)

               //let searchText = searchText
        let searchText = String(searchText.text!)
        
        
            //let searchText = String(searchText.text!)
            
            
            if searchText.isEmpty || searchText == " " {
                inSearchMode = false
                tableView.reloadData()
            } else {
                
                inSearchMode = true
                
                // return fitlered users
                filteredCategories = categories.filter({ $0.category?.range(of: searchText) != nil
                    
                    return ($0.category?.localizedCaseInsensitiveContains(searchText))!
                })
                tableView.reloadData()
            }
        
        
        // text printing out the text real time
        print(searchText)
        
    }
    
    @objc func handleCancelSearch() {
    /*
            if #available(iOS 13.0, *) {
                searchBar.searchTextField.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
            } else {
                // Fallback on earlier versions
            }
        */
            
            collectionViewEnabled = true
            collectionView.isHidden = false
            collectionViewHorizontal.isHidden = false
              titleLabel.isHidden = false
            
        cancelSearchButton.alpha = 0
            // added stuff
            //navigationItem.titleView = nil
            //configureSearchBarButton()

        //clears search view
        destinationTextField.text = nil
        inSearchMode = false
        
        // reloads search table view data
        tableView.reloadData()

        print("We reach this point so this should allow the keyboard to be cancelllllled")
        //view.endEditing(true)
        self.view.endEditing(true)
        destinationTextField.resignFirstResponder()
        
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
       // centerMapOnUserLocation()
        
        
        return true
    }
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    */
}

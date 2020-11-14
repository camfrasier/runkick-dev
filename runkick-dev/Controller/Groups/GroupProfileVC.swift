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
private let headerIdentifier = "groupProfileHeader"
private let statisticsIdentifier = "statisticsIdentifier"



class GroupProfileVC: UIViewController, GroupProfileHeaderDelegate {
    
    // Mark: - Properties
    
    var tableView: UITableView!
    var groups = [UserGroup]()
    var group: UserGroup?
    
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
        view.backgroundColor = UIColor.rgb(red: 55, green: 34, blue: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        collectionView.backgroundColor = UIColor.rgb(red: 0, green: 255, blue: 0)
        
        
        view.addSubview(headerView)
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 140)
        
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 140, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configureTableView()

 
    }
    
    
    func setUserStats(for header: GroupProfileHeader) {
        print("handle set user stats")
    }
    
    func handleMemberDetailView(for header: GroupProfileHeader) {
        print("handle member detail view")
        
        // here you click on the top group memebers box and see their specific stats
    }
    
    func configureTableView() {

        tableView = UITableView()
        //tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.separatorColor = .clear
        
        // disables the scrolling feature for the table view
        tableView.isScrollEnabled = false
        
        tableView.register(GroupStatisticsCell.self, forCellReuseIdentifier: statisticsIdentifier)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: collectionView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 98, paddingRight: 0, width: 0, height: 0)
        tableView.backgroundColor = UIColor.rgb(red: 233, green: 233, blue: 4)
    }
    

}

extension GroupProfileVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        //return 1
        return 1
    }
    
    // this is a bit smoother to use with pagination, because it loads while your scrolling or when the cell is coming into view
   func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        /*
        if groups.count > 9 {
            if indexPath.item == posts.count - 1 {
                fetchPosts()
            }
        }
        */
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // sets the vertical spacing between photos
        //return 4
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = 90

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
        return 50
    }
    /*
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // Declare header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! GroupProfileHeader
        
        // Set delegate
        header.delegate = self
        

        // Set the user in header.
        header.userGroup = self.group
        
        navigationItem.title = group?.groupName
        //navigationItem.title = "Hi \(String(describing: user?.firstname))"

        return header
    }
    */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GroupDetailCell
        
        //cell.group = groups[indexPath.item]

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

        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: statisticsIdentifier, for: indexPath) as! GroupStatisticsCell
        
        //var group: UserGroup!

        //group = groups[indexPath.row]
        
        //cell.group = group
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        /*
        if groups.count > 7 {
            if indexPath.item == groups.count - 1 {
                fetchGroups()
            }
        }
        */
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("This is where user should be allowed to join")

    }
}

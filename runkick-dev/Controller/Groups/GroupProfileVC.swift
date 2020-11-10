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

class GroupProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, GroupProfileHeaderDelegate {
    
    // Mark: - Properties
    
    var tableView: UITableView!
    var user: User?
    let customSearchFriendsButton = UIButton(type: UIButton.ButtonType.custom)

    // here we are using the class photo feed view in order to pull up the photo we need from the subclass PhotoProfileView
    let photoProfileView: PhotoProfileView = {
        let view = PhotoProfileView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(GroupDetailCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
    }
    
    
    func setUserStats(for header: GroupProfileHeader) {
        print("handle set user stats")
    }
    
    func handleMemberDetailView(for header: GroupProfileHeader) {
        print("handle member detail view")
        
        // here you click on the top group memebers box and see their specific stats
    }
    

}

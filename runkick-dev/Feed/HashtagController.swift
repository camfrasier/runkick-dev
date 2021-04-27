//
//  HashtagController.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 10/2/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import Foundation
import Firebase
import UIKit

private let reuseIdentifier = "HashtagCell"

class HashtagController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var posts = [Post]()
    var hashtag: String?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(HashtagCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        fetchPosts()
    }
    
    // MARK: UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HashtagCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /*
        let feedVC = FeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        feedVC.viewSinglePost = true
        
        feedVC.post = posts[indexPath.item]
        
        navigationController?.pushViewController(feedVC, animated: true)
        */
        
        //let userSpecificFeedVC = UserSpecificFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        let userSpecificFeedVC = UserSpecificFeedVC()
        userSpecificFeedVC.viewSinglePost = true
        userSpecificFeedVC.post = posts[indexPath.item]
        
        navigationController?.pushViewController(userSpecificFeedVC, animated: true)
    }
    
    // MARK: - Handlers
    
    func configureNavigationBar() {
        guard let hashtag = self.hashtag else { return }
        navigationItem.title = hashtag
    }
    
    // MARK: - API
    
    func fetchPosts() {
        
        guard let hashtag = self.hashtag else { return }
        
        DataService.instance.REF_HASHTAG_POST.child(hashtag).observe(.childAdded) { (snapshot) in
            
            let postId = snapshot.key
            
            Database.fetchPost(with: postId, completion: { (post) in
                self.posts.append(post)
                self.collectionView?.reloadData()
            })
        }
    }
}

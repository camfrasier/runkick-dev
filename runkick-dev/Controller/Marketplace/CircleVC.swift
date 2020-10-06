//
//  CircleVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 9/7/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

class CircleVC: UICollectionViewController {
    
    let reuseCircleCellIdentifier = "CircleCell"
    var numberOfCells = 8
    //var currentKey: String?
    var posts = [Logos]()
    var homeVC: HomeVC?
    var checkInCell: CheckInCell?
    //var postId: String?
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        //collectionView?.collectionViewLayout = CircleCollectionViewLayout()
        
        //collectionView.register(CircleCell.self, forCellWithReuseIdentifier: reuseCircleCellIdentifier)
        
        
        fetchPosts()
        
        print("Debug: This is the new post id \(post?.postId)")
        
        // just for giggles and grins, let's show the insertion of a cell
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.collectionView?.performBatchUpdates({
                self.numberOfCells += 1
                self.collectionView?.insertItems(at: [IndexPath(item: 0, section: 0)])
            }, completion: nil)
        }
        */
        
    }
    
    // pull value from cell value
    /*
    func getPostId(_ newPostId: String) {
        postId = newPostId
        
        print("Debug: This is the new post id \(newPostId)")
    
    }
    */
    
    func fetchPosts() {

        /*
        DataService.instance.REF_POSTS.child(postId).child("logoImages").observe(.childAdded) {(snapshot: DataSnapshot) in
                     
                     //guard let childId = snapshot.key as String? else { return }
                     
                     guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                         
                     allObjects.forEach({ (snapshot) in
                         //let key = snapshot.key
         
                         Database.fetchStoreLogos(with: postId, completion: { (post) in
                             self.posts.append(post)
                             self.collectionView.reloadData()
                         })
                         
                     })
        
                 }
        
        */
        
        // initial data pull

        
        /*
        DataService.instance.REF_ACTIVITY.child(currentUid).queryLimited(toLast: 1).observe(.childAdded) {(snapshot: DataSnapshot) in
            guard let tripId = snapshot.key as String? else { return }
            
            // here i need to find the trip, the child key and image URL's
            
            DataService.instance.REF_ACTIVITY.child(currentUid).child(tripId).queryLimited(toFirst: 1).observe(.childAdded) {(snapshot: DataSnapshot) in
                
                guard let childId = snapshot.key as String? else { return }
                
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
                    
                allObjects.forEach({ (snapshot) in
                    let key = snapshot.key
    
                    Database.fetchStoreLogos(with: key, tripId: tripId, childId: childId, completion: { (post) in
                        self.posts.append(post)
                        self.collectionView.reloadData()
                    })
                })
            }
        }
  */
    }
}
 
        
// MARK: UICollectionViewDataSource

/*
extension CircleVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return numberOfCells
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCircleCellIdentifier, for: indexPath)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCircleCellIdentifier, for: indexPath) as! CircleCell
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
        print("Do something here when pressed")
    }
}
 */

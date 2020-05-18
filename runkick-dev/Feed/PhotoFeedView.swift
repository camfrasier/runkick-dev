//
//  PhotoFeedView.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 4/7/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit

// delegate to allow the photo feed view to be dismissed
protocol PhotoFeedViewDelegate {
    func dismissPhotoFeedView(withFeed post: Post?)
}

class PhotoFeedView: UIView {
    
    var delegate: PhotoFeedViewDelegate?
    
    var post: Post? {
        
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            //guard let post = self.post else { return }
            
            // using this function and the post class in order to retrieve the specific image within the cell.
            imageView.loadImage(with: imageUrl)
            
            print("post did set!!!")
            
            /*
            Database.fetchUser(with: ownerUid) { (user) in  // In order to grab the photo of the correct post owner.
                
                self.profileImageView.loadImage(with: user.profileImageURL)
                self.usernameButton.setTitle(user.username, for: .normal)
                self.firstnameButton.setTitle(user.firstname, for: .normal)
                self.configurePostCaption(user: user)
            }
            
            postImageView.loadImage(with: imageUrl)
            
            likesLabel.text = "\(likes)"
            configureLikeButton()
 
             */
        }
    }
    
    lazy var imageView: CustomImageView = {  // Using the Custom image view class.
    let iv = CustomImageView()
        //iv.contentMode = .scaleAspectFill
        iv.contentMode = .scaleAspectFit
        //iv.isUserInteractionEnabled = true
        let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(handleDismissPhoto))
        imageViewTap.numberOfTapsRequired = 1
        //iv.layer.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(imageViewTap)
        return iv
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let checkInLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    // like button
    
    // comment button
    let feedCommentButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cancelBtn"), for: .normal)
        button.addTarget(self, action: #selector(handleFeedComment), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    
    
    // MARK - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func handleFeedComment() {
        print("Handle all other gestures outside of dismiss")
        
        //guard let post = self.post else { return }
        //delegate?.dismissPhotoFeedView(withFeed: post)
    }
    
    @objc func handleDismissPhoto() {
  
            guard let post = self.post else { return }
            delegate?.dismissPhotoFeedView(withFeed: post)
    }
    
    // MARK: - Helper Functions
    
    func configureViewComponents() {
        //backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        backgroundColor = .clear
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(handleDismissPhoto))
        viewTap.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        addGestureRecognizer(viewTap)
        
        self.layer.masksToBounds = true
        
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(feedCommentButton)
        feedCommentButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
    }
}

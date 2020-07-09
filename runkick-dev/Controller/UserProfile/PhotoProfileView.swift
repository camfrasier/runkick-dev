//
//  PhotoProfileView.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 4/12/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit

class PhotoProfileView: UIView {
    
    // MARK: Properties
    
    lazy var imageView: UIImageView = {  // Using the Custom image view class.
    let iv = UIImageView()
        //iv.contentMode = .scaleAspectFill
        iv.contentMode = .scaleAspectFit
        
        
        //let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoView))
        //imageViewTap.numberOfTapsRequired = 1
        //iv.layer.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        //iv.isUserInteractionEnabled = true
        //iv.addGestureRecognizer(imageViewTap)
        return iv
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    } ()
    
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
    
    
    // MARK: - Init
    
    // making a frame parameter so that this will be a subclass of a UI view
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func handleFeedComment() {
        print("Handle feed comment or like")
        
        //guard let post = self.post else { return }
        //delegate?.dismissPhotoFeedView(withFeed: post)
    }
    
    // MARK: - Helper Functions
    
    func configureViewComponents() {
        
        backgroundColor = .blue
        
        //conforms to any modifications made to the main view
        
        self.layer.masksToBounds = true
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        containerView.layer.cornerRadius = 10
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        
        addSubview(feedCommentButton)
        feedCommentButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
    }
    
}

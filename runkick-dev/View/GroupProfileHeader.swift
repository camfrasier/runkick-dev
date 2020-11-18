//
//  GroupProfileHeader.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 11/5/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel

class GroupProfileHeader: UICollectionViewCell {
    
    let shapeLayer = CAShapeLayer()
    // Mark: - Properties
    
    var delegate: GroupProfileHeaderDelegate?
    
    
    var userGroup: UserGroup? {
        didSet {
           
            guard let photoImageUrl = userGroup?.profileImageURL else { return }
            groupProfileImageView.loadImage(with: photoImageUrl)
            
            guard let groupName = userGroup?.groupName else { return }
            self.groupnameLabel.text = groupName
            
            //guard let points = group?.points else { return }
            //self.pointsLabel.text = String(points)
            
        }
    }
    

    let groupProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        iv.image = UIImage(named: "userProfileSilhouetteWhite")
        return iv
    } ()
    
    let groupnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        return label
    } ()
    
    // i would like this label to aventually be able to pinpoint your hometown on apple maps with photos
    let groupTagline: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.rgb(red: 60, green: 60, blue: 60)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        //label.textAlignment = .left
        label.text = "I'm so, I'm so re-born.."
        return label
    } ()
    
    lazy var editGroupProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        button.layer.borderColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        button.layer.borderWidth = 0.25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        //button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    } ()
    
    let separatorView: UIView = {
        let view = UIView()
        //view.layer.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1).cgColor
        view.layer.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).cgColor
        return view
    }()
    
    lazy var chatroomLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        // add gesture recognizer
        label.text = "Chat Room"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        /*
        let chatroomTapped = UITapGestureRecognizer(target: self, action: #selector(handleChatroomTappedTapped))
        chatroomTapped.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(chatroomTapped)
        */
        return label
    }()
    
    
     override init(frame: CGRect) {
     
         super.init(frame: frame)
        
        layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        
        
        
     }
    
    // MARK: - Handlers (We want to delegate these actions to the controller).
    
   

    func configureViewComponents() {
        
       // configure view components here
        
        let profileCircleDimension: CGFloat = 95
        addSubview(groupProfileImageView)
        groupProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: profileCircleDimension, height: profileCircleDimension)
        groupProfileImageView.layer.cornerRadius = profileCircleDimension / 2
        //groupProfileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

    }
    
    func setUserStats(for user: User?) {
        
        delegate?.setUserStats(for: self)
        
    }
    
    // Mark: - Init
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//
//  GroupStatisticsCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 11/13/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit

class GroupStatisticsCell: UITableViewCell {
    
    // Mark: - Properties
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageURL else { return }
            guard let username = user?.username else { return }
            guard let firstname = user?.firstname else { return }
           guard let stepCount = user?.stepCount else { return }
            guard let distance = user?.distance else { return }
            
            profileImageView.loadImage(with: profileImageUrl)
            self.usernameLabel.text = username
            self.firstnameLabel.text = firstname
            self.stepCountLabel.text = String(stepCount)
            self.distanceLabel.text = "\(String(distance))mi"
            
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "userProfileIcon")
        iv.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        return iv
    } ()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialRoundedMTBold", size: 13)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.text = "Username"
        return label
    }()
    
    let firstnameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.text = "Firstname"
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.text = "0"
         label.numberOfLines = 0
        return label
    }()
    
    let stepCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.text = "0"
        label.numberOfLines = 0
        return label
    }()
    
    let averagePaceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.text = "13"
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        //self.textLabel?.text = "Top Users Statistics Here"
    
        self.selectionStyle = .default
        
        configureViewComponents()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        /*
        textLabel?.frame = CGRect(x: 20, y: textLabel!.frame.origin.y + 2, width: textLabel!.frame.width + 50, height: (textLabel?.frame.height)!)
        textLabel?.font = UIFont.systemFont(ofSize: 16)
        textLabel?.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        */
        
    }
    
    func configureViewComponents() {
        
        //let postImageDimension = CGFloat(35)
       // addSubview(profileImageView)
        //profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: postImageDimension, height: postImageDimension)
        //profileImageView.layer.cornerRadius = postImageDimension / 2
        //profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(distanceLabel)
        distanceLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 167, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        distanceLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(stepCountLabel)
        stepCountLabel.anchor(top: nil, left: distanceLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 80, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        stepCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(averagePaceLabel)
        averagePaceLabel.anchor(top: nil, left: stepCountLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 80, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        averagePaceLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  RewardsCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/3/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit

class RewardsCell: UITableViewCell {
    
    // Mark: - Properties
    var reward: Rewards? {
        didSet {
            guard let photoImageUrl = reward?.imageUrl else { return }
            rewardsImageView.loadImage(with: photoImageUrl)
            
            guard let storename = reward?.title else { return }
            self.storeTitleLabel.text = storename
            
            guard let category = reward?.category else { return }
            self.categoryLabel.text = category
            
            guard let points = reward?.points else { return }
            
            self.pointsLabel.text = String(points)

        }
    }
    

    let rewardsImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "userProfileIcon")
        return iv
    } ()
    
    let storeTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        //label.font = UIFont(name: "ArialRoundedMT", size: 13)
        label.font = UIFont(name: "ArialRoundedMTBold", size: 13)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.isUserInteractionEnabled = true
        return label
    } ()
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        //label.textColor = UIColor.statusBarGreenDeep()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14.5)
        return label
    } ()
    
    let tokenLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.text = "points"
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.text = "Mediterranean Cuisine"
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220).cgColor
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        self.storeTitleLabel.text = "Store Name"
    
        
        //self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let profileImageDimension = CGFloat(40)
        addSubview(rewardsImageView)
        rewardsImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: profileImageDimension, height: profileImageDimension)
        rewardsImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rewardsImageView.layer.cornerRadius = profileImageDimension / 2
        
        addSubview(storeTitleLabel)
        storeTitleLabel.anchor(top: topAnchor, left: rewardsImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(categoryLabel)
        categoryLabel.anchor(top: storeTitleLabel.bottomAnchor, left: storeTitleLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        addSubview(tokenLabel)
        tokenLabel.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)
        tokenLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(pointsLabel)
        pointsLabel.anchor(top: nil, left: nil, bottom: nil, right: tokenLabel.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 2, width: 0, height: 0)
        pointsLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
